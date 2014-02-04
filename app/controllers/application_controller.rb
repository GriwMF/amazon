class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
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
end
