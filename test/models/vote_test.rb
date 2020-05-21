require "test_helper"

describe Vote do
  before do
    @goblin = users(:goblin)
    @babyshark = users(:babyshark)
    @admin = users(:admin)
    @prince = works(:prince)
    @vote = Vote.new(work_id: @prince.id, user_id: @admin.id )
  end

  describe "validations" do
    it "is valid when the user_id and work_id combination is unique" do
      expect(@vote.valid?).must_equal true
    end

    it "is invalid without a title" do
      # invalid_work = works(:toystory)
      # invalid_work.title = nil
      # expect(invalid_work.valid?).must_equal false
      # expect(invalid_work.errors.messages).must_include :title
      # expect(invalid_work.errors.messages[:title]).must_equal ["can't be blank"]
    end

    it "is invalid with a non-unique title in the same category" do
      # @work.title = "Toy Story"
      # @work.category = :movie
      # expect(@work.valid?).must_equal false
      # expect(@work.errors.messages).must_include :title
      # expect(@work.errors.messages[:title]).must_equal ["has already been taken"]
    end

    it "is valid with a non-unique title in a different category" do
      # adaptation = works(:prince)  # fixture: category is book
      # adaptation.category = :movie
      # expect(adaptation.valid?).must_equal true
    end
  end 


end
