class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    resource.user? ? root_path : applies_admin_path
  end
end
