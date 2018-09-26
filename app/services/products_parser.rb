require 'csv'

class ProductsParser
  
  attr_reader :csv, :products, :total_lines_count, :error_lines_count

  PRODUCT_HEADER = Spree::Product.new.attributes.keys
  COLUMN_SEPARATE = ';'
  
  def initialize(csv)
    @csv = csv
    @products = []
    @error_lines_count = 0
    @total_lines_count = 0
    @default_category_id = Spree::ShippingCategory.find_by_name('Default').id
    @stock_location_id = Spree::StockLocation.last.id
  end

  def call
    parse_csv! if header_valid?
    {
      products: products,
      total_lines_count: total_lines_count,
      error_lines_count: error_lines_count
    }
  end

  private

  def parse_csv!
    CSV.foreach(csv.path, headers: true, col_sep: COLUMN_SEPARATE, skip_blanks: true) do |row|
      @total_lines_count += 1
      if row.to_hash.compact.size == 0
        @error_lines_count += 1
        next 
      end
      product = Spree::Product.new(product_attributes(row))
      product.master.stock_items.build(stock_location_id: @stock_location_id, count_on_hand: row['stock_total'])
      product.validate
      if product.valid?
        @products << product
      else
        @error_lines_count += 1
      end
    end
  end

  def product_attributes(row)
    attributes = row.to_hash.compact.extract!(*PRODUCT_HEADER)
    attributes['price'] = attributes['price'].to_f
    attributes['shipping_category_id'] = Spree::ShippingCategory.find_by_name(row['category'])&.id || @default_category_id
    attributes.except('category', 'stock_total')
  end

  def header_valid?
    (CSV.read(csv.path, headers: true, col_sep: COLUMN_SEPARATE).headers.compact & PRODUCT_HEADER).size > 0
  end
end
