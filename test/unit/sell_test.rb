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

require 'test_helper'

class SellTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
