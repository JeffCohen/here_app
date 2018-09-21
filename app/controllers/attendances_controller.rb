require 'oauth/request_proxy/action_controller_request'

class AttendancesController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action      :expect_lti_params
  before_action      :verify_oauth
  before_action      :determine_role

  def index
    render "#{@role}_index"
  end



private

  def verify_oauth
    head 401 unless (verify_consumer_key && verify_consumer_secret)
  end

  def verify_consumer_secret
    key = params['oauth_consumer_key']
    secret = Rails.application.config_for(:lti)['secret']
    provider = IMS::LTI::ToolProvider.new(key, secret, params)
    provider.valid_request?(request)
  end

  def verify_consumer_key
    params['oauth_consumer_key'] == Rails.application.config_for(:lti)['key']
  end

  def expect_lti_params
    %w(oauth_signature_method oauth_timestamp
       oauth_nonce oauth_version
       context_id context_title
       launch_presentation_return_url
       lis_person_name_given lti_message_type lti_version
       resource_link_id roles user_id oauth_signature).each do |lti_param_name|
         head 401 if params[lti_param_name].blank?
      end
  end

  def determine_role
    @role = 'student'
    if params['roles'].downcase.split(',').index('instructor')
      @role = 'instructor'
    end
  end
end
