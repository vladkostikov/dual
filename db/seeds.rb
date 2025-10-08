admin = Admin.find_or_create_by(email: 'admin@email.gen') do |admin|
  admin.first_name = 'Admin FN'
  admin.last_name = 'Admin LN'
end
admin.password = 'admin'
admin.save

(1..50).each do |i|
  u = Manager.find_or_create_by(
    email: "manager#{i}@email.gen",
    first_name: "FN #{i}",
    last_name: "LN #{i}"
  )
  u.password = "#{i}"
  u.save
end

(1..50).each do |i|
  u = Developer.find_or_create_by(
    email: "developer#{i}@email.gen",
    first_name: "FN #{i}",
    last_name: "LN #{i}",
  )
  u.password = "#{i}"
  u.save
end

managers = Manager.first(50)
developers = Developer.first(50)
states = ['new_task', 'in_development', 'in_qa', 'in_code_review', 'ready_for_release', 'released', 'archived']
(1..50).each do |i|
  managers.sample.my_tasks.find_or_create_by(name: "Task name #{i}") do |task|
    task.description = "Task description #{i}"
    task.state = states.sample
    task.assignee = developers.sample
  end
end
