# == Schema Information
#
# Table name: sells
#
#  cashdone   :float
#  created_at :datetime
#  current    :boolean          default(TRUE), not null
#  id         :integer          not null, primary key
#  payment    :string(255)
#  total      :float
#  updated_at :datetime
#  user_id    :integer
#

class Sell < ActiveRecord::Base
    belongs_to :user
    
    has_many :items
    
    attr_accessible :current, :total, :payment, :cashdone
    
    validates :total, :numericality => true
    validates :cashdone, :numericality => true
    validates :payment, :inclusion => { :in => ["cheque", "cash", ""] }
end
