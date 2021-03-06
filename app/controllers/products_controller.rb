class ProductsController < ApplicationController
    before_action :validate_search_key, only: [:search]

    def search
        if @query_string.present?
            search_result = Product.ransack(@search_criteria).result(distinct: true)
            @products = search_result.paginate(page: params[:page], per_page: 50)
        else
            redirect_to :back
        end
    end

    # def index
    #     if params[:category].blank?
    #         @products = Product.all
    #
    #     else
    #         @category_id = Category.find_by(name: params[:category]).id
    #         @products = Product.where(category_id: @category_id)
    #     end
    # end

    def index
      if params[:category].blank?
       @products = case params[:order]
       when 'by_product_price'
             Product.includes(:photos).order('price DESC')
       when 'by_product_quantity'
             Product.includes(:photos).order('quantity DESC')
       when 'by_product_like'
             Product.includes(:photos).order('like DESC')
           else
             Product.includes(:photos).order('created_at DESC')
           end
     else
       @category_id = Category.find_by(name: params[:category]).id
       @products = Product.includes(:photos).where(:category_id => @category_id)
     end
  end

    def show
        @product = Product.find(params[:id])
        @photos = @product.photos.all
    end

    def add_to_cart
        @product = Product.find(params[:id])
        if !current_cart.products.include?(@product)
            current_cart.add_product_to_cart(@product)
            flash[:notice] = "你已成功将 #{@product.title} 加入购物车"
        else
            flash[:warning] = '你的购物车内已有此物品'
      end

        redirect_to :back
    end




    protected

    def validate_search_key
        @query_string = params[:query_string].gsub(/\\|\'|\/|\?/, '') if params[:query_string].present?
        @search_criteria = search_criteria(@query_string)
    end

    def search_criteria(query_string)
        { title_or_description_cont: query_string }
    end
end
