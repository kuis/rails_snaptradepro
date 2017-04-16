class ApplicationController < ActionController::Base
  include Pundit
  helper FilepickerRails::Engine.helpers
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  after_action :verify_authorized
  before_action :load_organization
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def authenticate_admin_user!
    redirect_to root_path unless current_user.admin?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:accept_invitation).concat([:first_name, :last_name])
  end

  def current_organization
    current_user.current_organization = @organization
    @organization
  end
  helper_method :current_organization

  def load_organization
    if params[:organization_id].present?
      org_id = params[:organization_id]
      session[:organization_id] = org_id.to_s
    elsif session[:organization_id].present?
      org_id = session[:organization_id]
    end
    @organization = Organization.find(org_id.downcase) rescue nil
  end

  def prepare_selectable_columns_data
    session[:columns] = session[:columns] || {}
    session[:columns]["column1"] =  params[:column1] unless params[:column1].nil?
    session[:columns]["column2"] =  params[:column2] unless params[:column2].nil?
    session[:columns]["column3"] =  params[:column3] unless params[:column3].nil?
    session[:columns]["column5"] =  params[:column5] unless params[:column5].nil?
    session[:columns]["column6"] =  params[:column6] unless params[:column6].nil?
  end

end
