class AddReferenceToTransaction < ActiveRecord::Migration[5.0]
  def change
    add_reference :transactions, :user, foreign_key: true
  end
end
