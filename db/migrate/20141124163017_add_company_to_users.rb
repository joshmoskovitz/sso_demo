class AddCompanyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company, :string, :null => false
  end
end
