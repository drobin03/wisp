

$( document ).ready(function() {
    
});

$.ajax({
    url: "rankings/city/list",
    }).done(function( data ) {
        console.log( "done: " + data );
    }).fail(function(jqXHR, msg) {
        alert( "error " + msg);
  });