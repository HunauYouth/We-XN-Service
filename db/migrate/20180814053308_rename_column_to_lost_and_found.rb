class RenameColumnToLostAndFound < ActiveRecord::Migration[5.1]
  def change
    rename_column :lost_and_founds, :name, :title
    add_column :lost_and_founds, :tel, :string
  end
end
