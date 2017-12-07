class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.belongs_to :user, index: true
      t.string :plan
      t.string :location
      t.date :expireDate
      t.boolean :renew
      t.boolean :active
      t.datetime :purchaseTime
    end
  end
end
