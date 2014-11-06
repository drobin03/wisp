class Fixcolumnname < ActiveRecord::Migration
  def change
    rename_column :conversations, :feedback, :body
  end
end
