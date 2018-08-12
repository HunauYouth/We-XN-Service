class CreateLostAndFounds < ActiveRecord::Migration[5.1]
  def change
    create_table :lost_and_founds do |t|
      t.string :name
      t.integer :stu_user_id
      t.string :describe
      t.string :pic
      t.integer :category
      t.integer :status

      t.timestamps
    end
  end
end
