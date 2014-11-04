

$( document ).ready(function() {
    
});

$.ajax({
    url: "rankings/city/list",
    dataType: "json",
    }).done(function( data ) {
        console.log( "done: " + data.message );
        console.log( "isps: " + data.isps );
    }).fail(function(jqXHR, msg) {
        alert( "error " + msg);
  });