require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path
    # 現在のRailsのバージョンでは存在しないメソッド
    # 同じメソッドを使う場合はrails-controller-testingを追加
    # assert_template "static_pages/home"
    assert_response :success
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end
end
