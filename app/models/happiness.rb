class Happiness < ActiveHash::Base
  self.data = [
    { id: 0, name: '未達成' },
    { id: 1, name: '通過点ですから' },
    { id: 2, name: '嬉しい！' },
    { id: 3, name: 'めっちゃ嬉しい' }
  ]
end
