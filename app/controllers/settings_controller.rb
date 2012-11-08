class SettingsController < ApplicationController
    before_filter :check_is_admin, :only => [:index, :updateSettings]
    
    def check_is_admin
        if current_user.type != "Administrator"
            redirect_to(url_for(:controller => "depositors", :action => "show", :depositorid => current_user.id), :flash => { :error => t('actionnotauthorize') })
        end
    end
    
  def index
    @settingsMenu = true
  end
  
  def updateSettings
    @settingsMenu = true
    
    if params[:pettycash] != Settings.pettycash
        Settings.pettycash = params[:pettycash]
    end
    
    if params[:keptfees] != Settings.keptfees
        Settings.keptfees = params[:keptfees]
    end
    
    flash.now[:notice] = t('save_success')
    
    render "settings/index"
    
  end
end