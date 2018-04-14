  # Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def confirmation_email
    UserMailer.with(user_id: User.first.id).confirmation_email
  end
end
