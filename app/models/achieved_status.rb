# 達成状況の選択のためのプルダウン作成用のDBのないモデル
class AchievedStatus < ActiveHash::Base
  self.data = [
    { id: 0, name: '×' },
    { id: 1, name: '〇' }
  ]
end
