class AddUniquenessCheckToSpeedtestDb < ActiveRecord::Migration
  def change
    add_index :speed_test_results, [:city_id, :isp_company_id, :date], unique: true, name: "uniqueness_index"
  end
end
