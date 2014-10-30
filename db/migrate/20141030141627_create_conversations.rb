class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :user_name
      t.references :isp, index: true
      t.references :city, index: true
      t.text :feedback

      t.timestamps
    end
  end
end
