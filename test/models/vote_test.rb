require "test_helper"

describe Vote do
  before do
    @goblin = users(:goblin)
    @admin = users(:admin)
    @starwars = works(:starwars)
    @nemo = works(:nemo)
    @vote = Vote.new(work_id: @nemo.id, user_id: @goblin.id)
  end

  describe "validations" do
    it "is valid when the user_id and work_id combination is presence and unique" do
      expect(@vote.valid?).must_equal true

      vote1 = Vote.new(work_id: @nemo.id, user_id: @admin.id)        #same work_id
      expect(vote1.valid?).must_equal true

      vote3 = Vote.new(work_id: @starwars.id, user_id: @goblin.id)   #same user_id
      expect(vote3.valid?).must_equal true
    end

    it "is invalid when the work_id is missing" do
      @vote.work_id = nil
      expect(@vote.valid?).must_equal false
      expect(@vote.errors.messages).must_include :work
      expect(@vote.errors.messages[:work]).must_equal ["must exist"]
    end

    it "is invalid when the user_id is missing" do
      @vote.user_id = nil
      expect(@vote.valid?).must_equal false
      expect(@vote.errors.messages).must_include :user
      expect(@vote.errors.messages[:user]).must_equal ["must exist"]
    end

    it "is invalid when the user_id and work_id combination is not unique" do
      @vote.save!
      vote2 = Vote.new(work_id: @nemo.id, user_id: @goblin.id)

      expect(vote2.valid?).must_equal false
      expect(vote2.errors.messages).must_include :work_id
      expect(vote2.errors.messages[:work_id]).must_equal ["has already been taken"]
    end
  end 

  describe "relations" do
    it "belongs to one user" do
      @vote.save
      expect(@vote.user).must_be_instance_of User
      expect(@vote.user).must_equal @goblin
    end

    it "belongs to one work" do
      @vote.save
      expect(@vote.work).must_be_instance_of Work
      expect(@vote.work).must_equal @nemo
    end
  end
end