// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// DONE: Import relevant packages

import 'dart:convert';
import 'dart:io';

import 'unit.dart';

/// The REST API retrieves unit conversions for [Categories] that change.
///
/// For example, the currency exchange rate, stock prices, the height of the
/// tides change often.
/// We have set up an API that retrieves a list of currencies and their current
/// exchange rate (mock data).
///   GET /currency: get a list of currencies
///   GET /currency/convert: get conversion from one currency amount to another
class Api {
  // DONE: Add any relevant variables and helper functions
  final httpClient = HttpClient();
  final url = 'flutter.udacity.com';

  // DONE: Create getUnits()
  /// Gets all the units and conversion rates for a given category.
  ///
  /// The `category` parameter is the name of the [Category] from which to
  /// retrieve units. We pass this into the query parameter in the API call.
  ///
  /// Returns a list. Returns null on error.
  Future<List<Unit>> getUnits(String category) async {
    final uri = Uri.https(url, '/$category');
    final httpReq = await httpClient.getUrl(uri);
    final httpRes = await httpReq.close();
    if (httpRes.statusCode != HttpStatus.ok) {
      return null;
    }
    final resBody = await httpRes.transform(utf8.decoder).join();
    final jsonRes = json.decode(resBody);
    final List<Unit> units = jsonRes['units']
        .map<Unit>((dynamic data) => Unit.fromJson(data))
        .toList();
    return units;
  }

  // DONE: Create convert()
  /// Given two units, converts from one to another.
  ///
  /// Returns a double, which is the converted amount. Returns null on error.
  Future<String> convert(
      String category, String amount, String fromUnit, String toUnit) async {
    final uri = Uri.https(url, '/$category/convert',
        {'amount': amount, 'from': fromUnit, 'to': toUnit});
    final httpReq = await httpClient.getUrl(uri);
    final httpRes = await httpReq.close();
    if (httpRes.statusCode != HttpStatus.ok) {
      return null;
    }
    final resBody = await httpRes.transform(utf8.decoder).join();
    final jsonRes = json.decode(resBody);
    return jsonRes['conversion'].toString();
  }
}
