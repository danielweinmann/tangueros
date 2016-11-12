class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]
  has_attached_file :profile_image, styles: { medium: "300x300#", thumb: "100x100#" }
  validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\Z/
  validates :first_name, presence: true
  validates :last_name, presence: true
  has_many :loves
  has_many :dismissals
  has_many :notifications

  reverse_geocoded_by :latitude, :longitude do |user, results|
    if result = results.first
      user.address = result.address
      user.city = result.city
      user.state = result.state_code
      user.country = result.country_code
    end
  end

  after_validation :reverse_geocode, if: ->(user){ user.latitude && user.longitude && (user.latitude_changed? || user.longitude_changed?) }

  after_create do
    SendFacebookInviteNotificationJob.set(wait: 30.minutes).perform_later(self)
    UserMailer.welcome(self).deliver_later(wait: 2.seconds)
  end

  def self.visible
    where(active: true).where("((facebook_image_url IS NOT NULL AND facebook_image_url <> '') OR (profile_image_file_name IS NOT NULL AND profile_image_file_name <> '')) AND latitude IS NOT NULL AND longitude IS NOT NULL")
  end

  def self.not_loved_by(user)
    where("id NOT IN (SELECT loved_user_id FROM loves WHERE user_id = #{user.id})")
  end

  def self.not_dismissed_by(user)
    where("id NOT IN (SELECT dismissed_user_id FROM dismissals WHERE user_id = #{user.id})")
  end

  def self.with_roles_prefered_by(user)
    if user.follower? && user.leader?
      where("follower = true OR leader = true")
    elsif user.follower?
      where("leader = true")
    elsif user.leader?
      where("follower = true")
    end
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.facebook_image_url = auth.info.image
      user.facebook_token = auth.credentials.token
    end
    unless user.facebook_token.present?
      user.update facebook_token: auth.credentials.token
    end
    user
  end

  def to_param
    "#{self.id}-#{self.full_name.parameterize}"
  end

  def does_love?(user)
    !Love.where("user_id = #{self.id} AND loved_user_id = #{user.id}").empty?
  end

  def does_dismiss?(user)
    !Dismissal.where("user_id = #{self.id} AND dismissed_user_id = #{user.id}").empty?
  end

  def does_match?(user)
    !Match.where("(user_id = #{self.id} AND matched_user_id = #{user.id}) OR (user_id = #{user.id} AND matched_user_id = #{self.id})").empty?
  end

  def lovers
    Love.where("loved_user_id = #{self.id}")
  end

  def matches
    Match.where("user_id = #{self.id} OR matched_user_id = #{self.id}")
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def thumb_url
    image_url(true)
  end

  def image_url(thumb = false)
    size = (thumb ? 100 : 300)
    @image_url ||= ((profile_image.present? && profile_image.url((thumb ? :thumb : :medium))) || (facebook_image_url && "#{facebook_image_url}?width=#{size}&height=#{size}")) || 'user.png'
  end

  def country_name
    return unless self.country
    ISO3166::Country.new(self.country).name
  end

  def to_email
    "\"#{self.full_name}\" <#{self.email}>"
  end

  def just_signed_up?
    self.created_at > 1.hour.ago
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later(wait: 2.seconds)
  end

  def send_facebook_notification(content, href)
    return unless self.provider == 'facebook' && self.uid.present?
    graph = Koala::Facebook::API.new(Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']).get_app_access_token)
    graph.put_connections(self.uid, "notifications", template: content, href: href)
  end

end
