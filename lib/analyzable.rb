require 'terminal-table'

module Analyzable
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"

  def average_price(products)
    result = 0
    products.each do |product|
      result += product.price.to_f
    end
    return (result/products.length).round(2)
  end

  def print_report(products)
    report = CSV.read(@@data_path)
    rows = []
    report.each do |line|
      rows << line
    end
    table = Terminal::Table.new :rows => rows
    puts table
    return "tablized report above"
  end

  def count_by_brand(products)
    return {products[0].brand => products.length}
  end

  def count_by_name(products)
    return {products[0].name => products.length}
  end

end
