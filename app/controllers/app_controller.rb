class AppController < ActionController::Base
  protect_from_forgery prepend: true, with: :exception
  protect_from_forgery prepend: true, with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json'}

  layout 'app'
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, :set_current_user
  after_action :flash_to_headers, :unset_current_user
  

  def index
  end


  def flash_to_headers
    return unless request.xhr?
    response.headers['X-Message'] = flash_message
    response.headers["X-Message-Type"] = flash_type.to_s
    flash.discard # don't want the flash to appear when you reload page
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:email,:avatar,:username,:password,:password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:remember_me, :login, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name,:email,:avatar,:username,:password,:password_confirmation])
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    sign_out_user
  end
  
  private
    def flash_message
      [:error, :warning, :notice].each do |type|
        return flash[type] unless flash[type].blank?
      end
    end

    def flash_type
      [:error, :warning, :notice].each do |type|
        return type unless flash[type].blank?
      end
    end

    def set_current_user
      User.current = current_user
    end

    def unset_current_user
      User.current = nil
    end

end
