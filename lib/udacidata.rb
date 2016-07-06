require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  create_finder_methods :brand, :name
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

  def self.all
    products = []
    data = CSV.read(@@data_path).drop(1)
    data.each do |line|
      products << self.new({id: line[0], brand: line[1], name: line[2], price: line[3]})
    end
    return products
  end


  def self.find(id)
    data = CSV.read(@@data_path)
    if id > data.length-1
      raise ToyCityErrors::InvalidIdError, "not a valid ID"
    else
      product = data.select { |line| line[0].to_i == id }
      return self.new ({id: product[0][0].to_i, brand: product[0][1],
      name: product[0][2], price: product[0][3]})
    end
  end

  def self.first(id=1)
    result = self.all.first(id)
    if result.length == 1
      return result[0]
    else
      return result
    end
  end

  def self.last(id=1)
    result = self.all.last(id)
    if result.length == 1
      return result[0]
    else
      return result
    end
  end

  def self.destroy(id)
    product = self.find(id)
    data = CSV.read(@@data_path)
    data.delete_at(product.id)
    CSV.open(@@data_path, "wb") do |csv|
      data.each do |product|
        csv << product
      end
    end
    return product
  end

  def self.find_by_brand(brand)
    data = CSV.read(@@data_path)
    product = data.select { |line| line[1] == brand }
    return self.new ({id: product[0][0].to_i, brand: product[0][1],
    name: product[0][2], price: product[0][3]})
  end

  def self.find_by_name(name)
    data = CSV.read(@@data_path)
    product = data.select { |line| line[2] == name }
    return self.new ({id: product[0][0].to_i, brand: product[0][1],
    name: product[0][2], price: product[0][3]})
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
    new_id = opts[:id]? opts[:id] : self.id
    new_brand = opts[:brand]? opts[:brand] : self.brand
    new_name = opts[:name]? opts[:name] : self.brand
    new_price = opts[:price]? opts[:price] : self.price
    all = self.class.all
    new_product = all[new_id-1]
    new_product.id = new_id
    new_product.brand = new_brand
    new_product.name = new_name
    new_product.price = new_price
    CSV.open(@@data_path, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
    end
    CSV.open(@@data_path, "ab") do |csv|
      all.each do |product|
        csv << ["#{product.id}", "#{product.brand}", "#{product.name}", "#{product.price}"]
      end
    end
    return new_product
  end

end
