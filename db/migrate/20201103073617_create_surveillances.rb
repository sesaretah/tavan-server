class CreateSurveillances < ActiveRecord::Migration[5.2]
  def change
    create_table :surveillances do |t|
      t.integer :user_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
