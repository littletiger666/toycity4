require 'faker'

# This file contains code that populates the database with
# fake data for testing purposes

def db_seed
  20.times do
    # you will write the "create" method as part of your project
    opts = {brand: Faker::Company.name,
                  name: Faker::Commerce.product_name,
                  price: Faker::Commerce.price
    }
    Product.create(opts)
  end
end
