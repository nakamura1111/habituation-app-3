# 習慣の達成状況に対する目標のレベルなどの変化を非同期で反映させるためのチャネルを作成する
class TargetsAchievedStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'targets_achieved_status_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
