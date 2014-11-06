  var map;
  function initialize() {
    var mapOptions = {
      center: { lat: 40.5307958, lng: -80.2288651},
      zoom: 10
    };
    map = new google.maps.Map(document.getElementById('map-canvas'),
        mapOptions);
  }
  google.maps.event.addDomListener(window, 'load', initialize);