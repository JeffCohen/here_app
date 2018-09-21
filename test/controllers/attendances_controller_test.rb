require 'test_helper'

class AttendancesControllerTest < ActionDispatch::IntegrationTest

  def oauth_params(params = {})
    { "oauth_consumer_key"=>"key",
      "oauth_signature_method"=>"HMAC-SHA1",
      "oauth_timestamp"=>"1534987364",
      "oauth_nonce"=>"JdoPRdJDgOoYuNl10fHB1yrwFS1JRuDk28yd2zDgLs",
      "oauth_version"=>"1.0",
      "context_id"=>"uniquecontextid",
      "context_title"=>"Example Course",
      "custom_message_from_sinatra"=>"hey from the sinatra example consumer",
      "launch_presentation_return_url"=>"http://localhost:9393/tool_return",
      "lis_person_name_given"=>"Jeff",
      "lti_message_type"=>"basic-lti-launch-request",
      "lti_version"=>"LTI-1.0",
      "resource_link_id"=>"uniqueresourceidentifier",
      "roles"=>"Instructor,Admin",
      "tool_consumer_instance_name"=>"Example Consumer",
      "user_id"=>"7f15f1ad99c489dc0314952535e424d5",
      "oauth_signature"=>"fmypuF+H/mskEGd9X/E5d0MtNLk=" }.merge(params)
  end

  test "requires at least one role" do
    post launch_url, params: oauth_params
    assert_response :success

    post launch_url, params: oauth_params(roles: "")
    assert_response :unauthorized
  end

  test "accepts valid OAuth params" do
    post launch_url, params: oauth_params
    assert_response :success
  end

  test "rejects invalid OAuth signature" do
    post launch_url, params: oauth_params(oauth_signature: 'john_hancock')
    assert_response :unauthorized
  end

  test "GET not accepted for launch" do
    assert_raises ActionController::RoutingError do
      get launch_url
    end
  end

end
