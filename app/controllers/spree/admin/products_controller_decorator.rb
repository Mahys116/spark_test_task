Spree::Admin::ProductsController.class_eval do
  def import
    respond = ProductsParser.new(params[:file]).call
    if !respond[:products].empty?
      Spree::Product.import(respond[:products], recursive: true)
      flash[:notice] = Spree.t('flash.import_csv_complete', total: respond[:total_lines_count], imported: respond[:products].size, failed: respond[:error_lines_count])
    else
      flash[:error] = Spree.t('flash.import_csv_error')
    end
    redirect_to admin_products_path
  end
end
