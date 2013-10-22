class ModifyUserNegotiationField < ActiveRecord::Migration
  def up
    remove_column :users, :negociation
    add_column :users, :negotiation, :integer
  end

  def down
    remove_column :users, :negotiation
    add_column :users, :negociation, :integer
  end
end
