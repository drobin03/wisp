
// used for updating city longitudes/latitudes var timeout = 3000;

$( document ).ready(function() {
    
    // place city ranks on the map
    $.ajax({
        url: "rankings/cities",
        }).done(function( data ) {
            var arrayLength = data.length;
            for (var i = 0; i < arrayLength; i++) {
                var city = data[i];
                if (city.latitude != null && city.longitude != null){
                    addMapMarker(data[i].latitude, data[i].longitude, data[i].name, data[i].rank, (parseFloat(data[i].avg_download) / 1024).toFixed(2) );
                } else {
                    console.log("No latitude/longitude for " + city.name);
                }
            }
        }).fail(function(jqXHR, msg) {
            alert( "error " + msg);
    });
    

    $("#city_id").change(function () {
        var city = $("#city_id option:selected").text();
        var cityID = $("#city_id option:selected").attr("value");
        //alert("city value changed " + city); 
        getTopCityISPs(city, cityID);
        
        getLocationFromCity(city, function(latitude, longitude) {
            changeMapPosition(latitude, longitude);
        });
    });

    // prompt to automatically get the location from the user
    getCityFromBrowserGeoLocation( function(cityName) {
        // change the dropdown to use the automatically obtained city
        $('#city_id option').filter(function() { 
            return ($(this).text() == cityName);
        }).prop('selected', true);
        var cityID = $("#city_id option:selected").attr("value");
        
        getTopCityISPs(cityName, cityID);
        $('#province_id').change();
    });
});

function createChart(data) {
    var options = {
        scaleShowGridLines : true,
        scaleLabel : "<%= value %>",
        
        legendTemplate : '<ul>'
                  +'<% for (var i=0; i<datasets.length; i++) { %>'
                    +'<li style="display:inline; padding:5px;">'
                    +'<span style=\"color:<%=datasets[i].pointColor%>;\">'
                    +'<% if (datasets[i].label) { %><%= datasets[i].label %><% } %></span>'
                  +'</li>'
                +'<% } %>'
              +'</ul>'
    };
    
    // dictionary of each isp company
    var ispDatas = {};

    // group the data into their isp company
    for(var i=0; i < data.length; i++) {
        // check to see if we create the object for the ISP company yet, if not create it
        if(ispDatas[data[i].isp_company_id]){
            // already exists, add the data point to the ISP company array
            // convert avg_download to mbps
            var avgDownMpbs = (parseFloat(data[i].avg_download) / 1024).toFixed(2)
            var monthIndex = new Date(data[i].date).getMonth();
            ispDatas[data[i].isp_company_id].data[monthIndex] = avgDownMpbs;
        }
        else {
            // initialize a new data set for the ISP company
            var color = hex2rgba(Colors.random());
            ispDatas[data[i].isp_company_id] = {
                label: data[i].name,
                fillColor: arr2rgba(color, 0.2),
                strokeColor: arr2rgba(color),
                pointColor: arr2rgba(color),
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: arr2rgba(color),
                data: [0,0,0,0,0,0,0,0,0,0,0,0]
            };
        }
    }
    // convert dictionary into array for Chart.js
    var datasets = $.map(ispDatas, function(value, index) {
        return [value];
    });
    
    var data = {
        labels: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
        datasets: datasets
    };
    // create the chart
    var ctx = $("#myChart").get(0).getContext("2d");
    var lineChart = new Chart(ctx).Line(data, options);
    
    // create the legend
    var legend = lineChart.generateLegend();
    $('#chart-container').html(legend);
}

function getTopCityISPs(cityName, cityID) {
    // get ISP data: defaults to guelph
    $.ajax({
        url: "rankings/city/list",
        data: { city : cityName},
        }).done(function( data ) {
            console.log( "city/list data: " + data );
        }).fail(function(jqXHR, msg) {
            alert( "error " + msg);
      });
    
    if(cityID !== undefined) {
        // get data for the chart
        $.ajax({
            url: "city/" + cityID + "/isps",
            }).done(function( data ) {
                createChart(data);
            }).fail(function(jqXHR, msg) {
                alert( "error " + msg);
        });
    }
}

getTopCityISPs();

// defaults to Canada
$.ajax({
    url: "rankings/country/list",
    }).done(function( data ) {
        console.log( "country/list data: " + data );
    }).fail(function(jqXHR, msg) {
        alert( "error " + msg);
  });

// Code to populate city longitude/latitudes updateLatLong($.map($('#city_id').find("option") ,function(option) { return $(option).html(); }));
  
function addMapMarker(latitude, longitude, city, rank, speed) {
    var loc = {lat: latitude, lng: longitude};
    var marker = new google.maps.Marker({
        position: loc,
        map: map
    });
    
    var contentString = '<div class="text-center" style="color:#000000; font-weight:bold;">' + city + '</div>' + 
                        '<div class="text-center" style="color:#000000">' + ordinal_suffix_of(rank) + ' in Canada</div>' + 
                        '<div class="text-center" style="color:#000000">Avg Download Speed ' + speed + ' mbps</div>';
    var infowindow = new google.maps.InfoWindow({
          title: "Ranks 111",
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
  
function updateLatLong(cities) {
    for (i in cities) {
        getLocationFromCityWithTimeout(cities[i]);
    }
}
function getLocationFromCityWithTimeout(city) {
  setTimeout(
    function() { 
        getLocationFromCity(city, 
            function(latitude, longitude) { 
                console.log(city + " " + longitude + " " + latitude);
                updateCity(city, latitude, longitude);
            }); 
    }, timeout += 3000);
}
function updateCity(city, latitude, longitude) {
  $.ajax({
    type: "post",
    url: "city/update",
    data: { city_name: city, latitude: latitude, longitude: longitude }
    }).done(function( data ) {
        console.log( "done: " + data );
    }).fail(function(jqXHR, msg) {
        alert( "error " + msg);
  });
}
function getLatitudeLongitudeFromBrowser(locationCallback) {
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

    getLatitudeLongitudeFromBrowser( function(latitude, longitude) {
        changeMapPosition(latitude, longitude);
    
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

/* Taken from http://stackoverflow.com/questions/13627308/add-st-nd-rd-and-th-ordinal-suffix-to-a-number */
function ordinal_suffix_of(i) {
    var j = i % 10,
        k = i % 100;
    if (j == 1 && k != 11) {
        return i + "st";
    }
    if (j == 2 && k != 12) {
        return i + "nd";
    }
    if (j == 3 && k != 13) {
        return i + "rd";
    }
    return i + "th";
}