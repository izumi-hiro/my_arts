# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :customer_state, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  def guest_sign_in
    user = Customer.guest
    sign_in user
    redirect_to customer_path(user), notice: 'guestuserでログインしました。'
  end
  protected

  def after_sign_in_path_for(resource)
    items_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def customer_state
    @customer = Customer.find_by(name: params[:customer][:name])

    return redirect_to new_customer_registration_path, notice: '名前を入力してください' if !@customer

    unless @customer.valid_password?(params[:customer][:password]) && @customer._valid?
      redirect_to new_customer_session_path, notice: '退会済みか、入力内容が無効のためログインできません'
    end
  end

end
