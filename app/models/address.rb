# == Schema Information
#
# Table name: addresses
#
#  city       :string(255)
#  created_at :datetime
#  id         :integer          not null, primary key
#  street1    :string(255)
#  street2    :string(255)
#  street3    :string(255)
#  updated_at :datetime
#  user_id    :integer
#  zipcode    :string(255)
#

class Address < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :street1, :street2, :street3, :zipcode, :city
end
