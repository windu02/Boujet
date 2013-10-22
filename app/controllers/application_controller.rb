class ApplicationController < ActionController::Base
  protect_from_forgery
  
    
  before_filter :set_locale
 
	def set_locale
	
		logger.debug "REQUEST: " + request.user_preferred_languages.to_s
	
	  if params[:locale] && ['fr', 'en'].include?(params[:locale])
	  	I18n.locale = params[:locale]
	  else
	  	headerLocal = request.user_preferred_languages

	  	if headerLocal.length > 0
	  		first = headerLocal[0].scan(/^[a-z]{2}/).first 	
		  	if ['fr', 'en'].include?(first)
		  		I18n.locale = first
		  	else
		  		I18n.locale = I18n.default_locale
		  	end
		 else
		 	I18n.locale = I18n.default_locale
		 end

	  end
	  
	  logger.debug "* Locale set to '#{I18n.locale}'"
	  
	end
	
	def default_url_options(options={})
	  logger.debug "default_url_options is passed options: #{options.inspect}\n"
	  { :locale => I18n.locale }
	end
end
