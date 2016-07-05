require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"

  def self.create(opts={})
    if opts[:id]
      id = opts[:id].to_i
      item = find(id)
      return item unless item == nil
    end
    item = self.new (opts)
    CSV.open(@@data_path, "ab") do |csv|
      csv << ["#{item.id}", "#{item.brand}", "#{item.name}", "#{item.price}"]
    end
    return item
  end

  def self.find(id)
    data = CSV.read(@@data_path)
    product = data.select { |line| line[0].to_i == id }
    return self.new({id: product[0][0].to_i, brand: product[0][1],
    name: product[0][2], price: product[0][3]})
  end



end
