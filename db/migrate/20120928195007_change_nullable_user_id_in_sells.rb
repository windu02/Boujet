class ChangeNullableUserIdInSells < ActiveRecord::Migration
  def change
    change_column :sells, :user_id, :integer, :null => true
  end
end
