class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, 
    :omniauthable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist, 
    :authentication_keys => [:login], omniauth_providers: %i[facebook google_oauth2]
    attr_accessor :login

    mount_uploader :avatar, PhotoUploader

    attr_writer :login
    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value OR lower(name) = :value', {value: login.strip.downcase}]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_h).first
      end
    end

    def devise_mailer
      DeviseMailer
    end

    def self.from_omniauth(auth)
      user = User.where(email: auth.info.email).first
      if user.nil? 
        user = User.new 
        user.provider = auth.provider 
        user.uid = auth.uid 
        user.name = auth.info.name 
        user.email = auth.info.email 
        user.password = Devise.friendly_token[0, 20]
        user.remote_avatar_url = auth.info.image
        user.save!
      end

      user 
    end


  


    private
      def self.current=(user)
        Thread.current[:current_user] = user
      end

    def self.current
      Thread.current[:current_user]
    end
  

end
