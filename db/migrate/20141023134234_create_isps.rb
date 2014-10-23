class CreateIsps < ActiveRecord::Migration
  def change
    create_table :isps do |t|
      t.references :city, index: true
      t.references :isp_company, index: true
      t.float :download_kbps
      t.float :upload_kbps

      t.timestamps
    end
  end
end
