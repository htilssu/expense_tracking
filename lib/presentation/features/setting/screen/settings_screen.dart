import 'package:expense_tracking/domain/entity/user.dart';
import 'package:expense_tracking/presentation/bloc/user/user_bloc.dart';
import 'package:expense_tracking/presentation/bloc/language/language_bloc.dart';
import 'package:expense_tracking/presentation/features/setting/screen/change_password_screen.dart';
import 'package:expense_tracking/presentation/features/setting/screen/edit_profile_screen.dart';
import 'package:expense_tracking/utils/biometric_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracking/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:equatable/equatable.dart';

// Sự kiện BLoC
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserDataEvent extends SettingsEvent {
  final User? user;

  const LoadUserDataEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class ToggleDarkModeEvent extends SettingsEvent {
  final bool enabled;

  const ToggleDarkModeEvent(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class ToggleNotificationsEvent extends SettingsEvent {
  final bool enabled;

  const ToggleNotificationsEvent(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class ToggleBiometricsEvent extends SettingsEvent {
  final bool enabled;

  const ToggleBiometricsEvent(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class ChangeCurrencyEvent extends SettingsEvent {
  final String currency;

  const ChangeCurrencyEvent(this.currency);

  @override
  List<Object> get props => [currency];
}

class CheckBiometricsAvailabilityEvent extends SettingsEvent {}

// Trạng thái BLoC
class SettingsState extends Equatable {
  final User? user;
  final bool darkMode;
  final bool notificationsEnabled;
  final bool biometricsEnabled;
  final String currency;
  final bool isBiometricsAvailable;
  final bool isLoading;

  const SettingsState({
    this.user,
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.biometricsEnabled = false,
    this.currency = 'VND',
    this.isBiometricsAvailable = false,
    this.isLoading = false,
  });

  SettingsState copyWith({
    User? user,
    bool? darkMode,
    bool? notificationsEnabled,
    bool? biometricsEnabled,
    String? currency,
    bool? isBiometricsAvailable,
    bool? isLoading,
  }) {
    return SettingsState(
      user: user ?? this.user,
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      currency: currency ?? this.currency,
      isBiometricsAvailable:
          isBiometricsAvailable ?? this.isBiometricsAvailable,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        user,
        darkMode,
        notificationsEnabled,
        biometricsEnabled,
        currency,
        isBiometricsAvailable,
        isLoading,
      ];
}

// BLoC
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<LoadUserDataEvent>(_onLoadUserData);
    on<ToggleDarkModeEvent>(_onToggleDarkMode);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
    on<ToggleBiometricsEvent>(_onToggleBiometrics);
    on<ChangeCurrencyEvent>(_onChangeCurrency);
    on<CheckBiometricsAvailabilityEvent>(_onCheckBiometricsAvailability);
  }

  void _onLoadUserData(LoadUserDataEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(user: event.user));
  }

  void _onToggleDarkMode(
      ToggleDarkModeEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(darkMode: event.enabled));
    // TODO: Lưu cài đặt vào SharedPreferences
  }

  void _onToggleNotifications(
      ToggleNotificationsEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(notificationsEnabled: event.enabled));
    // TODO: Lưu cài đặt vào SharedPreferences
  }

  Future<void> _onToggleBiometrics(
      ToggleBiometricsEvent event, Emitter<SettingsState> emit) async {
    if (event.enabled) {
      emit(state.copyWith(isLoading: true));

      final authenticated = await BiometricAuth.authenticate(
        reason: 'Xác thực để bật tính năng sinh trắc học',
      );

      if (authenticated) {
        // Lưu ID người dùng hiện tại nếu xác thực thành công
        final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await BiometricAuth.saveBiometricUser(currentUser.uid);
          await BiometricAuth.setBiometricEnabled(true);
          emit(state.copyWith(biometricsEnabled: true, isLoading: false));
        }
      } else {
        // Xác thực thất bại, không bật tính năng
        emit(state.copyWith(biometricsEnabled: false, isLoading: false));
      }
    } else {
      // Tắt tính năng sinh trắc học
      await BiometricAuth.setBiometricEnabled(false);
      emit(state.copyWith(biometricsEnabled: false));
    }
  }

  void _onChangeCurrency(
      ChangeCurrencyEvent event, Emitter<SettingsState> emit) {
    emit(state.copyWith(currency: event.currency));
    // TODO: Lưu cài đặt vào SharedPreferences
  }

  Future<void> _onCheckBiometricsAvailability(
      CheckBiometricsAvailabilityEvent event,
      Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoading: true));

    // Kiểm tra thiết bị có hỗ trợ sinh trắc học không
    final canCheckBiometrics = await BiometricAuth.canCheckBiometrics();
    final availableBiometrics = await BiometricAuth.getAvailableBiometrics();

    if (canCheckBiometrics && availableBiometrics.isNotEmpty) {
      // Lấy trạng thái xác thực sinh trắc học từ bộ nhớ
      final isEnabled = await BiometricAuth.isBiometricEnabled();
      emit(state.copyWith(
        isBiometricsAvailable: true,
        biometricsEnabled: isEnabled,
        isLoading: false,
      ));
    } else {
      emit(state.copyWith(
        isBiometricsAvailable: false,
        isLoading: false,
      ));
    }
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    _initSettingsData();
  }

  void _initSettingsData() {
    // Lấy dữ liệu người dùng từ UserBloc
    final userState = BlocProvider.of<UserBloc>(context).state;
    if (userState is UserLoaded) {
      context.read<SettingsBloc>().add(LoadUserDataEvent(userState.user));
    }

    // Kiểm tra khả năng sử dụng sinh trắc học
    context.read<SettingsBloc>().add(CheckBiometricsAvailabilityEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = context.watch<LanguageBloc>().state is LanguageChanged
        ? (context.watch<LanguageBloc>().state as LanguageChanged).locale
        : const Locale('vi');

    String languageText = 'Tiếng Việt';
    if (currentLocale.languageCode == 'en') {
      languageText = 'English';
    }

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              l10n.settings,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Phần thông tin người dùng
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    image: state.user?.avatar.isNotEmpty == true
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                state.user!.avatar),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: state.user?.avatar.isNotEmpty != true
                                      ? Icon(
                                          Icons.person,
                                          size: 35,
                                          color: theme.colorScheme.primary,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.user?.fullName ?? 'Người dùng',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        state.user?.email ??
                                            'email@example.com',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: theme.colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    // Chỉnh sửa hồ sơ
                                    if (state.user != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileScreen(
                                                  user: state.user!),
                                        ),
                                      ).then((updated) {
                                        if (updated == true) {
                                          _initSettingsData(); // Cập nhật lại dữ liệu người dùng sau khi chỉnh sửa
                                        }
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Phần cài đặt chung
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'Cài đặt chung',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSettingsSection([
                          _buildSettingItem(
                            Icons.dark_mode,
                            'Chế độ tối',
                            trailing: Switch(
                              value: state.darkMode,
                              activeColor: theme.colorScheme.primary,
                              onChanged: (value) {
                                context
                                    .read<SettingsBloc>()
                                    .add(ToggleDarkModeEvent(value));
                              },
                            ),
                          ),
                          _buildSettingItem(
                            Icons.notifications,
                            'Thông báo',
                            trailing: Switch(
                              value: state.notificationsEnabled,
                              activeColor: theme.colorScheme.primary,
                              onChanged: (value) {
                                context
                                    .read<SettingsBloc>()
                                    .add(ToggleNotificationsEvent(value));
                              },
                            ),
                          ),
                          _buildSettingItem(
                            Icons.fingerprint,
                            'Xác thực sinh trắc học',
                            trailing: state.isBiometricsAvailable
                                ? Switch(
                                    value: state.biometricsEnabled,
                                    activeColor: theme.colorScheme.primary,
                                    onChanged: (value) {
                                      context
                                          .read<SettingsBloc>()
                                          .add(ToggleBiometricsEvent(value));
                                    },
                                  )
                                : Text(
                                    'Không khả dụng',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                          ),
                        ]),

                        const SizedBox(height: 16),

                        // Phần ngôn ngữ và tiền tệ
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            '${l10n.language} & ${l10n.currency}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSettingsSection([
                          _buildSettingItem(
                            Icons.language,
                            l10n.language,
                            subtitle: languageText,
                            onTap: () {
                              _showLanguageDialog(context);
                            },
                          ),
                          _buildSettingItem(
                            Icons.currency_exchange,
                            l10n.currency,
                            subtitle: state.currency,
                            onTap: () {
                              _showCurrencyDialog(context, state.currency);
                            },
                          ),
                        ]),

                        const SizedBox(height: 16),

                        // Phần tài khoản và bảo mật
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'Tài khoản & Bảo mật',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSettingsSection([
                          _buildSettingItem(
                            Icons.lock,
                            'Đổi mật khẩu',
                            onTap: () {
                              // Điều hướng đến màn hình đổi mật khẩu
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangePasswordScreen(),
                                ),
                              );
                            },
                          ),
                          _buildSettingItem(
                            Icons.backup,
                            'Sao lưu dữ liệu',
                            onTap: () {
                              // Hiện tùy chọn sao lưu
                            },
                          ),
                          _buildSettingItem(
                            Icons.delete_outline,
                            'Xóa tài khoản',
                            titleColor: Colors.red,
                            onTap: () {
                              // Hiện dialog xác nhận xóa tài khoản
                              _showDeleteAccountDialog(context);
                            },
                          ),
                        ]),

                        const SizedBox(height: 16),

                        // Phần hỗ trợ
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'Hỗ trợ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildSettingsSection([
                          _buildSettingItem(
                            Icons.help_outline,
                            'Trung tâm trợ giúp',
                            onTap: () {},
                          ),
                          _buildSettingItem(
                            Icons.policy_outlined,
                            'Chính sách bảo mật',
                            onTap: () {},
                          ),
                          _buildSettingItem(
                            Icons.info_outline,
                            'Thông tin ứng dụng',
                            subtitle: 'Phiên bản 1.0.0',
                            onTap: () {},
                          ),
                        ]),

                        const SizedBox(height: 30),

                        // Nút đăng xuất
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: InkWell(
                            onTap: () {
                              // Xử lý đăng xuất
                              _showLogoutDialog(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: theme.colorScheme.error,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Đăng xuất',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildSettingsSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title, {
    String? subtitle,
    Widget? trailing,
    Color? titleColor,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
                (onTap != null
                    ? const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = context.read<LanguageBloc>().state is LanguageChanged
        ? (context.read<LanguageBloc>().state as LanguageChanged).locale
        : const Locale('vi');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Tiếng Việt'),
              leading: Radio<Locale>(
                value: const Locale('vi'),
                groupValue: currentLocale,
                onChanged: (Locale? value) {
                  if (value != null) {
                    context.read<LanguageBloc>().add(ChangeLanguage(value));
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('English'),
              leading: Radio<Locale>(
                value: const Locale('en'),
                groupValue: currentLocale,
                onChanged: (Locale? value) {
                  if (value != null) {
                    context.read<LanguageBloc>().add(ChangeLanguage(value));
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, String currentCurrency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn đơn vị tiền tệ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('VND - Việt Nam Đồng'),
              trailing: currentCurrency == 'VND'
                  ? Icon(Icons.check,
                      color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                context
                    .read<SettingsBloc>()
                    .add(const ChangeCurrencyEvent('VND'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('USD - US Dollar'),
              trailing: currentCurrency == 'USD'
                  ? Icon(Icons.check,
                      color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                context
                    .read<SettingsBloc>()
                    .add(const ChangeCurrencyEvent('USD'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tài khoản'),
        content: const Text(
            'Bạn có chắc chắn muốn xóa tài khoản? Hành động này không thể hoàn tác và tất cả dữ liệu của bạn sẽ bị mất.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              // Xử lý xóa tài khoản
              Navigator.pop(context);
            },
            child: Text(
              'Xóa',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              // Xóa thông tin xác thực sinh trắc học khi đăng xuất
              await BiometricAuth.clearBiometricUser();
              // Đăng xuất khỏi Firebase
              await firebase_auth.FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            child: Text(
              'Đăng xuất',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
