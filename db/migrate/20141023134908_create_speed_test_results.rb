class CreateSpeedTestResults < ActiveRecord::Migration
  def change
    create_table :speed_test_results do |t|
      t.references :city, index: true
      t.references :isp_company, index: true
      t.datetime :date
      t.float :download_kbps
      t.float :upload_kbps
      t.integer :total_tests
      t.float :distance_miles

      t.timestamps
    end
  end
end
