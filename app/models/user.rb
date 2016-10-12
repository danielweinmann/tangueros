class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]
  has_attached_file :profile_image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\Z/
  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.facebook_image_url = auth.info.image
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def thumb_url
    image_url(true)
  end

  def image_url(thumb = false)
    @image_url ||= ((profile_image.present? && profile_image.url((thumb ? :thumb : :medium))) || (facebook_image_url && "#{facebook_image_url}#{ '?type=large' unless thumb }"))
  end

end
