module Analyzable

  def average_price(products)
    result = 0
    products.each do |product|
      result += product.price.to_f
    end
    return (result/products.length).round(2)
  end
end
