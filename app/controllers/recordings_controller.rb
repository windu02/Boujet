class RecordingsController < ApplicationController
  before_filter :check_is_admin, :only => [:index, :depositor, :item]
    
  def check_is_admin
    if current_user.type != "Administrator"
        redirect_to(url_for(:controller => "depositors", :action => "show", :depositorid => current_user.id), :flash => { :error => t('actionnotauthorize') })
    end
  end
  
    def index
        @recordings = true
    end
    
    def depositor
        @depositor = Depositor.new
        @depositor.address = Address.new
        
        @recordings = true
    end
    
    def item
        @depositor = Depositor.find(params[:depositorid])
        @item = Item.new
        @recordings = true
    end

end
