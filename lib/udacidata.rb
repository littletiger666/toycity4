require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  create_finder_methods :brand, :name
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"

  def self.create(opts={})
    item = self.new (opts)
    CSV.foreach(@@data_path) do |row|
      if row [1] == item.id
        return item
      else
        CSV.open(@@data_path, "ab") do |csv|
          csv << ["#{item.id}", "#{item.brand}", "#{item.name}", "#{item.price}"]
        end
      end
      return item
    end
  end

  def self.all
    products = []
    data = CSV.read(@@data_path).drop(1)
    data.each do |line|
      products << self.new({id: line[0], brand: line[1], name: line[2], price: line[3]})
    end
    return products
  end


  def self.find(id)
    product = self.all.find {|item| item.id == id}
    if product
      return product
    else
      raise ToyCityErrors::InvalidIdError, "not a valid ID"
    end
  end

  def self.first(id=1)
    return self.all.take(id)[0] if id == 1
    return self.all.take(id) if id > 1
  end

  def self.last(id=1)
    return self.all.reverse.take(id)[0] if id == 1
    return self.all.reverse.take(id) if id > 1
  end

  def self.destroy(id)
    product = self.find(id)
    table = CSV.table(@@data_path)
    table.delete_if do |row|
      row[0] == id
    end
    CSV.open(@@data_path, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
      table.each do |row|
        csv << row
      end
    end
    return product
  end

  def self.where(type={})
    product = []
    all = self.all
    if type[:brand]
      product = all.select {|toy| toy.brand == type[:brand]}
    elsif type[:name]
      product = all.select {|toy| toy.name == type[:name]}
    end
    return product
  end

  def update(opts={})
    self.class.destroy(self.id)
    new_brand = opts[:brand]? opts[:brand] : brand
    new_name = opts[:name]? opts[:name] : brand
    new_price = opts[:price]? opts[:price] : price
    new_product = self.class.create ({id: self.id, brand: new_brand, name: new_name, price: new_price})
    return new_product
  end

end
