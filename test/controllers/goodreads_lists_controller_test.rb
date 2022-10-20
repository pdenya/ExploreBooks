require "test_helper"

class GoodreadsListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @goodreads_list = goodreads_lists(:one)
  end

  test "should get index" do
    get goodreads_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_goodreads_list_url
    assert_response :success
  end

  test "should create goodreads_list" do
    assert_difference('GoodreadsList.count') do
      post goodreads_lists_url, params: { goodreads_list: { description: @goodreads_list.description, goodreads_id: @goodreads_list.goodreads_id, name: @goodreads_list.name } }
    end

    assert_redirected_to goodreads_list_url(GoodreadsList.last)
  end

  test "should show goodreads_list" do
    get goodreads_list_url(@goodreads_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_goodreads_list_url(@goodreads_list)
    assert_response :success
  end

  test "should update goodreads_list" do
    patch goodreads_list_url(@goodreads_list), params: { goodreads_list: { description: @goodreads_list.description, goodreads_id: @goodreads_list.goodreads_id, name: @goodreads_list.name } }
    assert_redirected_to goodreads_list_url(@goodreads_list)
  end

  test "should destroy goodreads_list" do
    assert_difference('GoodreadsList.count', -1) do
      delete goodreads_list_url(@goodreads_list)
    end

    assert_redirected_to goodreads_lists_url
  end
end
