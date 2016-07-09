require 'terminal-table'

module Analyzable
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"

  def average_price(products)
    (products.inject(0){|sum, product| sum + product.price.to_f}/products.size).round(2)
  end

  def print_report(products)
    report = CSV.read(@@data_path)
    rows = []
    report.each do |line|
      rows << line
    end
    table = Terminal::Table.new :rows => rows
    puts "Inventory Table:"
    puts table
    puts "Stocks by brands:"
    puts count_by_brand(products)
    puts "Stocks by names:"
    puts count_by_name(products)
    print "The average price is: "
    puts "$#{average_price(products)}"
    return "Date: #{Time.now.strftime("%Y-%d-%m")}"
  end

  def count_by_brand(products)
    result = {}
    products.each do |product|
      if result.include? product.brand
        result[product.brand] += 1
      else
        result[product.brand] = 1
      end
    end
    return result
  end

  def count_by_name(products)
    result = {}
    products.each do |product|
      if result.include? product.name
        result[product.name] += 1
      else
        result[product.name] = 1
      end
    end
    return result
  end

end
