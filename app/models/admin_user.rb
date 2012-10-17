# == Schema Information
#
# Table name: admin_users
#
#  created_at             :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  updated_at             :datetime
#

class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
#  after_create { |admin| admin.send_reset_password_instructions }
 
#	def password_required?
#	  new_record? ? false : super
#	end
	
end
