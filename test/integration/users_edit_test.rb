require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    assert_response :success
    patch user_path(@user),
      params: {
        user: {
          name: "",
          email: "foo@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }
    assert_response :unprocessable_entity
  end
end
