class AddPricesToIsps < ActiveRecord::Migration
  def change
    add_column :isps, :cable_price, :float, default: 0
  end
end
