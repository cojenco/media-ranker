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
      expect(invalid_work.errors.messages).must_include :title
      expect(invalid_work.errors.messages[:title]).must_equal ["can't be blank"]
    end

    it "is invalid with a non-unique title in the same category" do
      @work.title = "Toy Story"
      @work.category = :movie
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :title
      expect(@work.errors.messages[:title]).must_equal ["has already been taken"]
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

    it "is associated with votes and user so in case a user is destroyed the vote count will decrease" do
      @work.save!
      Vote.create!(work_id: @work.id, user_id: @goblin.id)
      Vote.create!(work_id: @work.id, user_id: @babyshark.id)
      expect(@work.votes.count).must_equal 2

      expect {
        @goblin.destroy
      }.must_differ "@work.votes.count", -1
    end
  end

  describe "custom methods" do
    describe "top_ten" do
      it "returns an array of Works that have the top ten votes in each category" do
        top_movies = Work.top_ten(:movie)
        expect(top_movies).must_be_instance_of Array
        expect(top_movies.size).must_equal 10

        top_movies.each do |work|
          expect(work).must_be_instance_of Work
        end
      end

      it "returns the top ten works in descending fashion with the first work to have most votes" do
        # from the fixture setting, max vote is movie Toy Story
        top_work = works(:toystory)
        top_votes = top_work.votes.count
        expect(Work.top_ten(:movie).first).must_equal top_work
        expect(Work.top_ten(:movie).first.votes.count).must_equal top_votes
      end

      it "returns an array of all works if there are less than 10 works in a category" do
        total_books = Work.where(category: :book).count
        top_books = Work.top_ten(:book)
        expect(top_books).must_be_instance_of Array
        expect(top_books.size).must_equal total_books

        top_books.each do |work|
          expect(work).must_be_instance_of Work
        end
      end

      it "returns an empty array if there are no works in a category" do
        @thriller = works(:thriller)
        @thriller.destroy
        top_albums = Work.top_ten(:album)
        expect(top_albums).must_be_instance_of Array
        expect(top_albums.size).must_equal 0
      end
    end

    describe "max_votes" do
      it "returns one Work that has the most votes" do
        # from the fixture setting, max vote is movie Toy Story
        top_work = works(:toystory)
        top_votes = top_work.votes.count
        expect(Work.max_votes).must_be_instance_of Work
        expect(Work.max_votes).must_equal top_work
        expect(Work.max_votes.votes.count).must_equal top_votes
      end

      it "returns nil when there are no works in database" do
        Work.destroy_all
        expect(Work.count).must_equal 0
        expect(Work.max_votes).must_be_nil
      end
    end

    describe "category sort" do
      it "returns an array with the same quantity of works within the category" do
        total_movies = Work.where(category: :movie).count
        expect(Work.category_sort(:movie).size).must_equal total_movies
        total_books = Work.where(category: :book).count
        expect(Work.category_sort(:book).size).must_equal total_books
        total_albums = Work.where(category: :album).count
        expect(Work.category_sort(:album).size).must_equal total_albums

        Work.category_sort(:movie).each do |work|
          expect(work).must_be_instance_of Work
        end
      end

      it "sorts each category by votes count (desc) so the first work to have most votes" do
        # from the fixture setting, max vote movie is movie Toy Story
        top_movie = works(:toystory)
        movie_votes = top_movie.votes.count
        expect(Work.category_sort(:movie).first).must_equal top_movie
        expect(Work.category_sort(:movie).first.votes.count).must_equal movie_votes
        
        # from the fixture setting, max vote book is The Little Prince
        top_book = works(:prince)
        book_votes = top_book.votes.count
        expect(Work.category_sort(:book).first).must_equal top_book
        expect(Work.category_sort(:book).first.votes.count).must_equal book_votes
      end
    end
  end 
end