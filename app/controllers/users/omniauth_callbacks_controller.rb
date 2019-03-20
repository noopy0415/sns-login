class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    callback_for(:google)
  end

  def facebook
    callback_for(:facebook)
  end

  def twitter
    callback_for(:twitter)
  end

  def line
    callback_for(:line)
  end

  private

  def callback_for(provider)
    auth = request.env["omniauth.auth"]
    @user = User.where(provider: auth.provider, provider_uid: auth.uid).first
    unless @user
      @user = User.create(family_name:        auth.info.name,
                          given_name:         auth.info.name,
                          email:              "#{auth.provider}-#{auth.uid}@example.com",
                          provider:           auth.provider,
                          provider_token:     auth.credentials.token,
                          provider_uid:       auth.uid,
                          password:           Devise.friendly_token[0,20],
                          encrypted_password: [*1..9, *'A'..'Z', *'a'..'z'].sample(10).join
                          )
    end
    if @user.persisted?
      set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end