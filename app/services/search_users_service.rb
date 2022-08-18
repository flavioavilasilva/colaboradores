# frozen_string_literal: true

# Service to search users with querys
class SearchUsersService
  attr_accessor :query_params

  def initialize(query_params)
    @query_params = query_params
  end

  def call
    return User.all if query_params.nil? || query_params[:search].blank?

    params = SearchParamsAdapter.new(query_params).call
    query_user = User.where(params) if params.present?

    query_user.order(order)
  end

  private

  def order
    return %i[name asc] unless query_params[:order].present?

    [query_params[:order].to_sym, :asc]
  end
end
