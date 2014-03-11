module BooksHelper
  def render_rating(rating)
    html = ''
    gold_star = '<span class="glyphicon glyphicon-star gold-star"></span>'
    empty_star = '<span class="glyphicon glyphicon-star-empty gray-star"></span>'
    5.times { |i| html += i >= rating ? empty_star : gold_star }
    html.html_safe
  end
end
