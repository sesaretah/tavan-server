class AddLastCodeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_code, :string
  end
end
