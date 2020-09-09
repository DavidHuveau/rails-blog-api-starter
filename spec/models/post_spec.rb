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

  describe '.filter_by_title' do
    before(:all) do
      @post1 = FactoryGirl.create :post, title: 'A plasma TV'
      @post2 = FactoryGirl.create :post, title: 'Fastest Laptop'
      @post3 = FactoryGirl.create :post, title: 'CD player'
      @post4 = FactoryGirl.create :post, title: 'LCD TV'
    end

    context "when a 'TV' title pattern is sent" do
      it 'returns the 2 posts matching' do
        expect(Post.filter_by_title('tv').count).to eq 2
        expect(Post.filter_by_title('TV')).to match_array([@post1, @post4])
      end
    end
  end

  describe '.recent' do
    before(:all) do
      @post1 = FactoryGirl.create :post, title: 'abcd'
      @post2 = FactoryGirl.create :post, title: 'a'
      @post3 = FactoryGirl.create :post, title: 'abcde'
      @post4 = FactoryGirl.create :post, title: 'abc'
      # we will touch some posts to update them
      @post2.touch
      @post3.touch
    end

    it 'returns the most updated records' do
      expect(Post.recent[0..3].map(&:id)).to eq([@post3, @post2, @post4, @post1].map(&:id))
    end
  end

  describe '.search' do
    before(:all) do
      @post1 = FactoryGirl.create :post, title: 'game boy'
      @post2 = FactoryGirl.create :post, title: 'ds'
      @post3 = FactoryGirl.create :post, title: 'Game gear'
    end

    it 'when no match' do
      search_hash = { keyword: 'videogame' }
      expect(Post.search(search_hash)).to be_empty
    end

    it 'when match' do
      search_hash = { keyword: 'game' }
      expect(Post.search(search_hash).count).to eq 2
      expect(Post.search(search_hash)).to match_array([@post1, @post3])
    end

    it 'when an empty hash is sent' do
      expect(Post.search({})).to eq Post.all.to_a
    end

    it 'when post_ids is present' do
      search_hash = { post_ids: [@post1.id, @post2.id] }
      expect(Post.search(search_hash)).to match_array([@post1, @post2])
    end
  end
end
