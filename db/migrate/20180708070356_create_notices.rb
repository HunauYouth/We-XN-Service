class CreateNotices < ActiveRecord::Migration[5.1]
  def change
    create_table :notices do |t|
      t.string :notice
      t.integer :status

      t.timestamps
    end
  end
end
