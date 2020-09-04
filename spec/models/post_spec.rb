RSpec.describe User, type: :model do

  describe '#posts fields' do
    let(:post) { FactoryGirl.build :post }

    it { expect(post).to be_valid }

    it 'presence of title' do
      post.title = nil
      expect(post).to_not be_valid
    end

    it 'presence of user_id' do
      post.user_id = nil
      expect(post).to_not be_valid
    end
  end

  describe '#posts association' do
    before do
      @user = FactoryGirl.create :user
      @user.save
      3.times { FactoryGirl.create :post, user: @user }
    end

    it 'destroys the associated posts on self destruct' do
      posts = @user.posts
      @user.destroy
      posts.each do |post|
        expect { Post.find(post.id) }.to raise_error Mongoid::Errors::DocumentNotFound
      end
    end
  end
end
