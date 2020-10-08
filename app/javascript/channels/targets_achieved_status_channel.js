import consumer from "./consumer"

consumer.subscriptions.create("TargetsAchievedStatusChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    // レベルを反映する(レベルが変化していたら、レベルの修飾を変える)
    const targetLevel = document.getElementById("target-level");
    if (targetLevel == null) { // 遷移先のビューファイルによっては表示されていないことがあるため、設定
      return
    }
    if ( targetLevel.innerHTML.indexOf(`Lv. ${data.content.level}`) == -1 ) {
      targetLevel.innerHTML = `Lv. ${data.content.level} - Level up!`;
      targetLevel.style.color = 'red';
      targetLevel.style.fontSize = '40px';
    }
    // 経験値を反映する
    const expBar = document.getElementById("exp-bar");
    expBar.setAttribute('value', data.content.exp);
  }
});
