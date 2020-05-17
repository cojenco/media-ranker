require "test_helper"

describe Work do

  describe "validations" do
    before do
      @work = Work.new(title: "Casablanca")
    end

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
      adaptation = works(:prince)
      adaptation.category = :movie
      expect(adaptation.valid?).must_equal true
    end
  end 

  describe "relations" do
    it "can have many votes" do
    end

    it "can have many users through votes" do
    end
  end
end
