class AddExpiredToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :expired, :boolean, default: false
  end
end
