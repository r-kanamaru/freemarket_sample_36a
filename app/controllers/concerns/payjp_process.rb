module Payjp_process

  def create_customer
    require 'payjp'
    Payjp.api_key = Rails.application.secrets.payjp_private_key
    year = "20" + params[:credit][:limit_year]
    token = Payjp::Token.create({
    card: {
      number: params[:credit][:credit_number],
      cvc: params[:credit][:security_code],
      exp_month: params[:credit][:limit_month],
      exp_year: year,
    }},
      {
        'X-Payjp-Direct-Token-Generate': 'true'
      }
    )
    customer = Payjp::Customer.create(card: token.id)
  end

  def create_charge(buy_price)
    customer_id = Credit.find_by(user_id: current_user.id).customer_id
    require 'payjp'
    Payjp.api_key = Rails.application.secrets.payjp_private_key
    Payjp::Charge.create(
      amount: buy_price,
      customer: customer_id,
      currency: 'jpy',
    )
  end

  def show_customer_data
    require 'payjp'
    Payjp.api_key = Rails.application.secrets.payjp_private_key
    @credit = Credit.find_by(user_id: current_user.id)
    @user_credit = Payjp::Customer.retrieve(@credit.customer_id).cards.data[0] if @credit.present?
  end

end
