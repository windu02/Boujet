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
  
  def empty?
    if (self.street1.nil? or self.street1.empty?) and
       (self.street2.nil? or self.street2.empty?) and
       (self.street3.nil? or self.street3.empty?) and
       (self.zipcode.nil? or self.zipcode.empty?) and
       (self.city.nil? or self.city.empty?)
       
       return true
    else
        return false
    end
  end
end
