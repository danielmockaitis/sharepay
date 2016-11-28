class AddTokenToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :card_token, :string
  end
end
