class HomeController < ApplicationController
  
  def index
  	if user_signed_in?
  		if current_user.type == "Depositor"
  			redirect_to :controller => "depositors", :action => "show", :depositorid => current_user.id
  		else
  			redirect_to :controller => "users", :action => "index"
  		end
    else
        @home = true
  	end
  end
  
end
