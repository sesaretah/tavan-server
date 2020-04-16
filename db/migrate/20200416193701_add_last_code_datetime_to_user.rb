class AddLastCodeDatetimeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_code_datetime, :datetime
  end
end
