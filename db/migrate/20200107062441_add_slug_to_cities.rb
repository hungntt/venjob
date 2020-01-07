class AddSlugToCities < ActiveRecord::Migration[6.0]
  def change
    add_column :cities, :slug, :string
    add_index :cities, :slug, unique: true
  end
end
