$ ->
  $('#rating-switch').click (event) ->
    $('#rating-panel').removeClass('hidden');
    $('#rating-switch').addClass('hidden');
    event.preventDefault(); # Prevent link from following its href
  $(':radio').change ->
    $('#rating').val( this.value );
