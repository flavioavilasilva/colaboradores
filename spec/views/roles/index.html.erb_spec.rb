# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'roles/index', type: :view do
  before(:each) do
    @roles = [Role.create!(name: 'Admin User', description: 'Can perform any CRUD operation on any resource')]
  end

  it 'renders a list of roles' do
    render
    assert_select 'div#roles' do |elements|
      elements.each do |element|
        assert_select element, 'div#role_1', 1
      end
    end
  end
end
