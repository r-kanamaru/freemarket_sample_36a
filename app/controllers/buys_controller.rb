class BuysController < ApplicationController
  before_action :set_item
  before_action :confirm_item_seller_and_buyer
  before_action :confirm_transaction_stage_under_sale

  include Payjp_process

  def edit
    @image = Picture.find(params[:item_id])
    @address = Address.find_by(user_id: current_user.id)
    @credit_data = show_customer_data
  end

  def update
    @item.update(buy_params)
    @payment = @item.buy_price - @item.discount_point
    create_charge(@payment)
    redirect_to edit_item_buy_path
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end
  def buy_params
    params.require(:patch).permit(:discount_point, :shipping_address_id).merge(buyer_id: current_user.id, transaction_stage: "under_transaction")
  end
  def confirm_item_seller_and_buyer
    redirect_to root_path, alert: "出品した商品を購入することはできません" if @item.seller == current_user
  end
  def confirm_transaction_stage_under_sale
    redirect_to root_path, alert: "既に販売済みの商品です" unless @item.transaction_stage == "under_sale"
  end
end
