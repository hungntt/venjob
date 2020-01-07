class AddSlugToIndustries < ActiveRecord::Migration[6.0]
  def change
    add_column :industries, :slug, :string
    add_index :industries, :slug, unique: true
  end
end
