class Addcolumntoconversation < ActiveRecord::Migration
  def change
    add_column :conversations, :province_id, :integer
  end
end
