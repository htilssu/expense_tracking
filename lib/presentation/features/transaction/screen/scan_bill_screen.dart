import 'package:camera/camera.dart';
import 'package:expense_tracking/presentation/bloc/scan_bill/scan_bill_bloc.dart';
import 'package:expense_tracking/utils/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../image/screen/crop_image_screen.dart';

/// Screen for scanning bill
/// User can take a picture or pick an image from gallery
/// Then crop the image to get the bill
class ScanBillScreen extends StatefulWidget {
  const ScanBillScreen({super.key});

  @override
  State<ScanBillScreen> createState() => _CameraControlScreenState();
}

class _CameraControlScreenState extends State<ScanBillScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isCameraReady = false;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(cameras[0], ResolutionPreset.max);
      _initializeControllerFuture = _cameraController.initialize();
      await _initializeControllerFuture;
      if (!mounted) return;
      setState(() {
        _isCameraReady = true;
      });
    } on CameraException catch (e) {
      Logger.error('Camera Error: ${e.description}');
    }
  }

  Future<void> _takePicture(BuildContext context) async {
    if (!_isCameraReady) return;
    try {
      final image = await _cameraController.takePicture();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BlocProvider.value(
                value: BlocProvider.of<ScanBillBloc>(context),
                child: CropImageScreen(image),
              );
            },
          ),
        );
      }
    } catch (e) {
      Logger.error(e.toString());
    }
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (context.mounted) {
      var t = BlocProvider.of<ScanBillBloc>(context);
      if (image != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BlocProvider.value(
                value: t,
                child: CropImageScreen(image),
              );
            },
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: _capturedImage != null
                          ? Image.file(File(_capturedImage!.path),
                              fit: BoxFit.cover)
                          : _isCameraReady
                              ? _cameraController.buildPreview()
                              : const Center(
                                  child: CircularProgressIndicator()),
                    ),
                  ],
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          0, 8, 0, MediaQuery.of(context).padding.bottom),
                      color: Colors.black.withAlpha(100),
                      child: _buildBottomControls(),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () async {
            await _pickImageFromGallery(context);
          },
          icon: const Icon(Icons.photo_library, color: Colors.white),
        ),
        IconButton(
          icon: const Icon(Icons.camera, color: Colors.white, size: 40),
          onPressed: () {
            _takePicture(context);
          },
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_return_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ],
    );
  }
}
