# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController do
  describe 'handling AccessDenied exceptions' do
    it 'Raise exception AccessDenied' do
      begin
        expect(ApplicationController).to
      rescue StandardError
        (CanCan::AccessDenied)
      end
      get new_user_url
    end
  end
end
