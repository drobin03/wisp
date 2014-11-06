

$( document ).ready(function() {
    
});

// defaults to guelph
$.ajax({
    url: "rankings/city/list",
    }).done(function( data ) {
        console.log( "done: " + data );
    }).fail(function(jqXHR, msg) {
        alert( "error " + msg);
  });
  

// defaults to guelph
$.ajax({
    url: "rankings/country/list",
    }).done(function( data ) {
        console.log( "done: " + data );
    }).fail(function(jqXHR, msg) {
        alert( "error " + msg);
  });