require 'test_helper'

class LandscapersControllerTest < ActionController::TestCase
  setup do
    @landscaper = landscapers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:landscapers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create landscaper" do
    assert_difference('Landscaper.count') do
      post :create, landscaper: { description: @landscaper.description, email: @landscaper.email, first_name: @landscaper.first_name, last_name: @landscaper.last_name, middle_initial: @landscaper.middle_initial, primary_phone: @landscaper.primary_phone, rating: @landscaper.rating, secondary_phone: @landscaper.secondary_phone }
    end

    assert_redirected_to landscaper_path(assigns(:landscaper))
  end

  test "should show landscaper" do
    get :show, id: @landscaper
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @landscaper
    assert_response :success
  end

  test "should update landscaper" do
    put :update, id: @landscaper, landscaper: { description: @landscaper.description, email: @landscaper.email, first_name: @landscaper.first_name, last_name: @landscaper.last_name, middle_initial: @landscaper.middle_initial, primary_phone: @landscaper.primary_phone, rating: @landscaper.rating, secondary_phone: @landscaper.secondary_phone }
    assert_redirected_to landscaper_path(assigns(:landscaper))
  end

  test "should destroy landscaper" do
    assert_difference('Landscaper.count', -1) do
      delete :destroy, id: @landscaper
    end

    assert_redirected_to landscapers_path
  end
end
