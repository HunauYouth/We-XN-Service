class CreateDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :departments do |t|
      t.string :depname
      t.integer :depid
      t.integer :comid
      t.string :tell
      t.string :fax
      t.string :tellname
      t.string :address

      t.timestamps
    end
  end
end
