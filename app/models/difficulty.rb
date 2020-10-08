# 習慣の難易度を選択するためのDBのないモデル
class Difficulty < ActiveHash::Base
  self.data = [
    { id: 0, name: '楽勝' },
    { id: 1, name: 'まあ楽勝' },
    { id: 2, name: 'まあまあ' },
    { id: 3, name: 'しんどい' },
    { id: 4, name: 'ちょーしんどい' }
  ]
end
