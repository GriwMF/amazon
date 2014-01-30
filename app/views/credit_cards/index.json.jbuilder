json.array!(@credit_cards) do |credit_card|
  json.extract! credit_card, :id, :firstname, :lastname, :number, :cvv, :expiration_month, :expiration_year
  json.url credit_card_url(credit_card, format: :json)
end
