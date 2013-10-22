# == Schema Information
#
# Table name: settings
#
#  created_at  :datetime
#  id          :integer          not null, primary key
#  target_id   :integer
#  target_type :string(30)
#  updated_at  :datetime
#  value       :text
#  var         :string(255)      not null
#

class Setting < ActiveRecord::Base
  
end
