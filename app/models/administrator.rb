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
#  negotiation            :integer          default(0)
#  phone                  :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  type                   :string(255)      default("Depositor")
#  updated_at             :datetime
#

class Administrator < User
  has_many :sells, :foreign_key => 'user_id'
end
