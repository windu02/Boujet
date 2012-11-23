class SellingsController < ApplicationController
    before_filter :check_is_admin, :only => [:index, :create, :show, :showcurrent, :addItemToCurrentSell, :searchItemToSell, :removeFromCurrentSell, :editItemPrice, :currentsellpayment, :closecurrentsell, :cancelcurrentsell, :summary, :balancesheet, :statistics]
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
            soldItem = Item.find_by_id(params[:itemid])
        
            if soldItem.nil?
                flash[:error] = t('itemnotfound')
                    
                redirect_to :controller => "sellings", :action => "showcurrent"
            else
            
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
    end
    
    def searchItemToSell
        keywords = params[:keywords].strip.squeeze(",").split(',')
        keywords.map! {|kw| "'%" + kw.downcase + "%'" }
        
        conditions = keywords.map {|kw| "lower(name) LIKE " + kw + " OR lower(type) LIKE " + kw + " OR lower(brand) LIKE " + kw + " OR lower(color) LIKE " + kw + " OR lower(other) LIKE " + kw }
        
        search_condition = conditions.join(' OR ')
        
        @results = Item.find(:all, :conditions => search_condition)
        
        if @results.empty?
            flash[:error] = t('no_item_found')
            redirect_to :controller => "sellings", :action => "showcurrent"
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
        @settingsMenu = true
        
        @sells = Sell.where(:current => false)
        
        @depositors = Depositor.all
    end
    
    def statistics
        @settingsMenu = true
        
        @depositors = Depositor.order(:created_at)
        
        @depositorsWithSells = @depositors.select {|dep| dep.hasAlmostOneSell? }
        @depositorsWithSellsPercent = 0
        if @depositors.count() > 0
            @depositorsWithSellsPercent = @depositorsWithSells.count() * 100 / @depositors.count()
        end
        
        @depositorsDayData = @depositors.map {|dep| dep.created_at.strftime("%d/%m/%Y") }
        
        @depositorsDataPerDay = Array.new
        
        @depositorsDayData.each do |dd|
            id = @depositorsDataPerDay.index {|x| x[0] == dd }
            if id.nil?
                @depositorsDataPerDay.push([dd, 1])
            else
                @depositorsDataPerDay[id][1] += 1
            end
        end
        
        @depositorsDataPerDayPerHour = Array.new
        
        @depositorsDataPerDay.each do |perday|
            dd = perday[0]
            
            idDay = @depositorsDataPerDayPerHour.index {|x| x[0] == dd }
            
            if idDay.nil?
                @depositorsDataPerDayPerHour.push([dd, Array.new])
                idDay = @depositorsDataPerDayPerHour.index {|x| x[0] == dd }
            end
            
            
            depForDay = Array.new
            @depositors.each do |dep|
                if dep.created_at.strftime("%d/%m/%Y") == dd
                    depForDay.push(dep)
                end
            end
            
            depHourData = depForDay.map {|dep| dep.created_at.strftime("%H") }
            
            depHourData.each do |depHour|
                id = @depositorsDataPerDayPerHour[idDay][1].index {|x| x[0] == depHour}
                
                if id.nil?
                    @depositorsDataPerDayPerHour[idDay][1].push([depHour, 1])
                else
                    @depositorsDataPerDayPerHour[idDay][1][id][1] += 1
                end
            end
        end

        @sells = Sell.where(:current => false)

        @sellsDayData = @sells.map {|sel| sel.created_at.strftime("%d/%m/%Y") }
        
        @sellsDataPerDay = Array.new
        
        @sellsDayData.each do |dd|
            id = @sellsDataPerDay.index {|x| x[0] == dd }
            if id.nil?
                @sellsDataPerDay.push([dd, 1])
            else
                @sellsDataPerDay[id][1] += 1
            end
        end
        
        @sellsDataPerDayPerHour = Array.new
        
        @sellsDataPerDay.each do |perday|
            dd = perday[0]
            
            idDay = @sellsDataPerDayPerHour.index {|x| x[0] == dd }
            
            if idDay.nil?
                @sellsDataPerDayPerHour.push([dd, Array.new])
                idDay = @sellsDataPerDayPerHour.index {|x| x[0] == dd }
            end
            
            
            sellsForDay = Array.new
            @sells.each do |sel|
                if sel.created_at.strftime("%d/%m/%Y") == dd
                    sellsForDay.push(sel)
                end
            end
            
            sellsHourData = sellsForDay.map {|sel| sel.created_at.strftime("%H") }
            
            sellsHourData.each do |selHour|
                id = @sellsDataPerDayPerHour[idDay][1].index {|x| x[0] == selHour}
                
                if id.nil?
                    @sellsDataPerDayPerHour[idDay][1].push([selHour, 1])
                else
                    @sellsDataPerDayPerHour[idDay][1][id][1] += 1
                end
            end
        end

        @items = Item.all
        
        @soldItems = @items.select {|it| it.is_sold? }
        @soldItemsPercent = 0
        if @items.count() > 0
            @soldItemsPercent = @soldItems.count() * 100 / @items.count()
        end
        
        @itemAveragePrice = 0
        @soldItemsPercentLTAveragePrice = 0
        @soldItemsPercentGTAveragePrice = 0
        total = 0.0
        if @soldItems.count() > 0
            @soldItems.each do |si|
                total += si.price
            end 
            @itemAveragePrice = (total / @soldItems.count()).round(2)
            soldItemsNbLTAveragePrice = 0
            soldItemsNbGTAveragePrice = 0
            @soldItems.each do |si|
                if si.price <= @itemAveragePrice
                    soldItemsNbLTAveragePrice += 1
                else
                    soldItemsNbGTAveragePrice += 1
                end
            end
            @soldItemsPercentLTAveragePrice = soldItemsNbLTAveragePrice * 100 / @soldItems.count()
            @soldItemsPercentGTAveragePrice = soldItemsNbGTAveragePrice * 100 / @soldItems.count()
        end
        
        @turnover = 0
        @profit = 0
        if @soldItems.count() > 0
            @turnover = total
            @profit = @turnover*Settings.keptfees.to_f / 100
        end
        
        @averageItemPerDepositors = @items.count() / @depositors.count()
    end
end
