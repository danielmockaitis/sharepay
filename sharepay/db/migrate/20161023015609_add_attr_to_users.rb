class AddAttrToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fullname, :string
    add_column :users, :phone, :string
    add_column :users, :email, :string
    add_column :users, :password, :string
    add_column :users, :credit_card_num, :string
    add_column :users, :ccv, :string
    add_column :users, :expiration, :string
  end
end
