/**
 * Copyright (c) 2014, RBWebComponents Authors. All rights reserved.
 *
 * This is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or (at
 * your option) any later version.
 *
 * This software is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this program. If not, see
 * <http://www.gnu.org/licenses/>.
 */
library rb_time_zone;

import 'dart:html';
import 'dart:async';
import 'dart:convert' show JSON;
import 'package:polymer/polymer.dart';
import 'package:core_elements/core_ajax_dart.dart';

@CustomTag('rb-time-zone')
class RBTimeZone extends PolymerElement {

  static const String _BASE_URL = 'https://maps.googleapis.com/maps/api/timezone';

  /**
   * A latitude of a location.
   *
   * @attribute latitude
   * @type number
   * @default null
   */
  @published num latitude;

  /**
   * A longitude of a location.
   *
   * @attribute longitude
   * @type number
   * @default null
   */
  @published num longitude;

  /**
   * The desired time as seconds since midnight, January 1, 1970 UTC.
   *
   * The Time Zone API uses the timestamp to determine whether or not Daylight
   * Savings should be applied. Times before 1970 can be expressed as negative
   * values.
   *
   * @attribute longitude
   * @type number
   * @default null
   */
  @published num timestamp;

  /**
   * If true, automatically performs the request on another attribute change.
   *
   * @attribute auto
   * @type boolean
   * @default false
   */
  @published bool auto;

  /**
   * The output format can be one of the following:
   * <ul>
   *   <li><b>json</b>: This is the default format, returns results in
   *   JavaScript Object Notation (JSON).</li>
   *   <li><b>xml</b>: returns results in XML, wrapped within a <i>&#60;TimeZoneResponse&#62;</i> node.</li>
   * </ul>
   *
   * @attribute output
   * @type string
   * @default json
   */
  @published String output;

  /**
   * The language in which to return results.
   *
   * @attribute language
   * @type string
   * @default null
   */
  @published String language;

  /**
   * Your application's <a href="https://developers.google.com/console/help/#UsingKeys">API key</a>.
   * This key identifies your application for purposes of quota management. Learn how to
   * <a href="https://developers.google.com/maps/documentation/timezone/#api_key">get a key</a>
   * from the <a href="https://code.google.com/apis/console/?noredirect">APIs Console</a>.
   *
   * <b>Note:</b> Maps for Business users must include <b>clientId</b> and
   * <b>signature</b> parameters with their requests instead of <b>apiKey</b>.
   *
   * @attribute apiKey
   * @type string
   * @default null
   */
  @published String apiKey;

  /**
   * The clientId of Maps API for Business users.
   *
   * @attribute clientId
   * @type string
   * @default null
   */
  @published String clientId;

  /**
   * The signature of Maps API for Business users.
   *
   * @attribute signature
   * @type string
   * @default null
   */
  @published String signature;

  ObservableMap<String, Object> _params;
  CoreAjax _coreAjax;


  RBTimeZone.created(): super.created() {
    _coreAjax = (document.createElement('core-ajax-dart') as CoreAjax)
      ..addEventListener('core-response', _onResponse)
      ..addEventListener('core-error', _onError)
      ..addEventListener('core-complete', _onComplete);

    _params = toObservable(<String, Object>{})
      ..changes.listen((_) => _coreAjax.params = JSON.encode(_validParams));

    auto = auto == null ? false : auto;
    output = output == null ? 'json' : output;
  }

  autoChanged() => _coreAjax.auto = auto;

  outputChanged() {
    _coreAjax.handleAs = output;
    _coreAjax.url = '$_BASE_URL/$output';
  }


  latitudeChanged() { _params['location'] = _location; }
  longitudeChanged() { _params['location'] = _location; }
  timestampChanged() { _params['timestamp'] = timestamp; }
  languageChanged() { _params['language'] = language; }
  apiKeyChanged() { _params['key'] = apiKey; }
  clientIdChanged() { _params['client'] = _client; }
  signatureChanged() { _params['signature'] = signature; }

  String get _client => clientId != null && clientId != ''
                        ? 'gme-$clientId' : null;

  String get _location => latitude != null && longitude != null
                          ? '$latitude,$longitude' : null;

  Map get _validParams {
    var map = new Map();
    for (var key in _params.keys) {
      if (_params[key] != null) {
        map[key] = _params[key].toString();
      }
    }
    return map;
  }

  /**
   * Performs the timezone api request.
   *
   * If <b>auto</b> attribute is false this method must be called to perform
   * the request
   *
   * @method go
   */
  go() => Timer.run(() => _coreAjax.go());

  /**
   * Fired whenever a response or an error is received.
   *
   * @event time-zone-api-response
   */
  _onResponse(CustomEvent event) => this.fire('time-zone-api-response', detail: event.detail);

  /**
   * Fired whenever a response or an error is received.
   *
   * @event time-zone-api-error
   */
  _onError(CustomEvent event) => this.fire('time-zone-api-error', detail: event.detail);

  /**
   * Fired whenever a response or an error is received.
   *
   * @event time-zone-api-complete
   */
  _onComplete(CustomEvent event) => this.fire('time-zone-api-complete', detail: event.detail);
}