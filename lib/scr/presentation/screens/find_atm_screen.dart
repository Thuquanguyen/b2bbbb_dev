import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/marker_model.dart';
import 'package:b2b/scr/data/repository/find_atm_repository.dart';
import 'package:b2b/scr/presentation/widgets/animation_builder.dart';
import 'package:b2b/scr/presentation/widgets/custom_info_dialog.dart';
import 'package:b2b/scr/presentation/widgets/lazy_widget.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:dio/dio.dart';
// import 'package:dio_http_cache/dio_http_cache.dart';

class FindATMScreen extends StatefulWidget {
  const FindATMScreen({Key? key}) : super(key: key);
  static const String routeName = 'findATM_screen';

  @override
  _FindATMScreenState createState() => _FindATMScreenState();
}

class _FindATMScreenState extends State<FindATMScreen> {
  final StateHandler _stateHandler = StateHandler(FindATMScreen.routeName);

  //21.0278, 105.8341
  static const String atmType = 'ATM';
  static const String cdmType = 'CDM';
  static const String branchType = 'BRANCH';

  final String markerAPI = 'https://asia-east2-vpbank-online-new---prod.cloudfunctions.net/get/marker';
  final String markerHeaderKey = 'x-uiux-key';
  final String markerHeaderValue = '37/8IiHnkkYelI2u8Lr/+Cidvj/UWlZZnc1hEDzQ1r/NcCqTXD+Ex81H9/E56g==';
  final Completer<GoogleMapController> _completer = Completer();
  List<Marker> markers = <Marker>[];
  final List<MarkerModel> _markerModelList = <MarkerModel>[];
  final List<MarkerModel> _atmList = <MarkerModel>[];
  final List<MarkerModel> _cdmList = <MarkerModel>[];
  final List<MarkerModel> _branchList = <MarkerModel>[];
  final CustomInfoDialogController _customInfoDialog = CustomInfoDialogController();
  late int selectedIndex = 0;
  late bool isLoaded = false;

  late BitmapDescriptor customIcon;
  final Location _location = Location();
  late GoogleMapController _controller;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  final double _cameraZoom = 17.5;
  late double _lat = -1;
  late double _long = -1;
  static LatLng hoCoordinate = const LatLng(21.01605985, 105.81516656);

  double filterLeadingIconSize = 32;

  late bool _atmChecked = true;
  late bool _cdmChecked = true;
  late bool _branchChecked = true;
  late BitmapDescriptor atmBitmap;
  late BitmapDescriptor cdmBitmap;
  late BitmapDescriptor branchBitmap;

  final PanelController _panelController = PanelController();

  double showBottomSheetPosition = 12;
  double hideBottomSheetPosition = -262;
  bool isShowBottomSheetDialog = false;
  int animatedDuration = 250;
  late String bottomSheetType = '';

  final _handler = AnimationHandler();

  // late Dio? _dio;
  // late DioCacheManager? _dioCacheManager;

  @override
  void initState() {
    super.initState();
    setTimeout(() {
      _getMarkerBitmap();
      _getLocation();
      _fetchMarker();
      _fetchMarkerWithDio();
    }, 350);
  }

