require "test_helper"

describe Work do

  before do
    @work = Work.new(title: "Casablanca")
    @goblin = users(:goblin)
    @babyshark = users(:babyshark)
    @admin = users(:admin)
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

  describe "custom methods" do
    describe "top_ten" do
      it "returns an array of Works that have the top ten votes in each category" do
        top_movies = Work.top_ten(:movie)
        expect(top_movies).must_be_instance_of Array

        top_movies.each do |work|
          expect(work).must_be_instance_of Work
        end
      end
    end

    describe "max_votes" do
      it "returns one Work instance" do
        expect(Work.max_votes).must_be_instance_of Work
      end

      it "returns the Work that has the most votes" do
        @work.save!
        Vote.create!(work_id: @work.id, user_id: @goblin.id)
        Vote.create!(work_id: @work.id, user_id: @babyshark.id)

        expect(Work.max_votes).must_equal @work
        expect(Work.max_votes.votes.count).must_equal 2
      end
    end
  end 
end
