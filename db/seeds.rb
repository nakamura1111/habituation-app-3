# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

n_users = 1
n_targets = 10
n_habits = 100
n_small_targets = 100

n_users.times do |i|
  user = User.new(
    nickname: "human#{i+1}", email: "human#{i+1}@sample.com", password: "password#{i+1}"
  )
  user.valid?
  puts "#{i+1}: #{user.errors.full_messages}" unless user.save
end
puts "ユーザ情報入力完了"

n_targets.times do |i|
  target = Target.new(
    name: "sample#{i+1}力", content: "sample#{i+1}力_説明だよ", point: 0,
    level: 1, exp: 0, user: User.all.sample
  )
  target.valid?
  puts "#{i+1}: #{target.errors.full_messages}" unless target.save
end
puts "目標入力完了"

n_habits.times do |i|
  habit = Habit.new(
    name: "sample#{i+1} をやるぞ", content: "sample#{i+1}の説明だよ", difficulty_grade: Difficulty.all.sample.id,
    achieved_or_not_binary: 0b0, achieved_days: 0, is_active: true,
    target: Target.all.sample 
  )
  habit.valid?
  puts "#{i+1}: #{habit.errors.full_messages}" unless habit.save
end
puts "習慣入力完了"

n_small_targets.times do |i|
  is_achieved = [true, false].sample
  if is_achieved
    happiness = Happiness.where.not(id: 0).sample.id
    hardness = Hardness.where.not(id: 0).sample.id
  else
    happiness = 0
    hardness = 0
  end
  small_target = SmallTarget.new(
    name: "sample#{i+1} ができるようになった", content: "sample#{i+1}の説明だよ", is_achieved: is_achieved,
    happiness_grade: happiness, hardness_grade: hardness, target: Target.all.sample 
  )
  small_target.valid?
  puts "#{i+1}: #{small_target.errors.full_messages}" unless small_target.save
end
puts "習慣入力完了"