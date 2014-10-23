class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.references :province, index: true
      t.string :name
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
