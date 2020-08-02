ThinkingSphinx::Index.define :work, :with => :real_time do
    indexes title, :sortable => true

    has task_id, :type => :integer
  end