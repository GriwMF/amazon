json.array!(@addresses) do |address|
  json.extract! address, :id, :country, :address, :zipcode, :city, :phone
  json.url address_url(address, format: :json)
end
