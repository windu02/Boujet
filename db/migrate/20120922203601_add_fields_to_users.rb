class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :addess_id, :integer
    add_column :users, :negociation, :integer
    add_column :users, :phone, :string
  end
end
