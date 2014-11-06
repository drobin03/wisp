class CreateConversationsAgain < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :user_name
      t.text :subject
      t.text :body
      t.references :isp_company, index: true
      t.references :city, index: true
      t.references :province, index: true

      t.timestamps
    end
  end
end
