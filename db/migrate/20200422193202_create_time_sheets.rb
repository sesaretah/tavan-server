class CreateTimeSheets < ActiveRecord::Migration[5.2]
  def change
    create_table :time_sheets do |t|
      t.integer :user_id
      t.text :morning_report
      t.text :afternoon_report
      t.text :extra_report
      t.json :associations
      t.json :recipients
      t.date :sheet_date

      t.timestamps
    end
  end
end
