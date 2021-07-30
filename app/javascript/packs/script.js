/* Signin Popup */
$('.signin-popup').on('click', function(){
  $('.signin-popup-box').fadeIn('fast');
  $('html').addClass('no-scroll');
});
$('.close-popup').on('click', function(){
  $('.signin-popup-box').fadeOut('fast');
  $('html').removeClass('no-scroll');
});

/* Signup Popup */
$('.signup-popup').on('click', function(){
  $('.signup-popup-box').fadeIn('fast');
  $('html').addClass('no-scroll');
});
$('.close-popup').on('click', function(){
  $('.signup-popup-box').fadeOut('fast');
  $('html').removeClass('no-scroll');
});

$('.scroll-to a, .scrollup, .back-top, .tree_widget-sec > ul > li > ul > li a, .cand-extralink a').on('click', function(e) {
  e.preventDefault();
  $('html, body').animate({ scrollTop: $($(this).attr('href')).offset().top}, 500, 'linear');
});
