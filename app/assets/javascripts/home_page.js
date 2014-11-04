

$( document ).ready(function() {
    
});

$.ajax({
    url: "rankings/city/list",
    dataType: "html",
    }).done(function( data ) {
        console.log( "done: " + data );
    }).fail(function(jqXHR, msg) {
        alert( "error " + msg);
  });