# frozen_string_literal: true

json.array!(@users) do |user|
  json.id user.id
  json.name user.name
  json.email user.email
  json.role user.role.name
end
