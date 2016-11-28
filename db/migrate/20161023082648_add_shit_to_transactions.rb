class AddShitToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :total_payers, :string
    add_column :transactions, :already_paid, :string
  end
end
