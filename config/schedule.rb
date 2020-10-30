# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever    「大まかな型がわかる」
# command, runner, rakeの違いがわかる：https://www.school.ctc-g.co.jp/columns/masuidrive/masuidrive22.html
# 初学者向け：https://qiita.com/shimadama/items/e281331e34a43c0b05d4    「rakeタスクの確認の仕方がわかる」
# 初学者向け：https://opiyotan.hatenablog.com/entry/rails-whenever    「」


# ログファイルの生成
set :output, "/log/schedule/cron.log"

every 1.day, at: '12:00 pm' do
  # 日付変更に従い、DBの習慣達成状況を変更する
  runner "Habit.update_stat_by_day_progress"
end 