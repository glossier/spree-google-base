module Spree
  module VariantDecorator
    def google_base_description
      # description is limited to 5000 characters
      # see https://support.google.com/merchants/answer/188494 for details
      # description[0...5000]
      product.content(:excerpt)
    end

    def google_base_condition
      'new'
    end

    def google_base_availability
      if warehouse_count_on_hand > 0
        'in stock'
      else
        'out of stock'
      end
    end

    def google_base_brand
      'Glossier'
    end

    def google_base_gtin
      gtin
    end

    def google_base_id
      sku
    end

    def google_base_weight
      weight
    end

    def google_base_name
      product.name
    end

    def google_base_price
      product.price
    end

    def google_base_image_size
      :large
    end

    def google_base_product_category
      product.product_type
    end

    def google_base_item_group_id
      product.slug
    end

    def google_base_item_color
      option_values.first.name if option_values && option_values.first
    end

    private

    def warehouse_count_on_hand
      stock_items.where(stock_location_id: current_warehouse_id).map(&:count_on_hand).sum
    end

    def current_warehouse_id
      stock_locations.find_by(name: Rails.application.secrets.fetch(:us_warehouse_name, 'US Warehouse')).id
    end
  end
end
::Spree::Variant.prepend ::Spree::VariantDecorator
