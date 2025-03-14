import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomInfoDialogController {
  Function(Widget, LatLng)? addInfoDialog;
  VoidCallback? onCameraMove;
  VoidCallback? hideInfoDialog;
  GoogleMapController? googleMapController;

  void dispose() {
    addInfoDialog = null;
    onCameraMove = null;
    hideInfoDialog = null;
    googleMapController = null;
  }
}

class CustomInfoDialog extends StatefulWidget {
  const CustomInfoDialog({
    Key? key,
    required this.controller,
    this.offset = 50,
    this.width = 256,
    this.height = 90,
  }) : super(key: key);
  final CustomInfoDialogController controller;
  final double offset;
  final double width;
  final double height;
  @override
  _CustomInfoDialogState createState() => _CustomInfoDialogState();
}

class _CustomInfoDialogState extends State<CustomInfoDialog> {
  bool _showDialog = false;
  double _leftMargin = 0;
  double _topMargin = 0;
  Widget? _child;
  LatLng? _latLng;

  @override
  void initState() {
    super.initState();
    widget.controller.addInfoDialog = _addInfoDialog;
    widget.controller.onCameraMove = _onCameraMove;
    widget.controller.hideInfoDialog = _hideInfoDialog;
  }

  void _addInfoDialog(Widget child, LatLng latLng) {
    _child = child;
    _latLng = latLng;
    _updateInfoDialog();
  }

  void _onCameraMove() {
    if (!_showDialog) {
      return;
    }
    _updateInfoDialog();
  }

  void _hideInfoDialog() {
    setState(() {
      _showDialog = false;
    });
  }

  void _updateInfoDialog() async {
    if (_latLng == null ||
        _child == null ||
        widget.controller.googleMapController == null) {
      return;
    }
    ScreenCoordinate screenCoordinate = await widget
        .controller.googleMapController!
        .getScreenCoordinate(_latLng!);
    double devicePixelRatio =
        Platform.isAndroid ? MediaQuery.of(context).devicePixelRatio : 1.0;
    double left = (screenCoordinate.x.toDouble() / devicePixelRatio) -
        (widget.width / 2);
    double top = (screenCoordinate.y.toDouble() / devicePixelRatio) -
        (widget.offset + widget.height);
    setState(() {
      _showDialog = true;
      _leftMargin = left;
      _topMargin = top;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _leftMargin,
      top: _topMargin,
      child: Visibility(
        visible: _showDialog,
        child: FittedBox(
          child: _child,
        ),
      ),
    );
  }
}
