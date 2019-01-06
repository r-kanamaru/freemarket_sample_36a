$(function() {
  // common：modal
  $('.js-modal').magnificPopup({
    type: 'inline',
    showCloseBtn: false
  });
  $('.c-modal').on('click', '.js-modal_btn-cancel', function (e) {
    e.preventDefault();
    $.magnificPopup.close();
  });
  // common：accordion
  $('.c-accordion_toggle').on('click', function() {
    $(this).next('.c-accordion_child').slideToggle();
    $(this).children('.c-accordion_icon').toggleClass('is-active');
  });
  // common：navi active
  $('.js-active a').each(function(){
    var url = window.location.pathname;
    var navilink = $(this).attr('href');
    if(url.match(navilink)) {
        $(this).addClass('is-active');
    } else {
        $(this).removeClass('is-active');
    }
  });
});