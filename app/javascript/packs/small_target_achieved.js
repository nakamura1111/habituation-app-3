if ( document.URL.match('/small_targets') ) {
  function smallTargetAchievedPullDown() {
    const radioTrue = document.getElementById("radio-true")
    const radioFalse = document.getElementById("radio-false")
    const pullDown = document.getElementById("small-target-achieved-pull-down")
    radioTrue.addEventListener('input', function() {
      pullDown.setAttribute("style", "display:block;")
    })
    radioFalse.addEventListener('input', function() {
      pullDown.removeAttribute("style", "display:block;")
    })
  }
  window.addEventListener('load', smallTargetAchievedPullDown)
}