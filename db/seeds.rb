admin = Admin.find_or_create_by(first_name: 'admin', last_name: 'admin', email: 'admin@email.gen')
admin.password = 'admin'
admin.save

50.times do |i|
  u = Manager.find_or_create_by(
    email: "manager#{i}@mail.gen",
    first_name: "FN#{i}",
    last_name: "LN#{i}"
  )
  u.password = "#{i}"
  u.save
end

50.times do |i|
  u = Developer.find_or_create_by(
    email: "developer#{i}@mail.gen",
    first_name: "FN#{i}",
    last_name: "LN#{i}",
  )
  u.password = "#{i}"
  u.save
end

managers = Manager.first(50)
developers = Developer.first(50)
states = ['new_task', 'in_development', 'in_qa', 'in_code_review', 'ready_for_release', 'released', 'archived']
50.times do |i|
  managers.sample.my_tasks.find_or_create_by(
    name: "Task name #{i}",
    description: "Task description#{i}",
    state: states.sample,
    assignee: developers.sample
  )
end
