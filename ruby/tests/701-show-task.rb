normal   = normal_handle

raise "SKIPPED: no Users" unless @task_list_700.present?

task_id   = @task_list_700.first[:id]
task_info = normal.show_task(task_id)

puts "TASK_INFO: #{task_info.inspect}" if @debug

raise "Value returned is not an hash" unless task_info.present? && task_info.is_a?(Hash)
raise "You have no information for your user" if task_info.empty?

true
