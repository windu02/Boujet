class SellingsController < ApplicationController
    before_filter :check_is_admin, :only => [:index, :create, :show, :showcurrent, :addItemToCurrentSell, :searchItemToSell, :removeFromCurrentSell, :editItemPrice, :currentsellpayment, :closecurrentsell, :cancelcurrentsell, :summary]
    before_filter :getAdministratorFromCurrentUser, :only => [:create, :show, :showcurrent]
    before_filter :getCurrentSell, :only => [:index, :create, :showcurrent, :addItemToCurrentSell, :searchItemToSell, :removeFromCurrentSell, :editItemPrice, :currentsellpayment, :closecurrentsell, :cancelcurrentsell]
    
    def check_is_admin
        if current_user.type != "Administrator"
            redirect_to(url_for(:controller => "depositors", :action => "show", :depositorid => current_user.id), :flash => { :error => t('actionnotauthorize') })
        end
      end
    
    def getAdministratorFromCurrentUser
        @administrator = Administrator.find(current_user.id)
    end
    
    def getCurrentSell
        @results = Sell.find(:all, :conditions => ['user_id = ? AND current = ?', current_user.id, true])
    
        if @results.empty?
            @currentSell = nil
        else
            @currentSell = @results.first
        end
    end
    
    def index
        @sellMenu = true
    end
    
    def create
       if @currentSell.nil?

           @sell = @administrator.sells.create()
           @sell.current = true
           @sell.total = 0
           @sell.payment = ""
           @sell.cashdone = 0
           @sell.save
           
           redirect_to :controller => "sellings", :action => "showcurrent"
       
       else
           redirect_to(url_for(:controller => "sellings", :action => "index"), :flash => { :error => t('actionnotauthorize') })
       end
    end
    
    def addItemToCurrentSell
        if @currentSell.nil?
           redirect_to(url_for(:controller => "sellings", :action => "index"), :flash => { :error => t('actionnotauthorize') })       
       else
            soldItem = Item.find(params[:itemid])
            
            if soldItem.is_sold?
                flash[:error] = t('itemalreadysold')
                
                redirect_to :controller => "sellings", :action => "showcurrent"
            else
               @currentSell.items.push(soldItem)
               
                if ! @currentSell.save
                        modifFailed = true
                end
                
                if modifFailed
                        flash[:error] = t('save_failed')
                else
                        flash[:notice] = t('save_success')
                end
                redirect_to :controller => "sellings", :action => "showcurrent"
            end
       end
    end
    
    def searchItemToSell
        keywords = params[:keywords].strip.squeeze(",").split(',')
        keywords.map! {|kw| "'%" + kw + "%'" }
        
        conditions = keywords.map {|kw| "name LIKE " + kw + " OR type LIKE " + kw + " OR brand LIKE " + kw + " OR color LIKE " + kw + " OR other LIKE " + kw }
        
        search_condition = conditions.join(' OR ')
        
        @results = Item.find(:all, :conditions => search_condition)
        
        if @results.empty?
            flash[:error] = t('no_item_found')
            redirect_to :controller => "items", :action => "show_only", :itemid => @results.first.id
        else
            render :template => "sellings/searchItemToSell"
        end
    end
    
    def removeFromCurrentSell
       if @currentSell.nil?
            redirect_to(url_for(:controller => "sellings", :action => "index"), :flash => { :error => t('actionnotauthorize') })
       end
       
       delItem = Item.find(params[:itemid])
       
       if delItem.sell.id == @currentSell.id
        delItem.sell = nil
        delItem.save
        
        flash[:notice] = t('edit_success')
       else
        flash[:notice] = t('edit_failed')
       end
              
       redirect_to :controller => "sellings", :action => "showcurrent"
    end
    
    def editItemPrice
        if @currentSell.nil?
            redirect_to(url_for(:controller => "sellings", :action => "index"), :flash => { :error => t('actionnotauthorize') })
       end
       
       editedItem = Item.find(params[:itemid])
       
       if editedItem.sell.id == @currentSell.id
        editedItem.price = params[:item][:price]
        
        if ! editedItem.save
                modifFailed = true
        end
        
        if modifFailed
                flash.now[:error] = t('edit_failed')
                @item = editedItem
                render :template => "sellings/edititemprice"
        else    
                flash[:notice] = t('edit_success')
                redirect_to :controller => "sellings", :action => "showcurrent"
        end
        
       else
        flash[:notice] = t('edit_failed')
        redirect_to :controller => "sellings", :action => "showcurrent"
       end
    end
    
    def show
        @sellMenu = true
        @sell = Sell.find(params[:sellid])
    end
    
    def showcurrent
        @sellMenu = true
        
       if @currentSell.nil?
            redirect_to(url_for(:controller => "sellings", :action => "index"), :flash => { :error => t('actionnotauthorize') })
       else
            @sell = @currentSell
            
            render "sellings/show"
       end
    end
    
    def currentsellpayment
        if @currentSell.nil?
            redirect_to(url_for(:controller => "sellings", :action => "index"), :flash => { :error => t('actionnotauthorize') })
       end
    end
    
    def cancelcurrentsell
        if @currentSell.nil?
            redirect_to(url_for(:controller => "sellings", :action => "index"), :flash => { :error => t('actionnotauthorize') })
        else
            @currentSell.items.each do |item|
                item.sell = nil
                item.save
            end
            
            @currentSell.destroy
            
            redirect_to(url_for(:controller => "sellings", :action => "index"), :flash => { :notice => t('cancelsuccess') })
        end
    end
    
    def closecurrentsell
        @sellMenu = true
        
        if @currentSell.nil?
            redirect_to(url_for(:controller => "sellings", :action => "index"), :flash => { :error => t('actionnotauthorize') })
        else
            total = 0.0
            
            @currentSell.items.each do |item|
                total += item.price
            end
            
            params[:sell]['total'] = total
            params[:sell]['current'] = false
            
            if ! @currentSell.update_attributes(params[:sell])
                    modifFailed = true
            end
            
            if modifFailed
                    flash.now[:error] = t('edit_failed')
                    render :template => "sellings/currentsellpayment"
            else    
                    flash[:notice] = t('edit_success')
                    redirect_to :controller => "sellings", :action => "index"
            end
        end
    end
    
    def balancesheet
        @settings = true
        
        @sells = Sell.where(:current => false)
    end
    
    def statistics
        @depositors = Depositor.all
        
        @depositorsWithSells = @depositors.select {|dep| dep.hasAlmostOneSell? }
        @depositorsWithSellsPercent = 0
        if @depositors.count() > 0
            @depositorsWithSellsPercent = @depositorsWithSells.count() * 100 / @depositors.count()
        end
        
        @depositorsDayData = @depositors.map {|dep| dep.created_at.strftime("%F") }
        
        @depositorsData = Array.new
        
        @depositorsDayData.each do |dd|
            id = @depositorsData.index {|x| x[0] == dd }
            if id.nil?
                @depositorsData.push([dd, 1])
            else
                @depositorsData[id][1] += 1
            end
        end
        
        @sells = Sell.where(:current => false)
        
        @sellsHourData = @sells.map {|sel| sel.created_at.strftime("%H") }
        
        @sellsData = Array.new
        
        @sellsHourData.each do |dd|
            id = @sellsData.index {|x| x[0] == dd }
            if id.nil?
                @sellsData.push([dd, 1])
            else
                @sellsData[id][1] += 1
            end
        end
        
        @items = Item.all
        
        @soldItems = @items.select {|it| it.is_sold? }
        @soldItemsPercent = 0
        if @items.count() > 0
            @soldItemsPercent = @soldItems.count() * 100 / @items.count()
        end
    end
end
