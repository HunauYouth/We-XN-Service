class Updatecolumntonews < ActiveRecord::Migration[5.1]
  def change
    rename_column :news, :comment_count, :category
  end
end
