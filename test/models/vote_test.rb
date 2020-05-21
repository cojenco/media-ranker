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
    it "is valid when the user_id and work_id combination is unique" do
      expect(@vote.valid?).must_equal true

      vote1 = Vote.new(work_id: @nemo.id, user_id: @admin.id)        #same work_id
      expect(vote1.valid?).must_equal true

      vote3 = Vote.new(work_id: @starwars.id, user_id: @goblin.id)   #same user_id
      expect(vote3.valid?).must_equal true
    end

    it "is invalid when the user_id and work_id combination is not unique" do
      @vote.save!
      vote2 = Vote.new(work_id: @nemo.id, user_id: @goblin.id)

      expect(vote2.valid?).must_equal false
      expect(vote2.errors.messages).must_include :work_id
      expect(vote2.errors.messages[:work_id]).must_equal ["has already been taken"]
    end
  end 
end
