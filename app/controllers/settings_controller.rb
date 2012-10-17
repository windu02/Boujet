class SettingsController < ApplicationController
    before_filter :check_is_admin, :only => [:index, :updateSettings]
    
    def check_is_admin
        if current_user.type != "Administrator"
            redirect_to(url_for(:controller => "depositors", :action => "show", :depositorid => current_user.id), :flash => { :error => t('actionnotauthorize') })
        end
      end
    
  def index
    @settings = true
  end
  
  def updateSettings
    @settings = true
    
    if params[:pettycash] != Settings.pettycash
        Settings.pettycash = params[:pettycash]
    end
    
    flash.now[:notice] = t('save_success')
    
    render "settings/index"
    
  end
end