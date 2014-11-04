class RemoveCityIndexFromConversations < ActiveRecord::Migration
  def change
    remove_index :conversations, column: ["city_id"]
  end
end
