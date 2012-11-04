class DepositorsController < ApplicationController
  before_filter :check_is_current_user_or_admin, :only => [:show, :edit, :update, :create, :items]
  before_filter :check_is_admin, :only => [:searchindex, :searchbydepid, :searchbyfirstlastname, :listall]

  def check_is_current_user_or_admin
    if current_user.type != "Administrator" and !(current_user.type == "Depositor" and current_user.id == params[:depositorid].to_i)
        redirect_to(url_for(:controller => "depositors", :action => "show", :depositorid => current_user.id), :flash => { :error => t('actionnotauthorize') })
    end
  end
  
  def check_is_admin
    if current_user.type != "Administrator"
        redirect_to(url_for(:controller => "depositors", :action => "show", :depositorid => current_user.id), :flash => { :error => t('actionnotauthorize') })
    end
  end
  
  def show
    @depositor = Depositor.find(params[:depositorid])
    
    if current_user.type == "Depositor" and current_user.id == @depositor.id
        @home = true
    else
        @depositorsMenu = true
    end
  end
  
  def edit
    @depositorsMenu = true
    
    @depositor = Depositor.find(params[:depositorid])
    
    if ! @depositor.update_attributes(params[:depositor])
            modifFailed = true
    end
    
    if modifFailed
            flash.now[:error] = t('edit_failed')
            render :template => "depositors/edit"
    else    
            flash[:notice] = t('edit_success')
            redirect_to :controller => "depositors", :action => "show", :depositorid => @depositor.id
    end
  end
  
  def update
    @depositor = Depositor.find(params[:depositorid])
  end
  
  def create       
        @depositor = Depositor.new(params[:depositor])
        
        if ! params[:address][:street1].empty? or
           ! params[:address][:street2].empty? or
           ! params[:address][:street3].empty? or
           ! params[:address][:zipcode].empty? or
           ! params[:address][:city].empty?
           
           @depositor.address = Address.new(params[:address])
           
           if ! @depositor.address.save
              modifFailed = true
           end
        else
            addressEmpty = true
        end

        if ! @depositor.save
                modifFailed = true
        end
        
        if modifFailed
                if addressEmpty
                    @depositor.address = Address.new
                end
                #flash[:notice] = nil
                flash.now[:error] = t('save_failed')
                render :template => "recordings/depositor"
        else
                #flash[:error] = nil
                Depositor.find(@depositor.id).send_reset_password_instructions
                
                flash[:notice] = t('save_success')
                redirect_to :controller => "recordings", :action => "item", :depositorid => @depositor.id
        end
        
  end
  
  def items
    @depositorsMenu = true
    @depositor = Depositor.find(params[:depositorid])
  end
  
  def searchindex
    @depositorsMenu = true
  end
  
  def searchbydepid
    @depositorsMenu = true
    #search_condition = "%" + search + "%"
    #@results = Depositor.find(:all, :conditions => ['title LIKE ? OR description LIKE ?', search_condition, search_condition])
    
    if params[:depid][0] != 'd'
        @results = []
        render :template => "depositors/searchresults"
    else
        depid = params[:depid].slice(1..-1)
        @dep = Depositor.find_by_id(depid.to_i)
        
        if @dep.nil?
            @results = []
            render :template => "depositors/searchresults"
        else
            redirect_to :controller => "depositors", :action => "show", :depositorid => @dep.id
        end
    end
    
  end
  
  def searchbyfirstlastname
    @depositorsMenu = true
    
    #search_condition = "%" + search + "%"
    #@results = Depositor.find(:all, :conditions => ['title LIKE ? OR description LIKE ?', search_condition, search_condition])
    
    @results = Depositor.find(:all, :conditions => ['firstname LIKE ? AND lastname LIKE ?', "%" + params[:firstname] + "%", "%" + params[:lastname] + "%"])
    
    if @results.empty?
        @results = Depositor.find(:all, :conditions => ['firstname LIKE ? OR lastname LIKE ?', "%" + params[:firstname] + "%", "%" + params[:lastname] + "%"])
    end
    
    if @results.length == 1
        redirect_to :controller => "depositors", :action => "show", :depositorid => @results.first.id
    else
        render :template => "depositors/searchresults"
    end
  end
  
  def listall
    @depositorsMenu = true
    @depositors = Depositor.all
  end
end
