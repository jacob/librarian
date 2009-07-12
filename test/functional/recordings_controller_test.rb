require 'test_helper'

class RecordingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recordings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recording" do
    assert_difference('Recording.count') do
      post :create, :recording => { }
    end

    assert_redirected_to recording_path(assigns(:recording))
  end

  test "should show recording" do
    get :show, :id => recordings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => recordings(:one).to_param
    assert_response :success
  end

  test "should update recording" do
    put :update, :id => recordings(:one).to_param, :recording => { }
    assert_redirected_to recording_path(assigns(:recording))
  end

  test "should destroy recording" do
    assert_difference('Recording.count', -1) do
      delete :destroy, :id => recordings(:one).to_param
    end

    assert_redirected_to recordings_path
  end
end
