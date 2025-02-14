import 'package:crop_your_image/crop_your_image.dart';
import 'package:expense_tracking/presentation/features/transaction/screen/scan_bill_screen.dart';
import 'package:flutter/material.dart';
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
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScanBillScreen(),
                            ));
                      },
                      child: Text(
                        "Hủy",
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
                      "Xong",
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
                      onCropped: (croppedImage) {
                        if (croppedImage is CropSuccess) {
                          Navigator.pop(context, croppedImage.croppedImage);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Có lỗi xảy ra khi cắt ảnh, vui lòng thử lại")));
                        }
                      },
                    );
                  }
                  return Center(
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
