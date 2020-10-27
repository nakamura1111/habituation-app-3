crumb :root do |user|
  link "ユーザ：#{user.nickname}", root_path
end

crumb :target_show do |target|
  link "目標：#{target.name}", target_path(target)
  parent :root, target.user
end

crumb :target_new do |user|
  link "目標登録", new_target_path
  parent :root, user
end

crumb :habit_show do |habit|
  link "習慣：#{habit.name}", target_habit_path(habit.target, habit)
  parent :target_show, habit.target
end

crumb :habit_new do |target|
  link "習慣登録", new_target_habit_path(target)
  parent :target_show, target
end

crumb :small_target_show do |small_target|
  link "小目標：#{small_target.name}", target_small_target_path(small_target.target, small_target)
  parent :target_show, small_target.target
end

crumb :small_target_new do |target|
  link "小目標登録", new_target_small_target_path(target)
  parent :target_show, target
end

crumb :small_target_edit do |small_target|
  link "小目標編集：#{small_target.name}", edit_target_small_target_path(small_target.target, small_target)
  parent :small_target_show, small_target
end


# crumb "現在のページ名（表示させるビューにもページ名記述）" do
#   link "パンくずリストでの表示名", "アクセスしたいページのパス"
#   parent :親要素のページ名（前のページ）
# end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).