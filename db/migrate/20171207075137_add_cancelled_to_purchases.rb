class AddCancelledToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :cancelled, :boolean
  end
end
