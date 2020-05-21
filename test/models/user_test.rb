require "test_helper"

describe User do
  before do
    @toystory = works(:toystory) 
    @thriller = works(:thriller)
    @nemo = works(:nemo)
    @babyshark = users(:babyshark)
    @user = User.new(username: "dory")
  end

  describe "validations" do
    it "is valid as long as the username is present" do
      expect(@user.valid?).must_equal true
    end

    it "is invalid without a username" do
      @babyshark.username = nil
      expect(@babyshark.valid?).must_equal false
      expect(@babyshark.errors.messages).must_include :username
      expect(@babyshark.errors.messages[:username]).must_equal ["can't be blank"]
    end

    it "is invalid with a non-unique username" do
      @user.username = "babyshark"
      expect(@user.valid?).must_equal false
      expect(@user.errors.messages).must_include :username
      expect(@user.errors.messages[:username]).must_equal ["has already been taken"]
    end
  end 

  describe "relations" do
    it "can have many votes" do
      @user.save!
      Vote.create!(work_id: @toystory.id, user_id: @user.id)
      Vote.create!(work_id: @thriller.id, user_id: @user.id)
      expect(@user.votes.count).must_equal 2

      expect {
        Vote.create!(work_id: @nemo.id, user_id: @user.id)
      }.must_differ "@user.votes.count", 1

      @user.votes.each do |vote|
        expect(vote).must_be_instance_of Vote
      end
    end

    it "can have many works through votes" do
      @user.save!
      Vote.create!(work_id: @toystory.id, user_id: @user.id)
      Vote.create!(work_id: @thriller.id, user_id: @user.id)

      @user.votes.each do |vote|
        voted_work = Work.find_by(id: vote.work_id)
        expect(voted_work).must_be_instance_of Work
      end
    end
  end
end
