rb-time-zone
============

A time zone web component that acts as a service facade for the [Google Time Zone API][1].

Using the element
-----------------
Import into HTML:

    <link rel="import" href="packages/rb_time_zone/rb_time_zone.html">

Import into Dart:

    import 'package:rb_time_zone/rb_time_zone.dart';
    
Example
-------
Translating the request example provided by the Google Time Zone API:

WebService call

    https://maps.googleapis.com/maps/api/timezone/json?location=39.6034810,-119.6822510&timestamp=1331161200&key={API_KEY}

Web Component

    <rb-time-zone
      latitude="39.6034810"
      longitude="-119.6822510"
      timestamp="1331161200"
      apiKey="{API_KEY}">
    </rb-time-zone>

**Note:** Parameters inside curly braces are optional

  [1]: https://developers.google.com/maps/documentation/timezone/