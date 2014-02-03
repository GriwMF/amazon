# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.selectpicker').selectpicker();
  $('#check-out-ship-switch').click (event) ->
    $('#check-out-ship').toggleClass('hidden');
    $('#check-out-ship-hidden').toggleClass('hidden');
    $('#order_ship_addr_id').selectpicker('val', '');
    event.preventDefault(); # Prevent link from following its href
  $('#check-out-bill-switch').click (event) ->
    $('#check-out-bill').toggleClass('hidden');
    $('#check-out-bill-hidden').toggleClass('hidden');
    $('#order_bill_addr_id').selectpicker('val', '');
    event.preventDefault(); # Prevent link from following its href  
  $('#bill-checkbox').click (cb) ->
    $('#bill-show').toggleClass('hidden');
  $('#check-out-card-switch').click (event) ->
    $('#check-out-card').toggleClass('hidden');
    $('#check-out-card-hidden').toggleClass('hidden');
    $('#order_credit_card_id').selectpicker('val', '');
    event.preventDefault(); # Prevent link from following its href    
  # link = $('#hidden-panel-link');
  # link.click (event) ->
    # $('#hidden-panel').removeClass('hidden');
    # link.addClass('hidden');
    # event.preventDefault(); # Prevent link from following its href
