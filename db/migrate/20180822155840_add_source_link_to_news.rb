class AddSourceLinkToNews < ActiveRecord::Migration[5.1]
  def change
    add_column :news, :source_link, :string
  end
end
