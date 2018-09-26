require 'rails_helper'

RSpec.describe Spree::Admin::ProductsController, type: :controller do
  stub_authorization!
  routes { Spree::Core::Engine.routes }
  before(:each) do
    Spree::ShippingCategory.create(name: 'Default')
    Spree::StockLocation.create(name: 'Default')
  end

  describe 'POST import' do
    context 'successfull import' do
      it 'return notice' do
        post :import, params: {
          file: fixture_file_upload('spec/fixtures/files/sample.csv')
        }
        expect(response).to redirect_to(admin_products_path)
        expect(flash[:notice]).to eq('Import products from CSV complete. Total lines: 21, imported: 3, failed: 18')
        expect(Spree::Product.count).to eq(3)
      end
    end

    context 'failed import' do
      it 'return error' do
        post :import, params: {
          file: fixture_file_upload('spec/fixtures/files/samle_with_wrong_header.csv')
        }
        expect(response).to redirect_to(admin_products_path)
        expect(flash[:error]).to eq("Couldn't import products, please check CSV file.")
        expect(Spree::Product.count).to eq(0)
      end
    end
  end
end
