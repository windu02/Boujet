class AddSellIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :sell_id, :integer
  end
end
