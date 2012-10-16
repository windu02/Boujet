# == Schema Information
#
# Table name: items
#
#  brand      :string(255)
#  color      :string(255)
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string(255)
#  other      :text
#  price      :float
#  sell_id    :integer
#  type       :string(255)
#  updated_at :datetime
#  user_id    :integer
#

class Item < ActiveRecord::Base
    belongs_to :user
    belongs_to :sell
    
    attr_accessible :name, :type, :brand, :color, :price, :other
    
    validates :name, :presence => true
    validates :price, :presence => true, :numericality => true
    
    self.inheritance_column = :item_type
    
    def is_sold?
        ! self.sell.nil?
    end
    
end
