require "test_helper"

describe ApplicationHelper, :helper do
  describe "readable_date" do
    it "produces a tag with the full timestamp in the title params" do
      date = Date.today - 7
      result = readable_date(date)
      expect(result).must_include date.to_s
    end

    it "returns an empty string if the date is nil" do
      date = nil
      result = readable_date(date)
      expect(result).must_equal ""
    end
  end
end