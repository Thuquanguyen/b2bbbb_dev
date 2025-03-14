import 'dart:typed_data';
import 'package:b2b/commons.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:io';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/ensure_visible_when_focused.dart';
import 'package:b2b/scr/presentation/widgets/keyboard_aware_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:screenshot/screenshot.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);
  static String routeName = 'test_page';

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNodeFirstName = FocusNode();
  final FocusNode _focusNodeLastName = FocusNode();
  final FocusNode _focusNodeDescription = FocusNode();
  static final TextEditingController _firstNameController = TextEditingController();
  static final TextEditingController _lastNameController = TextEditingController();
  static final TextEditingController _descriptionController = TextEditingController();
  ScreenshotController screenshotController1 = ScreenshotController();
  ScreenshotController screenshotController2 = ScreenshotController();
  ScreenshotController screenshotController3 = ScreenshotController();

  Future<void> capture() async {
    showLoading();
    Uint8List? im1 = await screenshotController1.capture();
    Uint8List? im2 = await screenshotController2.capture();
    Uint8List? im3 = await screenshotController3.capture();
    List<Uint8List?> list = [im1, im2, im3];
    Uint8List? im = await ImageHelper.join(list);
    if (im != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/ahd_screenshot.png').create();
      await imagePath.writeAsBytes(im);
      Logger.debug(imagePath.path);
      await Share.shareFiles([imagePath.path], text: 'Shared from VPBank NEOBiz', mimeTypes: ['image/png']);
    }
    hideLoading();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: 'TEST',
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      appBarType: AppBarType.SMALL,
      actions: [
        Touchable(
            child: Container(
                alignment: Alignment.center, padding: const EdgeInsets.all(10), child: const Text('Screenshot')),
            onTap: () {
              capture();
            })
      ],
      child: KeyboardAwareScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /* -- Something large -- */
            /* -- First Name -- */
            Screenshot(
                controller: screenshotController1,
                child: EnsureVisibleWhenFocused(
                  focusNode: _focusNodeFirstName,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.person),
                      hintText: 'Enter your first name',
                      labelText: 'First name *',
                    ),
                    controller: _firstNameController,
                    focusNode: _focusNodeFirstName,
                  ),
                )),
            const SizedBox(height: 24.0),
            const SizedBox(height: 24.0),
            /* -- Description -- */
            Screenshot(
                controller: screenshotController2,
                child: EnsureVisibleWhenFocused(
                  focusNode: _focusNodeDescription,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Tell us about yourself',
                      labelText: 'Describe yourself',
                    ),
                    maxLines: 5,
                    controller: _descriptionController,
                    focusNode: _focusNodeDescription,
                  ),
                )),
            const SizedBox(height: 24.0),

            /* -- Save Button -- */
            Center(
              // ignore: deprecated_member_use
              child: RaisedButton(
                child: const Text('Save'),
                onPressed: () {
                },
              ),
            ),
            const SizedBox(height: 24.0),
            const SizedBox(height: 24.0),

            /* -- Last Name -- */
            Screenshot(
                controller: screenshotController3,
                child: EnsureVisibleWhenFocused(
                  focusNode: _focusNodeLastName,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      icon: const Icon(Icons.person),
                      hintText: 'Enter your last name',
                      labelText: 'Last name *',
                    ),
                    controller: _lastNameController,
                    focusNode: _focusNodeLastName,
                  ),
                )),
            const SizedBox(height: 24.0),
            // CustomInputDateTime(),
          ],
        ),
      ),
    );
  }
}
