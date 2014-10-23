class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.references :country, index: true
      t.string :name
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
