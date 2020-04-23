class AddInvolveableTypeToInvolvement < ActiveRecord::Migration[5.2]
  def change
    add_column :involvements, :involveable_type, :string
  end
end
