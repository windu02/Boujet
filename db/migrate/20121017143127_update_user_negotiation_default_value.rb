class UpdateUserNegotiationDefaultValue < ActiveRecord::Migration
  def change
    change_column :users, :negotiation, :integer, :default => 0
  end
end
