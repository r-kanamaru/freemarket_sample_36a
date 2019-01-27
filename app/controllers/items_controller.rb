class ItemsController < ApplicationController
  protect_from_forgery except: [:dynamic_upper_category, :dynamic_middle_category, :dynamic_lower_category]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_new_item, only: [:new, :dynamic_upper_category, :dynamic_middle_category, :dynamic_lower_category]
  before_action :move_to_sign_in, except: [:dynamic_upper_category, :dynamic_middle_category, :dynamic_lower_category]

  def dynamic_upper_category
    @middle_categories = MiddleCategory.where(upper_category_params)
  end
  def dynamic_middle_category
    @lower_categories = LowerCategory.where(middle_category_params)
  end
  def dynamic_lower_category
    @sizes = LowerCategory.find(params[:item][:lower_category_id]).middle_category.size_type.sizes
  end

  def index
    @items = Item.all
  end

  def show
  end

  def new
    @upper_categories = UpperCategory.all.includes([middle_categories: :lower_categories])
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    @item.transaction_stage = 0
    @item.seller_id = current_user.id
    if @item.save
      redirect_to root_path, notice: 'Item was successfully saved.'
    else
      render :new
    end
  end

  def update
    if @item.update(item_params)
      redirect_to root_path, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to root_path, notice: 'Item was successfully destroyed.'
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end
    def set_new_item
      @item = Item.new
    end
    def item_params
      params.require(:item).permit(
        :name,
        :description,
        :state,
        :delivery_payer,
        :delivery_region,
        :delivery_duration,
        :buy_price,
        :commission_price,
        :sell_price,
        :commition_price,
        :tranzaction_stage,
        :like_count,
        :size_id,
        :brand_id,
        :upper_category_id,
        :middle_category_id,
        :lower_category_id,
        :seller_id,
        :buyer_id,
        pictures_attributes: [:content]
      )
    end
    def upper_category_params
      params.require(:item).permit(:upper_category_id)
    end
    def middle_category_params
      params.require(:item).permit(:middle_category_id)
    end
end
