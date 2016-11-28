class AddCallerToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :requester, :string
  end
end
