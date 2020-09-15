RSpec.describe PostMailer, type: :mailer, focus: true do
  include Rails.application.routes.url_helpers

  describe '.send_confirmation' do
    before(:all) do
      @user = FactoryGirl.create :user
      @post = FactoryGirl.create :post, user: @user
      @post_mailer = PostMailer.send_confirmation(@post)
    end

    it 'should be set to be delivered to the user from the post' do
      expect(@post_mailer).to deliver_to(@user.email)
    end

    it 'should be set to be send from no-reply@marketplace.com' do
      expect(@post_mailer).to deliver_from('no-reply@marketplace.com')
    end

    it "should contain the user's message in the mail body" do
      expect(@post_mailer).to have_body_text(/Post: ##{@post.id}/)
    end

    it 'should have the correct subject' do
      expect(@post_mailer).to have_subject(/Post Subject/)
    end
  end
end