  @override
  void dispose() {
    _customInfoDialog.dispose();
    isShowBottomSheetDialog = false;
    if (_permissionGranted == PermissionStatus.granted) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          LazyWidget(
            delay: 300,
            child: AnimationBuilder(
              handler: _handler,
              duration: 300,
              builder: () => StateBuilder(
                  routeName: FindATMScreen.routeName,
                  builder: () {
                    return GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(target: hoCoordinate, zoom: _cameraZoom),
                      onMapCreated: _onMapCreated,
                      markers: markers.toSet(),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      onCameraMove: (position) {
                        _customInfoDialog.onCameraMove!();
                      },
                      onTap: (position) {
                        _customInfoDialog.hideInfoDialog!();
                        setState(() {
                          isShowBottomSheetDialog = false;
                        });
                      },
                    );
                  }),
            ),
          ),
          _backButton(),
          _menuContainer(),
          CustomInfoDialog(
            controller: _customInfoDialog,
            width: getInScreenSize(256),
            height: getInScreenSize(96),
          ),
          _filterSliding(),
          _bottomSheetDialog(),
        ],
      ),
    );
  }

  // DioCacheManager _getCacheManager() {
  //   if (_dioCacheManager == null) {
  //     _dioCacheManager = DioCacheManager(CacheConfig(baseUrl: markerAPI));
  //   }
  //   return _dioCacheManager!;
  // }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _customInfoDialog.googleMapController = controller;
    _completer.complete(_controller);
    _handler.start(delay: 300);
  }

  Future<void> _getLocation() async {
    // showLoading();
    setState(() {
      isLoaded = true;
    });
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    if (_permissionGranted == PermissionStatus.granted) {
      try {
        await _location.getLocation().then((res) async {
          final _position = CameraPosition(
            target: LatLng(res.latitude!, res.longitude!),
            zoom: _cameraZoom,
          );
          await _controller.animateCamera(CameraUpdate.newCameraPosition(_position));
          _lat = res.latitude!;
          _long = res.longitude!;
        });
      } catch (e) {
        // hideLoading();
        // setState(() {
        //   isLoading = false;
        // });
        //print('_getLocation Exception $e');
      }
    } else {}
  }

  Future<void> _fetchMarkerWithDio() async {
    try {
      //Check local data first
      // final response = await http.post(
      // Uri.parse(markerAPI),
      // // Send authorization headers to the backend.
      // headers: <String, String>{
      // markerHeaderKey: markerHeaderValue,
      // },
      // ).timeout(Duration(seconds: 30), onTimeout: () {
      // return http.Response('Check your internet connection and try again', 500);
      // });

      var response = await FindAtmRepository().fetchMarker(markerAPI, <String, String>{
        markerHeaderKey: markerHeaderValue,
      });

      if (response.statusCode == 200) {
        final responseJson = response.data;
        bool status = responseJson['status'];
        if (status) {
          _markerModelList.clear();
          _atmList.clear();
          _cdmList.clear();
          _branchList.clear();
          List<dynamic> markers = responseJson['data'];
          for (var element in markers) {
            MarkerModel model = MarkerModel.fromJson(element);
            _addMarkerToList(model);
          }
          //print('markers: ${markers.length}');
          _filterMarker();
        }
      } else {
        showDialogErrorForceGoBack(
          context,
          AppTranslate.i18n.errorNoReasonStr.localized,
          () {
            popScreen(context);
          },
        );
      }
    } catch (e) {
      //print('_fetchMarker Exception: $e');
    }
    // hideLoading();
    // setState(() {
    //   isLoading = false;
    // });
  }

  Future<void> _fetchMarker() async {
    try {
      //Check local data first
      final response = await http.post(
        Uri.parse(markerAPI),
        // Send authorization headers to the backend.
        headers: <String, String>{
          markerHeaderKey: markerHeaderValue,
        },
      ).timeout(const Duration(seconds: 30), onTimeout: () {
        return http.Response('Check your internet connection and try again', 500);
      });

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        bool status = responseJson['status'];
        if (status) {
          _markerModelList.clear();
          _atmList.clear();
          _cdmList.clear();
          _branchList.clear();
          List<dynamic> markers = responseJson['data'];
          for (var element in markers) {
            MarkerModel model = MarkerModel.fromJson(element);
            _addMarkerToList(model);
          }
          //print('markers: ${markers.length}');
          _filterMarker();
        }
      } else if (response.statusCode == 500) {
        showDialogCustom(context, AssetHelper.icoAuthError, 'Connection Error', response.body,
            button1: renderDialogTextButton(context: context, title: 'Retry', onTap: _getLocation));
      } else {
        if (_permissionGranted == PermissionStatus.granted) {
          showToast(response.body);
        } else {
          //print('no show');
        }
      }
    } catch (e) {
      //print('_fetchMarker Exception: $e');
    }
    setState(() {
      isLoaded = true;
    });
  }

  void _addMarkerToList(MarkerModel markerModel) {
    if (markerModel.type.contains(atmType)) {
      _atmList.add(markerModel);
    }
    if (markerModel.type.contains(cdmType)) {
      _cdmList.add(markerModel);
    }
    if (markerModel.type.contains(branchType)) {
      _branchList.add(markerModel);
    }
  }

  void _filterMarker() {
    _markerModelList.clear();
    if (_branchChecked && _atmChecked && _cdmChecked) {
      //Select all
      _markerModelList.addAll(_branchList);
      for (var element in _atmList) {
        if (!_markerModelList.contains(element)) {
          _markerModelList.add(element);
        }
      }
      for (var element in _cdmList) {
        if (!_markerModelList.contains(element)) {
          _markerModelList.add(element);
        }
      }
    } else if (_branchChecked && _atmChecked && !_cdmChecked) {
      //Select branch and atm
      _markerModelList.addAll(_branchList);
      for (var element in _atmList) {
        if (!_markerModelList.contains(element)) {
          _markerModelList.add(element);
        }
      }
    } else if (_branchChecked && !_atmChecked && _cdmChecked) {
      //Select branch and cdm
      _markerModelList.addAll(_branchList);
      for (var element in _cdmList) {
        if (!_markerModelList.contains(element)) {
          _markerModelList.add(element);
        }
      }
    } else if (!_branchChecked && _atmChecked && _cdmChecked) {
      //Select atm and cdm
      _markerModelList.addAll(_atmList);
      for (var element in _cdmList) {
        if (!_markerModelList.contains(element)) {
          _markerModelList.add(element);
        }
      }
    } else if (_branchChecked && !_atmChecked && !_cdmChecked) {
      //Just select branch
      _markerModelList.addAll(_branchList);
    } else if (!_branchChecked && _atmChecked && !_cdmChecked) {
      //Just select atm
      _markerModelList.addAll(_atmList);
    } else if (!_branchChecked && !_atmChecked && _cdmChecked) {
      //Just select cdm
      _markerModelList.addAll(_cdmList);
    } else {
      //Unselect all
    }
    _addMarkers();
  }

  void _addMarkers() async {
    markers.clear();
    for (var i = 0; i < _markerModelList.length; i++) {
      //Add marker
      MarkerId id = MarkerId(_markerModelList[i].id);
      Marker marker = Marker(
        markerId: id,
        icon: _markerIcon(i),
        position: LatLng(
          _markerModelList[i].lat,
          _markerModelList[i].lng,
        ),
        onTap: () => _onTapMarker(i),
      );
      markers.add(marker);
    }
    _stateHandler.refresh();
  }

  BitmapDescriptor _markerIcon(int index) {
    late BitmapDescriptor icon;
    int typeLength = _markerModelList[index].type.length;
    switch (typeLength) {
      case 1:
        if (_markerModelList[index].type[0] == cdmType) {
          icon = cdmBitmap;
        } else if (_markerModelList[index].type[0] == atmType) {
          icon = atmBitmap;
        } else {
          icon = branchBitmap;
        }
        break;
      case 2:
        if (_branchChecked) {
          if (_markerModelList[index].type.contains(branchType)) {
            icon = branchBitmap;
          } else {
            icon = atmBitmap;
          }
        } else {
          if (_atmChecked && !_cdmChecked) {
            //Select atm only
            icon = atmBitmap;
          } else if (!_atmChecked && _cdmChecked) {
            //Select cdm only
            icon = cdmBitmap;
          } else if (_atmChecked && _cdmChecked) {
            //Select atm and cdm
            icon = cdmBitmap;
          } else {
            //print('else _atmChecked: $_atmChecked _cdmChecked $_cdmChecked _branchChecked $_branchChecked');
          }
        }
        break;
      case 3:
        if (_atmChecked && _cdmChecked && _branchChecked) {
          //Select all
          icon = branchBitmap;
        } else if (!_atmChecked && _cdmChecked && _branchChecked) {
          //Select brand and select cdm
          icon = branchBitmap;
        } else if (_atmChecked && !_cdmChecked && _branchChecked) {
          //Select brand and select atm
          icon = branchBitmap;
        } else if (!_atmChecked && !_cdmChecked && _branchChecked) {
          //Select brand only
          icon = branchBitmap;
        } else if (_atmChecked && !_cdmChecked && !_branchChecked) {
          //Select atm only
          icon = atmBitmap;
        } else if (!_atmChecked && _cdmChecked && !_branchChecked) {
          //Select cdm only
          icon = cdmBitmap;
        } else if (_atmChecked && _cdmChecked && !_branchChecked) {
          //Select atm and cdm
          icon = cdmBitmap;
        } else {
          //print('else _atmChecked: $_atmChecked _cdmChecked $_cdmChecked _branchChecked $_branchChecked');
        }
        break;
      default:
        break;
    }
    return icon;
  }

  String _bottomSheetIconType(int index) {
    late String icon;
    int typeLength = _markerModelList[index].type.length;
    switch (typeLength) {
      case 1:
        if (_markerModelList[index].type[0] == cdmType) {
          icon = AssetHelper.icoCdmIcon;
        } else if (_markerModelList[index].type[0] == atmType) {
          icon = AssetHelper.icoAtmIcon;
        } else {
          icon = AssetHelper.icoBranchIcon;
        }
        break;
      case 2:
        if (_branchChecked) {
          if (_markerModelList[index].type.contains(branchType)) {
            icon = AssetHelper.icoBranchIcon;
          } else {
            icon = AssetHelper.icoAtmIcon;
          }
        } else {
          if (_atmChecked && !_cdmChecked) {
            //Select atm only
            icon = AssetHelper.icoAtmIcon;
          } else if (!_atmChecked && _cdmChecked) {
            //Select cdm only
            icon = AssetHelper.icoCdmIcon;
          } else if (_atmChecked && _cdmChecked) {
            //Select atm and cdm
            icon = AssetHelper.icoCdmIcon;
          } else {
            //print('else _atmChecked: $_atmChecked _cdmChecked $_cdmChecked _branchChecked $_branchChecked');
          }
        }
        break;
      case 3:
        if (_atmChecked && _cdmChecked && _branchChecked) {
          //Select all
          icon = AssetHelper.icoBranchIcon;
        } else if (!_atmChecked && _cdmChecked && _branchChecked) {
          //Select brand and select cdm
          icon = AssetHelper.icoBranchIcon;
        } else if (_atmChecked && !_cdmChecked && _branchChecked) {
          //Select brand and select atm
          icon = AssetHelper.icoBranchIcon;
        } else if (!_atmChecked && !_cdmChecked && _branchChecked) {
          //Select brand only
          icon = AssetHelper.icoBranchIcon;
        } else if (_atmChecked && !_cdmChecked && !_branchChecked) {
          //Select atm only
          icon = AssetHelper.icoAtmIcon;
        } else if (!_atmChecked && _cdmChecked && !_branchChecked) {
          //Select cdm only
          icon = AssetHelper.icoCdmIcon;
        } else if (_atmChecked && _cdmChecked && !_branchChecked) {
          //Select atm and cdm
          icon = AssetHelper.icoCdmIcon;
        } else {
          //print('else _atmChecked: $_atmChecked _cdmChecked $_cdmChecked _branchChecked $_branchChecked');
        }
        break;
      default:
        break;
    }

    if (icon == AssetHelper.icoAtmIcon) {
      bottomSheetType = 'ATM';
    } else if (icon == AssetHelper.icoCdmIcon) {
      bottomSheetType = 'CDM';
    } else {
      bottomSheetType = 'BRANCH';
    }

    return icon;
  }

  String _bottomSheetWorkingTime(int index) {
    late String workingTime;
    if (_markerModelList[index].atmWorkingTime == null &&
        _markerModelList[index].cdmWorkingTime == null &&
        _markerModelList[index].branchWorkingTime == null) {
      workingTime = '';
    } else {
      int typeLength = _markerModelList[index].type.length;
      switch (typeLength) {
        case 1:
          if (_markerModelList[index].type[0] == cdmType) {
            workingTime = _markerModelList[index].cdmWorkingTime!;
          } else if (_markerModelList[index].type[0] == atmType) {
            workingTime = _markerModelList[index].atmWorkingTime!;
          } else {
            workingTime = _markerModelList[index].branchWorkingTime!;
          }
          break;
        case 2:
          if (_branchChecked) {
            if (_markerModelList[index].type.contains(branchType)) {
              workingTime = _markerModelList[index].branchWorkingTime!;
            } else {
              workingTime = _markerModelList[index].atmWorkingTime!;
            }
          } else {
            if (_atmChecked && !_cdmChecked) {
              //Select atm only
              workingTime = _markerModelList[index].atmWorkingTime!;
            } else if (!_atmChecked && _cdmChecked) {
              //Select cdm only
              workingTime = _markerModelList[index].cdmWorkingTime!;
            } else if (_atmChecked && _cdmChecked) {
              //Select atm and cdm
              workingTime = _markerModelList[index].cdmWorkingTime!;
            } else {
              //print('else _atmChecked: $_atmChecked _cdmChecked $_cdmChecked _branchChecked $_branchChecked');
            }
          }
          break;
        case 3:
          if (_atmChecked && _cdmChecked && _branchChecked) {
            //Select all
            workingTime = _markerModelList[index].branchWorkingTime!;
          } else if (!_atmChecked && _cdmChecked && _branchChecked) {
            //Select brand and select cdm
            workingTime = _markerModelList[index].branchWorkingTime!;
          } else if (_atmChecked && !_cdmChecked && _branchChecked) {
            //Select brand and select atm
            workingTime = _markerModelList[index].branchWorkingTime!;
          } else if (!_atmChecked && !_cdmChecked && _branchChecked) {
            //Select brand only
            workingTime = _markerModelList[index].branchWorkingTime!;
          } else if (_atmChecked && !_cdmChecked && !_branchChecked) {
            //Select atm only
            workingTime = _markerModelList[index].atmWorkingTime!;
          } else if (!_atmChecked && _cdmChecked && !_branchChecked) {
            //Select cdm only
            workingTime = _markerModelList[index].cdmWorkingTime!;
          } else if (_atmChecked && _cdmChecked && !_branchChecked) {
            //Select atm and cdm
            workingTime = _markerModelList[index].cdmWorkingTime!;
          } else {
            //print('else _atmChecked: $_atmChecked _cdmChecked $_cdmChecked _branchChecked $_branchChecked');
          }
          break;
        default:
          break;
      }
    }
    return workingTime;
  }

  void _onTapMarker(int index) {
    _customInfoDialog.addInfoDialog!(
      Container(
        padding: EdgeInsetsDirectional.all(getInScreenSize(8)),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.45)),
          borderRadius: BorderRadius.circular(8),
        ),
        width: getInScreenSize(256),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _atmName(index),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              _markerModelList[index].address,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
      LatLng(_markerModelList[index].lat, _markerModelList[index].lng),
    );
    setState(() {
      isShowBottomSheetDialog = true;
      selectedIndex = index;
    });
  }

  String _atmName(int index) {
    String name = '';
    if (_markerModelList[index].type.contains(branchType)) {
      name = AppTranslate.i18n.findAtmTitleBranchStr.localized + ' ${_markerModelList[index].name}';
    } else {
      name = _markerModelList[index].name;
    }
    return name;
  }

  void _openMapDirection(LatLng latLng) async {
    String url = '';
    String urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = 'https://maps.google.com/maps?saddr=&daddr=${latLng.latitude},${latLng.longitude}';
    } else {
      urlAppleMaps = 'https://maps.apple.com/?q=${latLng.latitude},${latLng.longitude}';
      url = 'comgooglemaps://?saddr=&daddr=${latLng.latitude},${latLng.longitude}&directionsmode=driving';
      if (await canLaunch(url)) {
        await launch(url);
        return;
      } else {
        showToast('Chức năng chỉ đường không khả dụng');
        throw 'Could not launch $url';
      }
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else if (await canLaunch(urlAppleMaps)) {
      await launch(urlAppleMaps);
    } else {
      try {
        await launch(url);
      } catch(e) {
        throw 'Could not launch $url';
      }
      // showDialogCustom(
      //   context,
      //   AssetHelper.icoStatementComplate,
      //   AppTranslate.i18n.dialogTitleNotificationStr.localized,
      //   AppTranslate.i18n.sotpActivatedOtherDeviceDialogContentStr.localized,
      //   button1: renderDialogTextButton(
      //       context: context, title: AppTranslate.i18n.dialogButtonSkipStr.localized, onTap: () {}),
      // );
    }
  }

  Future<void> _getMarkerBitmap() async {
    Uint8List cdm = await _getBytesFromAsset(AssetHelper.icoCdmIcon, 96);
    Uint8List atm = await _getBytesFromAsset(AssetHelper.icoAtmIcon, 96);
    Uint8List branch = await _getBytesFromAsset(AssetHelper.icoBranchIcon, 96);
    cdmBitmap = BitmapDescriptor.fromBytes(cdm);
    atmBitmap = BitmapDescriptor.fromBytes(atm);
    branchBitmap = BitmapDescriptor.fromBytes(branch);
    _stateHandler.refresh();
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Widget _backButton() {
    return Positioned(
      left: getInScreenSize(16),
      top: getInScreenSize(48),
      child: Touchable(
        onTap: () {
          popScreen(context);
        },
        child: Container(
          width: getInScreenSize(40),
          height: getInScreenSize(40),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            borderRadius: BorderRadius.circular(getInScreenSize(12)),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _filterSliding() {
    return SlidingUpPanel(
      controller: _panelController,
      onPanelClosed: () {},
      onPanelSlide: (value) {},
      onPanelOpened: () {},
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      minHeight: getInScreenSize(0),
      maxHeight: getInScreenSize(232),
      panel: Column(
        children: [
          Touchable(
            onTap: () {
              _panelController.close();
            },
            child: SizedBox(
              width: double.infinity,
              height: getInScreenSize(24),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: getInScreenSize(72),
                  height: getInScreenSize(3),
                  decoration:
                      BoxDecoration(color: Colors.grey.withOpacity(0.45), borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Image.asset(
              AssetHelper.icoAtmIcon,
              width: getInScreenSize(filterLeadingIconSize),
              height: getInScreenSize(filterLeadingIconSize),
            ),
            title: Text(AppTranslate.i18n.findAtmTitleAtmMachineStr.localized),
            onTap: () {
              setState(() {
                _atmChecked = !_atmChecked;
                _filterMarker();
              });
            },
            trailing: Image.asset(
              _atmChecked ? AssetHelper.icoFindAtmChecked : AssetHelper.icoFindAtmUnchecked,
              width: getInScreenSize(24),
              height: getInScreenSize(24),
            ),
          ),
          ListTile(
            leading: Image.asset(
              AssetHelper.icoCdmIcon,
              width: getInScreenSize(filterLeadingIconSize),
              height: getInScreenSize(filterLeadingIconSize),
            ),
            title: Text(AppTranslate.i18n.findAtmTitleAtmDepositStr.localized),
            onTap: () {
              setState(() {
                _cdmChecked = !_cdmChecked;
                _filterMarker();
              });
            },
            trailing: Image.asset(
              _cdmChecked ? AssetHelper.icoFindAtmChecked : AssetHelper.icoFindAtmUnchecked,
              width: getInScreenSize(24),
              height: getInScreenSize(24),
            ),
          ),
          ListTile(
            leading: Image.asset(
              AssetHelper.icoBranchIcon,
              width: getInScreenSize(filterLeadingIconSize),
              height: getInScreenSize(filterLeadingIconSize),
            ),
            title: Text(AppTranslate.i18n.findAtmTitleTransactionBranchStr.localized),
            onTap: () {
              setState(() {
                _branchChecked = !_branchChecked;
                _filterMarker();
              });
            },
            trailing: Image.asset(
              _branchChecked ? AssetHelper.icoFindAtmChecked : AssetHelper.icoFindAtmUnchecked,
              width: getInScreenSize(24),
              height: getInScreenSize(24),
            ),
          ),
          Platform.isIOS
              ? SizedBox(
                  height: getInScreenSize(16),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _menuContainer() {
    return !isLoaded
        ? const SizedBox()
        : Positioned(
            right: getInScreenSize(20),
            bottom: getInScreenSize(32),
            child: Column(
              children: [
                Touchable(
                  onTap: () {
                    _panelController.open();
                  },
                  child: Container(
                    width: getInScreenSize(48),
                    height: getInScreenSize(48),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(getInScreenSize(12)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.filter_alt_outlined,
                        size: getInScreenSize(24),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getInScreenSize(12),
                ),
                Touchable(
                  onTap: () {
                    if (_lat >= 0 && _long >= 0) {
                      final _position = CameraPosition(
                        target: LatLng(_lat, _long),
                        zoom: _cameraZoom,
                      );
                      _controller.animateCamera(CameraUpdate.newCameraPosition(_position));
                    } else {
                      //print('request location');
                      _getLocation();
                    }
                  },
                  child: Container(
                    width: getInScreenSize(48),
                    height: getInScreenSize(48),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(getInScreenSize(12)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.location_on_outlined,
                        size: getInScreenSize(24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _bottomSheetDialog() {
    if (_markerModelList.isEmpty) {
      return const SizedBox();
    } else {
      MarkerModel markerModel = _markerModelList[selectedIndex];
      return AnimatedPositioned(
        duration: Duration(milliseconds: animatedDuration),
        left: 0,
        right: 0,
        bottom: isShowBottomSheetDialog
            ? getInScreenSize(showBottomSheetPosition)
            : getInScreenSize(hideBottomSheetPosition),
        // ignore: unnecessary_null_comparison
        child: markerModel == null
            ? const SizedBox()
            : Container(
                margin: EdgeInsets.all(getInScreenSize(4)),
                padding: EdgeInsets.all(getInScreenSize(4)),
                width: SizeConfig.screenWidth,
                height: getInScreenSize(260),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: getInScreenSize(50),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              markerModel.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Align(
                            alignment: const Alignment(0, -0.9),
                            child: Container(
                              height: getInScreenSize(3),
                              width: getInScreenSize(48),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(12)), color: Colors.grey),
                            ),
                          ),
                          IconButton(
                            alignment: const Alignment(-0.95, 0),
                            onPressed: () {
                              setState(() {
                                isShowBottomSheetDialog = false;
                                selectedIndex = 0;
                                _customInfoDialog.hideInfoDialog!();
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getInScreenSize(50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: getInScreenSize(16)),
                            child: Image.asset(
                              _bottomSheetIconType(selectedIndex),
                              width: getInScreenSize(28),
                              height: getInScreenSize(28),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              bottomSheetType,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getInScreenSize(50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: getInScreenSize(16)),
                            child: Icon(
                              Icons.location_on_outlined,
                              size: getInScreenSize(28),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              markerModel.address,
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getInScreenSize(50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: getInScreenSize(16)),
                            child: Icon(
                              Icons.timer,
                              size: getInScreenSize(28),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _bottomSheetWorkingTime(selectedIndex),
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Touchable(
                        onTap: () {
                          LatLng latLng = LatLng(markerModel.lat, markerModel.lng);
                          _openMapDirection(latLng);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: const Center(
                            child: Text(
                              'Chỉ đường',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      );
    }
  }
}
