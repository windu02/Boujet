# == Schema Information
#
# Table name: users
#
#  addess_id              :integer
#  created_at             :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  firstname              :string(255)
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  lastname               :string(255)
#  negotiation            :integer
#  phone                  :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  type                   :string(255)      default("Depositor")
#  updated_at             :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :email_confirmation, :password, :password_confirmation, :remember_me, :firstname, :lastname, :phone, :type
  
  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :negotiation, :numericality => { :only_integer => true }
  
  after_create { |user| user.send_reset_password_instructions }
 
  def password_required?
	new_record? ? false : super
  end
end
