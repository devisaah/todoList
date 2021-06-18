class ApplicationController < ActionController::Base
    protect_from_forgery prepend: true, with: :exception
    protect_from_forgery prepend: true, with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json'}

    def after_sign_in_path_for(resource)
        if resource.class == User
            app_path
        else
            super
        end
    end

    def after_sign_out_path_for(resource)
        if resource == :user
            new_user_session_path
        else
            super
        end
    end

end
