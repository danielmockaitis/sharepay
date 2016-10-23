class AddReferenceToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :transaction, foreign_key: true
  end
end
