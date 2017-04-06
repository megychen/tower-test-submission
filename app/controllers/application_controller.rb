class ApplicationController < ActionController::Base
  #include Pundit
  include PublicActivity::StoreController
  include CanCan::ControllerAdditions
  
  protect_from_forgery with: :exception

end
