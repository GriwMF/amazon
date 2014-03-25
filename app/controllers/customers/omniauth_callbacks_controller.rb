class Customers::OmniauthCallbacksController < ApplicationController
  def facebook
    @user = Customer.find_for_facebook_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      flash_message(:success, I18n.t("succ_facebook")) if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      flash_message(:danger, I18n.t("err_facebook"))
      redirect_to new_customer_registration_url
    end
  end
end
