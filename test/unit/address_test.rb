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

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
