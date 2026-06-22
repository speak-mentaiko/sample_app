require "test_helper"

class UsersLogin < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
end

class InvalidPasswordTest < UsersLogin
  test "login path" do
    get login_path
    assert_response :success
  end

  test "login with invalid information" do
    post login_path, params: { session: { email: "", password: "" } }
    assert_not is_logged_in?
    assert_response :unprocessable_entity
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with invalid email" do
    post login_path, params: { session: { email: "", password: "password" } }
    assert_not is_logged_in?
    assert_response :unprocessable_entity
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with invalid password" do
    post login_path, params: { session: { email: @user.email, password: "" } }
    assert_not is_logged_in?
    assert_response :unprocessable_entity
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end

class ValidLoginTest < UsersLogin
  def setup
    super
    post login_path, params: {
      session: { email:    @user.email, password: "password" }
    }
  end

  test "valid login" do
    assert is_logged_in?
    assert_redirected_to @user
  end

  test "redirect after login" do
    follow_redirect!
    assert_response :success
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end

class LogoutTest < UsersLogin
  def setup
    super
    delete logout_path
  end

  test "successful logout" do
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
  end

  test "login with valid information" do
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
