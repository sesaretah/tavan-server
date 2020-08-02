ThinkingSphinx::Index.define :report, :with => :real_time do
    indexes title, :sortable => true
    indexes content

    has task_id, :type => :integer
    has work_id, :type => :integer
end