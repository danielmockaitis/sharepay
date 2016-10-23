class AddAttrToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :price, :string
    add_column :transactions, :virtual_credit_card, :string
  end
end
