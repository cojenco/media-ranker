require "test_helper"

describe Work do

  before do
    @work = Work.new(title: "Casablanca")
  end

  describe "validations" do
    it "is valid as long as the title is present" do
      expect(@work.valid?).must_equal true
    end

    it "is invalid without a title" do
      invalid_work = works(:toystory)
      invalid_work.title = nil
      expect(invalid_work.valid?).must_equal false
    end

    it "is invalid with a non-unique title in the same category" do
      @work.title = "Toy Story"
      @work.category = :movie
      expect(@work.valid?).must_equal false
    end

    it "is valid with a non-unique title in a different category" do
      adaptation = works(:prince)  # fixture: category is book
      adaptation.category = :movie
      expect(adaptation.valid?).must_equal true
    end
  end 

  describe "relations" do
    before do
      @goblin = users(:goblin)
      @babyshark = users(:babyshark)
      @admin = users(:admin)
    end

    it "can have many votes" do
      @work.save!
      Vote.create!(work_id: @work.id, user_id: @goblin.id)
      Vote.create!(work_id: @work.id, user_id: @babyshark.id)
      expect(@work.votes.count).must_equal 2

      expect {
        Vote.create!(work_id: @work.id, user_id: @admin.id)
      }.must_differ "@work.votes.count", 1

      @work.votes.each do |vote|
        expect(vote).must_be_instance_of Vote
      end
    end

    it "can have many users through votes" do
      @work.save!
      Vote.create!(work_id: @work.id, user_id: @goblin.id)
      Vote.create!(work_id: @work.id, user_id: @babyshark.id)

      @work.votes.each do |vote|
        voted_user = User.find_by(id: vote.user_id)
        expect(voted_user).must_be_instance_of User
      end
    end
  end
end
