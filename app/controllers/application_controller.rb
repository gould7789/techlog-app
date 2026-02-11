class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # 닉네임 입력 설정을 위함
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 회원가입(sign_up)시 :nickname이라는 컬럼을 permit(허락)해준다는 뜻
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :nickname ])
  end
end
