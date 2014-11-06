

$( document ).ready(function() {
    getCityLocation(function(city) {
        alert(city);
    });
});

// defaults to guelph
$.ajax({
    url: "rankings/city/list",
    }).done(function( data ) {
        console.log( "done: " + data );
    }).fail(function(jqXHR, msg) {
        alert( "error " + msg);
  });
  

// defaults to Canada
$.ajax({
    url: "rankings/country/list",
    }).done(function( data ) {
        console.log( "done: " + data );
    }).fail(function(jqXHR, msg) {
        alert( "error " + msg);
  });
  
// calls cityCallback() with the city as the parameter if it was found, otherwise an empty string is passed
function getCityLocation(cityCallback) {
  if (navigator.geolocation) {
      var startPos;
      var geoOptions = {
         timeout: 10 * 1000
      }

      var geoSuccess = function(position) {
        startPos = position;
        var latitude = startPos.coords.latitude;
        var longitude = startPos.coords.longitude;
        console.log(latitude);
        console.log(longitude);
        
        var url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='+latitude+','+longitude+'&sensor=false&key=AIzaSyBxKrzd5Mmk4Bbjbbg0xnfESgso--qJ6kk'

        $.ajax({
            dataType: "json",
            url: url,
        })
        .done(function(json) {
                if (json && json.results.length > 0)
                {
                    for (var k=0; k < json.results.length; k++ ) {                    
                        if (json.results[k].address_components) {
                            for (var i = 0; i < json.results[k].address_components.length; i++) {
                                if (json.results[k].address_components[i]) {
                                    for (var j = 0; j < json.results[k].address_components[i].types.length; j++) {
                                        if(json.results[k].address_components[i].types[j] == 'locality') {
                                            var city_name = json.results[k].address_components[i].long_name;
                                            cityCallback(city_name);
                                            return;
                                        }
                                    }
                                }
                            }
                        }
                    }
                 }
                 cityCallback("");
        })
        .fail(function( jqxhr, textStatus, error ) {
            var err = textStatus + ", " + error;
            console.log("Request Failed: " + err );
            cityCallback("");
        });  
        
        
      };
      var geoError = function(error) {
        console.log('Error occurred. Error code: ' + error.code);
        cityCallback("");
      };

      navigator.geolocation.getCurrentPosition(geoSuccess, geoError, geoOptions);
  }
}