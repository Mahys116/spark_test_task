Deface::Override.new(virtual_path: 'spree/admin/products/index',
                     name: 'add_import_csv_button',
                     insert_before: "erb[silent]:contains('if can?(:create, Spree::Product)')",
                     partial: 'spree/admin/products/import_csv_button')
