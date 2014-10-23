class CreateIspCompanies < ActiveRecord::Migration
  def change
    create_table :isp_companies do |t|
      t.string :name

      t.timestamps
    end
  end
end
