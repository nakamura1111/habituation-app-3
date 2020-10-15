if ( document.URL.match('/small_targets') ) {
  function smallTargetAchievedPullDown() {
    const pullDown = document.getElementById("small-target-achieved-pull-down")
    const radioTrue = document.getElementById("small_target_is_achieved_true")
    const radioFalse = document.getElementById("small_target_is_achieved_false")
    // hidden要素を表示する
    radioTrue.addEventListener('input', function() {
      pullDown.setAttribute("style", "display:block;")
    })
    // hidden要素を再び隠す
    radioFalse.addEventListener('input', function() {
      pullDown.removeAttribute("style", "display:block;")
    })
  }
  window.addEventListener('load', smallTargetAchievedPullDown)
}