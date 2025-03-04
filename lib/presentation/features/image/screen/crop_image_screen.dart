import 'package:camera/camera.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:expense_tracking/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracking/presentation/bloc/scan_bill/scan_bill_bloc.dart';
import 'package:expense_tracking/presentation/features/transaction/screen/scan_bill_screen.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracking/utils/image.dart' as image;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CropImageScreen extends StatelessWidget {
  final XFile _capturedImage;
  final CropController _cropController = CropController();

  CropImageScreen(this._capturedImage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        var scanBillBloc =
                            BlocProvider.of<ScanBillBloc>(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: scanBillBloc,
                                child: const ScanBillScreen(),
                              ),
                            ));
                      },
                      child: Text(
                        'Hủy',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      )),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _cropController.crop();
                    },
                    child: Text(
                      'Xong',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _capturedImage.readAsBytes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Crop(
                      image: snapshot.data!,
                      controller: _cropController,
                      initialRectBuilder: InitialRectBuilder.withBuilder(
                          (viewportRect, imageRect) {
                        return Rect.fromLTRB(imageRect.left, imageRect.top,
                            imageRect.width, imageRect.bottom);
                      }),
                      onCropped: (croppedImage) async {
                        if (croppedImage is CropSuccess) {
                          var croppedImageFile =
                              await image.Image.saveCroppedImage(
                                  croppedImage.croppedImage);

                          var categoryBloc =
                              BlocProvider.of<CategoryBloc>(context);

                          if (categoryBloc.state is CategoryLoaded) {
                            BlocProvider.of<ScanBillBloc>(context).add(ScanBill(
                                croppedImageFile.path,
                                (categoryBloc.state as CategoryLoaded)
                                    .categories));
                          } else {
                            throw Exception('CategoryBloc is not loaded');
                          }

                          Navigator.pop(context, croppedImage.croppedImage);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Có lỗi xảy ra khi cắt ảnh, vui lòng thử lại')));
                        }
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
