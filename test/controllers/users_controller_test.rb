require "test_helper"

describe UsersController do
  it "must get index" do
    get users_path
    must_respond_with :success
  end

  it "must get show" do
    # get user_path(@user.id)
    # must_respond_with :success
  end

end
