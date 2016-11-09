class AddUnsoldreturnToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :unsoldreturn, :string, :default => ""
  end
end
