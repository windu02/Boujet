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

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
