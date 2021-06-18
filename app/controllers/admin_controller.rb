class AdminController < ActionController::Base
  protect_from_forgery prepend: true, with: :exception
  protect_from_forgery prepend: true, with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json'}
  
  def index
  end
end
