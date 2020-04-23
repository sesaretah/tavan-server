class CreateInvolvements < ActiveRecord::Migration[5.2]
  def change
    create_table :involvements do |t|
      t.integer :user_id
      t.integer :involveable_id
      t.string :involoveable_type
      t.string :status
      t.string :role

      t.timestamps
    end
  end
end
