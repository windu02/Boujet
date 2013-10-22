class ItemsController < ApplicationController
  before_filter :check_is_current_user_or_admin, :only => [:show]
  before_filter :check_is_admin, :only => [:create, :edit, :update, :destroy, :listall]
  
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
    @itemsMenu = true
    
    @depositor = Depositor.find(params[:depositorid])
                 
    @item = @depositor.items.find(params[:itemid])
  end
  
  def show_only
        @itemsMenu = true
        @item = Item.find(params[:itemid])
        
        if current_user.type != "Administrator" and !(current_user.type == "Depositor" and ! current_user.items.index(@item).nil?)
            redirect_to(url_for(:controller => "depositors", :action => "show", :depositorid => current_user.id), :flash => { :error => t('actionnotauthorize') })
        end
  end
  
  def create 
        @depositor = Depositor.find(params[:depositorid])
                 
        @item = @depositor.items.create(params[:item])
        
        if ! @item.save
                modifFailed = true
        end
        
        if modifFailed
                flash.now[:error] = t('save_failed')
                render :template => "recordings/item"
        else    
                flash[:notice] = t('item') + " " + @item.id.to_s + " : " + t('save_success')
                redirect_to :controller => "depositors", :action => "items", :depositorid => @depositor.id
        end
        
  end
  
  def edit
    @itemsMenu = true
    
    @depositor = Depositor.find(params[:depositorid])
                 
    @item = @depositor.items.find(params[:itemid])
  end
  
  def update
    @depositor = Depositor.find(params[:depositorid])
                 
    @item = @depositor.items.find(params[:itemid])
    
        if ! @item.update_attributes(params[:item])
                modifFailed = true
        end
        
        if modifFailed
                flash.now[:error] = t('edit_failed')
                render :template => "items/edit"
        else    
                flash[:notice] = t('edit_success')
                redirect_to :controller => "depositors", :action => "items", :depositorid => @depositor.id
        end
  end
    
  def destroy
        @depositor = Depositor.find(params[:depositorid])
                 
        @item = @depositor.items.find(params[:itemid])
        
        if ! @item.destroy
                if request.referer.nil?
                        redirect_to :user_root, :flash => { :error => t('delete_failed') }
                else
                        redirect_to request.referer, :flash => { :error => t('delete_failed') }
                end
        else
                flash[:notice] = t('delete_success')
                redirect_to :controller => "depositors", :action => "items", :depositorid => @depositor.id
        end
  end
  
  def searchindex
    @itemsMenu = true
  end
  
  def searchbyitemid
    @itemsMenu = true
    #search_condition = "%" + search + "%"
    #@results = Depositor.find(:all, :conditions => ['title LIKE ? OR description LIKE ?', search_condition, search_condition])
    
#     if params[:depid][0] != 'd'
#         @results = []
#         render :template => "depositors/searchresults"
#     else
        itemid = params[:itemid]
        @item = Item.find_by_id(itemid.to_i)
        
        if @item.nil?
            @results = []
            render :template => "items/searchresults"
        else
            redirect_to :controller => "items", :action => "show_only", :itemid => @item.id
        end
#    end
  end
  
  def searchbykeywords
    @itemsMenu = true
    
    keywords = params[:keywords].strip.squeeze(",").split(',')
    keywords.map! {|kw| "'%" + kw.downcase + "%'" }
    
    conditions = keywords.map {|kw| "lower(name) LIKE " + kw + " OR lower(type) LIKE " + kw + " OR lower(brand) LIKE " + kw + " OR lower(color) LIKE " + kw + " OR lower(other) LIKE " + kw }
    
    search_condition = conditions.join(' OR ')
    
    search_condition = '(' + search_condition + ')' + ' AND (created_at >= \'' + DateTime.new(Settings.currentyear.to_i).strftime("%F %T") + '\')'
    
    @results = Item.find(:all, :conditions => search_condition)
    
    if @results.length == 1
        redirect_to :controller => "items", :action => "show_only", :itemid => @results.first.id
    else
        render :template => "items/searchresults"
    end
  end
  
  def listall
    @itemsMenu = true

    @items = Item.where('created_at >= ?', DateTime.new(Settings.currentyear.to_i)).paginate(:page => params[:page], :per_page => 20).order(:name)
  end
end
