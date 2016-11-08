class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail(to: @user.to_email, from: '"Daniel from Tangueros" <hello@tangueros.club>', subject: 'Welcome to Tangueros 🙌')
  end
end
