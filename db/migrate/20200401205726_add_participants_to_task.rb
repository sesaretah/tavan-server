class AddParticipantsToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :participants, :json
  end
end
