import 'dart:io';

import 'package:expense_tracking/domain/entity/user.dart';
import 'package:expense_tracking/infrastructure/repository/user_repository_impl.dart';
import 'package:expense_tracking/presentation/bloc/loading/loading_cubit.dart';
import 'package:expense_tracking/presentation/bloc/user/user_bloc.dart';
import 'package:expense_tracking/presentation/common_widgets/et_button.dart';
import 'package:expense_tracking/presentation/common_widgets/et_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  File? _selectedImage;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _avatarUrl = widget.user.avatar;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } on PlatformException catch (e) {
      _showErrorDialog('Không thể chọn ảnh: ${e.message}');
    } catch (e) {
      _showErrorDialog('Đã xảy ra lỗi khi chọn ảnh');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Hiện loading
    if (!mounted) return;
    context.read<LoadingCubit>().showLoading();

    try {
      // Lưu ảnh lên server (trong ứng dụng thật, cần upload lên Firebase Storage)
      // Đây là phiên bản đơn giản, chỉ giả định đã lưu thành công

      // Trong ứng dụng thật, bạn sẽ upload ảnh lên Firebase Storage
      // và lấy URL
      String avatarUrl = _avatarUrl ?? '';
      if (_selectedImage != null) {
        // Giả định đã upload ảnh và lấy URL
        // avatarUrl = await uploadImage(_selectedImage!);
        // Đây là giả lập, trong thực tế sẽ sử dụng URL thật
        avatarUrl = _selectedImage!.path;
      }

      final userRepository = UserRepositoryImpl();
      final updatedUser = widget.user.clone();
      updatedUser.firstName = _firstNameController.text.trim();
      updatedUser.lastName = _lastNameController.text.trim();
      updatedUser.avatar = avatarUrl;

      await userRepository.update(updatedUser);

      // Cập nhật state trong UserBloc
      if (!mounted) return;
      BlocProvider.of<UserBloc>(context).add(UpdateUserEvent(updatedUser));

      // Ẩn loading
      context.read<LoadingCubit>().hideLoading();

      Navigator.of(context)
          .pop(true); // Trả về true để biết đã cập nhật thành công
    } catch (e) {
      // Ẩn loading
      if (!mounted) return;
      context.read<LoadingCubit>().hideLoading();
      _showErrorDialog('Không thể cập nhật thông tin: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Chỉnh sửa thông tin',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              'Lưu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Avatar
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                                  ? DecorationImage(
                                      image: NetworkImage(_avatarUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                        ),
                        child: _selectedImage == null &&
                                (_avatarUrl == null || _avatarUrl!.isEmpty)
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Email không thể chỉnh sửa
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.email, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.user.email,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Họ
                EtTextField(
                  controller: _firstNameController,
                  label: 'Họ',
                  suffixIcon: const Icon(Icons.person),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập họ của bạn';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Tên
                EtTextField(
                  controller: _lastNameController,
                  label: 'Tên',
                  suffixIcon: const Icon(Icons.person),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tên của bạn';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Nút lưu
                EtButton(
                  onPressed: _saveChanges,
                  borderRadius: 12,
                  height: 50,
                  child: const Text(
                    'Lưu thay đổi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
