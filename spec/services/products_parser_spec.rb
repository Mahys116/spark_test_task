require 'rails_helper'

describe ProductsParser do
  let(:service_call) { ProductsParser.new(file).call }
  before(:each) do
    Spree::ShippingCategory.create(name: 'Default')
    Spree::StockLocation.create(name: 'Default')
  end

  context 'parse valid file' do
    let(:file) { fixture_file_upload('spec/fixtures/files/sample.csv') }

    it { expect(service_call[:products].size).to eq(3) }
    it { expect(service_call[:products].map(&:valid?).uniq).to eq([true]) }
    it { expect(service_call[:total_lines_count]).to eq(21) }
    it { expect(service_call[:error_lines_count]).to eq(18) }
  end

  context 'parse file without header' do
    let(:file) { fixture_file_upload('spec/fixtures/files/samlple_without_header.csv') }

    it { expect(service_call[:products].size).to eq(0) }
    it { expect(service_call[:total_lines_count]).to eq(0) }
    it { expect(service_call[:error_lines_count]).to eq(0) }
  end

  context 'parse file with wrong header' do
    let(:file) { fixture_file_upload('spec/fixtures/files/samle_with_wrong_header.csv') }

    it { expect(service_call[:products].size).to eq(0) }
    it { expect(service_call[:total_lines_count]).to eq(21) }
    it { expect(service_call[:error_lines_count]).to eq(21) }
  end
end
