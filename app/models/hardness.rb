class Hardness < ActiveHash::Base
  self.data = [
    { id: 0, name: '未達成' },
    { id: 1, name: 'そんなに大変じゃなかった' },
    { id: 2, name: '結構しんどかった' },
    { id: 3, name: '心折れかけた...' }
  ]
end
