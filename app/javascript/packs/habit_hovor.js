if ( document.URL.match('/targets') ) {
  'use strict';
  // ロード完了したら
  $(document).ready(function(){             // addEventListenerのloadイベントかな？
    // クリックしたら
    $('.habit-lists .title').first().on('click', function(){
      // タイトルの変更
      if ($(this).text() === "鍛錬メニュー（非表示中）") {
        $(this).text("鍛錬メニュー（表示中）");
      } else if ($(this).text() === "鍛錬メニュー（表示中）") {
        $(this).text("鍛錬メニュー（非表示中）");
      } else {
        console.log("error : can't change title");
      }
      console.log($(this).next())
      $(this).next().toggleClass('hidden');
    });
  });
}