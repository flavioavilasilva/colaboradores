# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do
    flash[:error] = 'Access denied!'
    redirect_to unauthenticated_root_url
  end
end
