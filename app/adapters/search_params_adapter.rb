# frozen_string_literal: true

# Adapter to search query
# in({ search: 'whatever_name' } -> out({ name: 'whatever_name' }) )
# in({ search: 'whatever_name@email.com' } -> out({ email: 'whatever_name@email.com' }) )
# in({ search: 'whatever_name', order: 'name' } -> out({ name: 'whatever_name', order: 'name' }) )
class SearchParamsAdapter
  attr_accessor :search_params

  REGEX_EMAIL = /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/.freeze

  def initialize(search_params)
    @search_params = search_params
  end

  def call
    extract_params
  end

  private

  def extract_params
    return if search_params[:search].blank?
    return key_email if email?(search_params[:search])

    key_name
  end

  def email?(data)
    return true unless data&.match(REGEX_EMAIL).nil?

    false
  end

  def key_name
    { name: search_params[:search].to_s }
  end

  def key_email
    { email: search_params[:search].to_s }
  end
end
