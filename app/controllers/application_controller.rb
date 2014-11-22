class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    :dashboard
  end  

  # def after_sign_in_path_for(resource)
  #   dashboard(resource)
  # end

  # map.user_root '/users', :controller => 'users' # creates user_root_path
  
  # map.namespace :user do |user|
  #   user.root :controller => 'users' # creates user_root_path
  # end

end
