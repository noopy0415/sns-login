class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    auth = request.env["omniauth.auth"]
    @user = User.where(provider: auth.provider, provider_uid: auth.uid).first
    unless @user
      # ユーザが無い場合は作成
      @user = User.create(
          name:     auth.extra.raw_info.name,
          email:    dummy_email(auth),
          provider: auth.provider,
          provider_token:    auth.credentials.token,
          provider_uid: auth.uid,
          password: Devise.friendly_token[0,20],
          encrypted_password:[*1..9, *'A'..'Z', *'a'..'z'].sample(10).join,
          agreement: true
      )
    end

    if @user.persisted?
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def twitter
    # You need to implement the method below in your model
    auth = request.env["omniauth.auth"]
    @user = User.where(provider: auth.provider, provider_uid: auth.uid).first
    unless @user
      # ユーザが無い場合は作成
      @user = User.create(
          name:     auth.info.nickname,
          email:    dummy_email(auth),
          provider: auth.provider,
          provider_token:    auth.credentials.token,
          provider_uid: auth.uid,
          password: Devise.friendly_token[0,20],
          encrypted_password:[*1..9, *'A'..'Z', *'a'..'z'].sample(10).join,
          agreement: true
      )
    end

    if @user.persisted?
      set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end

  def line
    auth = request.env["omniauth.auth"]
    @user = User.where(provider: auth.provider, provider_uid: auth.uid).first
    unless @user
      # ユーザが無い場合は作成
      @user = User.create(
          name:     auth.info.name,
          email:    dummy_email(auth),
          provider: auth.provider,
          provider_token:    auth.credentials.token,
          provider_uid: auth.uid,
          password: Devise.friendly_token[0,20],
          encrypted_password:[*1..9, *'A'..'Z', *'a'..'z'].sample(10).join,
          agreement: true
      )
    end

    if @user.persisted?
      set_flash_message(:notice, :success, kind: "Line") if is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.line_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end

  private

  def dummy_email(auth)
    "#{auth.provider}-#{auth.uid}@example.com"
  end
end