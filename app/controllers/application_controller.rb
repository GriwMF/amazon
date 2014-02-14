class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end
  
  def current_ability
    @current_ability ||= Ability.new(current_customer)
  end

  def after_sign_in_path_for(resource)
   root_path
  end
  
  protected
  
  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
  def configure_devise_permitted_parameters
    registration_params = [:firstname, :lastname, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end
end
