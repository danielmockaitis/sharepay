class AddMoreToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :title, :string
    add_column :transactions, :description, :text
  end
end
