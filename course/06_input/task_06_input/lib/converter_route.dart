// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  /// This [Category]'s name.
  final String name;

  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the name, color, and units to not be null.
  const ConverterRoute({
    @required this.name,
    @required this.color,
    @required this.units,
  })  : assert(name != null),
        assert(color != null),
        assert(units != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  // Done: Set some variables, such as for keeping track of the user's input
  // value and units
  Unit _fromValue;
  Unit _toValue;
  double _inputValue;
  String _convertedValue = '';
  List<DropdownMenuItem> _unitMenuItems;
  bool _showValidationError = false;

  // Done: Determine whether you need to override anything, such as initState()
  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems();
    _createDefaults();
  }

  // Done: Add other helper functions. We've given you one, _format()

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Create the 'input' group of widgets. This is a Column that
    // includes the output value, and 'from' unit [Dropdown].

    var input = Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.number,
            onChanged: _updateInputValue,
            style: Theme.of(context).textTheme.display2,
            decoration: InputDecoration(
                labelText: 'Input',
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 13.0),
                  borderRadius: BorderRadius.circular(0.0),
                ),
                hintText: '1',
                hintStyle: TextStyle(fontSize: 30.0)),
          ),
          _buildDropdown(_fromValue.name, _updateFromConversion),
        ],
      ),
    );

    // Done: Create a compare arrows icon.
    var compareArrows = RotatedBox(
        quarterTurns: 1, child: Icon(Icons.compare_arrows, size: 40.0));

    // Done: Create the 'output' group of widgets. This is a Column that
    var output = Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InputDecorator(
            child: Text(
              _convertedValue,
              style: Theme.of(context).textTheme.display1,
            ),
            decoration: InputDecoration(
                labelText: 'Output',
                labelStyle: Theme.of(context).textTheme.display1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                )),
          ),
          _buildDropdown(_toValue.name, _updateToConversion),
        ],
      ),
    );

    // Done: Return the input, arrows, and output widgets, wrapped in

    // Done: Delete the below placeholder code

    return ListView(
      children: <Widget>[
        input,
        compareArrows,
        output,
      ],
    );
  }

  void _createDropdownMenuItems() {
    var dropdownMenuItems = <DropdownMenuItem>[];

    widget.units.map((Unit unit) {
      dropdownMenuItems.add(DropdownMenuItem(
        value: unit.name,
        child: Row(
          children: <Widget>[
            Text(
              unit.name,
              softWrap: true,
            ),
          ],
        ),
      ));
    }).toList();

    setState(() {
      _unitMenuItems = dropdownMenuItems;
    });
  }

  Widget _buildDropdown(String currentValue, ValueChanged<dynamic> onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: currentValue,
              isExpanded: true,
              style: Theme.of(context).textTheme.title,
              onChanged: onChanged,
              items: _unitMenuItems,
            ),
          ),
        ),
      ),
    );
  }

  void _createDefaults() {
    setState(() {
      _fromValue = widget.units[0];
      _toValue = widget.units[3];
      print(_fromValue.name);
    });
  }

  Unit _getUnit(String unitName) {
    return widget.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }

  void _updateConversion() {
    setState(() {
      _convertedValue =
          _format(_inputValue * (_toValue.conversion / _fromValue.conversion));
    });
  }

  void _updateFromConversion(dynamic unitName) {
    setState(() {
      _fromValue = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toValue = _getUnit(unitName);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  void _updateInputValue(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _convertedValue = '';
      } else {
        // Even though we are using the numerical keyboard, we still have to check
        // for non-numerical input such as '5..0' or '6 -3'
        try {
          final inputDouble = double.parse(input);
          _showValidationError = false;
          _inputValue = inputDouble;
          _updateConversion();
        } on Exception catch (e) {
          print('Error: $e');
          _showValidationError = true;
        }
      }
    });
  }
}
