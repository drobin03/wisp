

$( document ).ready(function() {
    
});

// defaults to guelph
$.ajax({
    url: "rankings/city/list",
    dataType: "json",
    }).done(function( data ) {
        console.log( "done: " + data.message );
        console.dir( data.isps );
    }).fail(function(jqXHR, msg) {
        alert( "error " + msg);
  });
  
  // push city
  $.ajax({
    url: "rankings/city/list",
    data: { city: "toronto" },
    dataType: "json",
    }).done(function( data ) {
        console.log( "done: " + data.message );
        console.dir( data.isps );
    }).fail(function(jqXHR, msg) {
        alert( "error " + msg);
  });