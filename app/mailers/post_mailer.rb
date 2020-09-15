class PostMailer < ApplicationMailer
  default from: 'no-reply@marketplace.com'

  def send_confirmation(post)
    @post = post
    user = @post.user

    # @content = render('send_confirmation')
    mail(to: user.email, subject: 'Post Subject')
  end
end
