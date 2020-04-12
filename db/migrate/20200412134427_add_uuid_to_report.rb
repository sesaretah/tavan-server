class AddUuidToReport < ActiveRecord::Migration[5.2]
  def change
    add_column :reports, :uuid, :string
    add_index :reports, :uuid
  end
end
