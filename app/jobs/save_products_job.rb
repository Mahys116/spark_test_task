# frozen_string_literal: true

class SaveProductsJob < ApplicationJob
  queue_as :default

  def perform(products)
    Spree::Product.import(products, recursive: true)
  end
end
