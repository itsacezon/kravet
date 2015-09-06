$(document).ready(function() {
  $('#list').css({
    height: $(window).height() - $('#map').outerHeight(true)
  });

  $('.marine__product').click(function(e) {
    $('.marine__product').removeClass('selected');
    $(this).addClass('selected');
  });

  $('.js-marine__product-deselect').click(function(e) {
    e.preventDefault();
    e.stopPropagation();
    $('.marine__product.selected').removeClass('selected');
    console.log('fire');
  });
});
