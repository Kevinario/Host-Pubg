class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.belongs_to :user, index: true
      t.string :plan
      t.string :location
      t.date :expireDate
      t.boolean :active
      t.datetime :purchaseTime
      t.boolean :cancelled
    end
  end
end
