require 'terminal-table'

module Analyzable
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"

  def average_price(products)
    (products.inject(0){|sum, product| sum + product.price.to_f}/products.size).round(2)
  end

  def print_report(products)
    report = "PRINT SUMMARY REPORT\n"
    report += "--------------------\n"
    report += "The average price is: "
    report += "$#{average_price(products)}\n"
    report += "Stocks by brands:\n"
    count_by_brand(products).each do |key, value|
      report += "    - #{key}: #{value}\n"
    end
    report += "Stocks by names:\n"
    count_by_name(products).each do |key, value|
      report += "    - #{key}: #{value}\n"
    end
    report += "Date: #{Time.now.strftime("%Y-%d-%m")}"
    return report
  end

  [:brand, :name].each do |field|
    send(:define_method, "count_by_#{field}") do |products|
      sums = Hash.new(0)
      products.each do |product|
        value = product.send(field)
        sums[value] += 1
      end
      sums
    end
  end
end
