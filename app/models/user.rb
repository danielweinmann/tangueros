class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]
  has_attached_file :profile_image, styles: { medium: "300x300#", thumb: "100x100#" }
  validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\Z/
  validates :first_name, presence: true
  validates :last_name, presence: true
  has_many :loves
  has_many :dismissals

  reverse_geocoded_by :latitude, :longitude do |user, results|
    if result = results.first
      user.address = result.address
      user.city = result.city
      user.state = result.state_code
      user.country = result.country_code
    end
  end

  after_validation :reverse_geocode, if: ->(user){ user.latitude && user.longitude && (user.latitude_changed? || user.longitude_changed?) }

  def self.visible
    where("((facebook_image_url IS NOT NULL AND facebook_image_url <> '') OR (profile_image_file_name IS NOT NULL AND profile_image_file_name <> '')) AND latitude IS NOT NULL AND longitude IS NOT NULL")
  end

  def self.not_loved_by(user)
    where("id NOT IN (SELECT loved_user_id FROM loves WHERE user_id = #{user.id})")
  end

  def self.not_dismissed_by(user)
    where("id NOT IN (SELECT dismissed_user_id FROM dismissals WHERE user_id = #{user.id})")
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.facebook_image_url = auth.info.image
    end
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
    @image_url ||= ((profile_image.present? && profile_image.url((thumb ? :thumb : :medium))) || (facebook_image_url && "#{facebook_image_url}#{ '?type=large' unless thumb }")) || 'user.png'
  end

  def country_name
    ISO3166::Country.new(self.country).name
  end
end
