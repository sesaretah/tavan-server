class AddArchiveNoteToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :archive_note, :text
  end
end
