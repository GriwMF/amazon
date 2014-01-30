json.array!(@books) do |book|
  json.extract! book, :id, :title, :descirption, :price, :in_stock
  json.url book_url(book, format: :json)
end
