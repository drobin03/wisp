

$( document ).ready(function() {
    $("#city_id").change(function () {
        var city = $("#city_id option:selected").text();
        alert("city value changed " + city); 
        
        getLocationFromCity(city, function(latitude, longitude) {
            changeMapPosition(latitude, longitude);
        });
    });

    getCityFromBrowserGeoLocation(function(city) {
        getLatitudeLongitude( function(latitude, longitude) {
            changeMapPosition(latitude, longitude);
            addMapMarker(latitude, longitude, 12);
        });
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
  
function addMapMarker(latitude, longitude, rank) {
    var loc = {lat: latitude, lng: longitude};
    var marker = new google.maps.Marker({
        position: loc,
        map: map
    });
    
    var contentString = '<h4>Ranked: ' + rank + '</h4>';
    var infowindow = new google.maps.InfoWindow({
          content: contentString
    });
    google.maps.event.addListener(marker, 'click', function() {
        infowindow.open(map,marker);
    });
}
  
function changeMapPosition(latitude, longitude) {
    var loc = {lat: latitude, lng: longitude};
    map.panTo(loc);
}
  
function getLatitudeLongitude(locationCallback) {
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
        locationCallback(latitude, longitude);
      };
      var geoError = function(error) {
          console.log('Error occurred. Error code: ' + error.code);
          return "";
      };

      navigator.geolocation.getCurrentPosition(geoSuccess, geoError, geoOptions);
    }
}

function getLocationFromCity(cityName, callback) {
    var geocoder =  new google.maps.Geocoder();
    geocoder.geocode( { 'address': cityName + ', canada'}, function(results, status) {
          if (status == google.maps.GeocoderStatus.OK) {
            var latitude = results[0].geometry.location.lat();
            var longitude = results[0].geometry.location.lng();
            callback(latitude, longitude);
          } else {
            return "";
          }
        });
}
  
// calls cityCallback() with the city as the parameter if it was found, otherwise an empty string is passed
function getCityFromBrowserGeoLocation(cityCallback) {

    getLatitudeLongitude( function(latitude, longitude) {
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
    });
}