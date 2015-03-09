normal         = normal_handle
@task_list_700 = normal.index_tasks()

puts "LIST (first tasks)= \n#{show_top_entries(@task_list_700,5)}" if @debug

raise "Value returned is not an array" unless @task_list_700.present? && @task_list_700.is_a?(Array)

true
