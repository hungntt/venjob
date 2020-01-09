class AddInfoToRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :fname, :string
    add_column :requests, :lname, :string
    add_column :requests, :email, :string
    add_column :requests, :cv, :string
  end
end
