var start_number = 0

$('#ronaldo').on('plotly_click', function(){
  setTimeout( function(){
    $('.counter').each(function () {
      // Start the counting from a specified number - in this case, 0!
      $(this).prop('Counter',start_number).animate({
        Counter: $(this).text()
      }, {
        // Speed of counter in ms, default animation style
        duration: 1000,
        easing: 'swing',
        step: function (now) {
          // Round up the number
          $(this).text(Math.ceil(now));
        }
      });
      var start_number = $("#ilosc_gier").text()
    }),
    setTimeout( function(){
      $( ".fade-text" ).fadeIn( "slow", function() {
        // Animation complete
      }); // delay 500 ms
    }, 1000); // delay 500 ms
  }, 300);
});
