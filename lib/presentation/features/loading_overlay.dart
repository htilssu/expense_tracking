import 'package:expense_tracking/presentation/bloc/loading/loading_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingOverlay extends StatefulWidget {
  final Widget child;

  const LoadingOverlay(this.child, {super.key});

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  late OverlayEntry _overlayEntry;
  bool _isOverlayVisible = false;

  @override
  void initState() {
    super.initState();
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Container(
          color: Colors.black.withAlpha(60),
          child: Center(
            child:
                LoadingAnimationWidget.inkDrop(color: Colors.green, size: 30),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    if (_isOverlayVisible) {
      _overlayEntry.remove();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCubit, LoadingState>(
      builder: (context, state) {
        if (state is Loading && !_isOverlayVisible) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Overlay.of(context).insert(_overlayEntry);
            setState(() {
              _isOverlayVisible = true;
            });
          });
        } else if (state is! Loading && _isOverlayVisible) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _overlayEntry.remove();
            setState(() {
              _isOverlayVisible = false;
            });
          });
        }
        return widget.child;
      },
    );
  }
}
