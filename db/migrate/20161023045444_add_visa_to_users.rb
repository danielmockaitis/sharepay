class AddVisaToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :funding_source_token, :string
    add_column :users, :funding_source_address, :string
  end
end
