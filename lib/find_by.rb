class Module
  def create_finder_methods(*attributes)
    # Your code goes here!
    # Hint: Remember attr_reader and class_eval
    attributes.each do |type|
      method = %Q{
        def self.find_by_#{type}(value)
          data = self.all
          product = data.select { |item| item.#{type} == value }
          return product[0]
        end
      }
      class_eval(method)
    end
  end
end
