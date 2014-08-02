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
  @published bool auto = false;

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
  @published String output = 'json';

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

  @observable Map params = toObservable({});

  CoreAjax coreAjax;


  RBTimeZone.created(): super.created() {
    this.coreAjax =
      document.createElement('core-ajax-dart')
        ..addEventListener('core-response', _onResponse)
        ..addEventListener('core-error', _onError)
        ..addEventListener('core-complete', _onComplete);
  }

  void attached(){
    super.attached();
    autoChanged();
    outputChanged();
    _initParams();
  }

  autoChanged() => this.coreAjax.auto = auto;

  outputChanged() {
    coreAjax.handleAs = output;
    coreAjax.url = '$_BASE_URL/$output';
  }

  // TODO: remove paramsChanged calls when issue 15407 gets fixed.
  latitudeChanged() { params['location'] = _location; paramsChanged(); }
  longitudeChanged() { params['location'] = _location; paramsChanged(); }
  timestampChanged() { params['timestamp'] = timestamp.toString(); paramsChanged(); }
  languageChanged() { params['language'] = language; paramsChanged(); }
  apiKeyChanged() { params['key'] = apiKey; paramsChanged(); }
  clientIdChanged() { params['client'] = _client; paramsChanged(); }
  signatureChanged() { params['signature'] = signature; paramsChanged(); }

  paramsChanged() => coreAjax.params = JSON.encode(_validParams);

  String get _client => clientId != null && clientId != ''
                        ? 'gme-$clientId' : null;

  String get _location => latitude != null && longitude != null
                          ? '$latitude,$longitude' : null;

  void _initParams() {
    params
      ..['location'] = _location
      ..['timestamp'] = timestamp.toString()
      ..['language'] = language
      ..['key'] = apiKey
      ..['client'] = _client
      ..['signature'] = signature;
    paramsChanged();
  }

  Map get _validParams {
    var map = new Map();
    for (var key in params.keys) {
      if (params[key] != null) {
        map[key] = params[key];
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
  go() => coreAjax.go();

  /**
   * Fired whenever a response or an error is received.
   *
   * @event rb-time-zone-response
   */
  _onResponse(CustomEvent event) => this.fire('rb-time-zone-response', detail: event.detail);

  /**
   * Fired whenever a response or an error is received.
   *
   * @event rb-time-zone-error
   */
  _onError(CustomEvent event) => this.fire('rb-time-zone-error', detail: event.detail);

  /**
   * Fired whenever a response or an error is received.
   *
   * @event rb-time-zone-complete
   */
  _onComplete(CustomEvent event) => this.fire('rb-time-zone-complete', detail: event.detail);
}