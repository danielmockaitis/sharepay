class AddCcvToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :ccv, :string
    add_column :transactions, :expiration, :string
  end
end
