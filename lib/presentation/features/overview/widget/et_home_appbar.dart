import 'package:expense_tracking/presentation/bloc/user/user_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/text_constant.dart';
import '../../../../domain/entity/user.dart' as entity;
import '../clipper/home_app_bar_clipper.dart';
import 'et_notify.dart';

class EtHomeAppbar extends StatelessWidget {
  const EtHomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<UserBloc>(context).state;
    entity.User? user;
    if (state is UserLoaded) {
      user = state.user;
    }

    return SizedBox(
      width: double.infinity,
      height: 280,
      child: ClipPath(
        clipper: HomeAppBarClipper(),
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Stack(
            children: [
              Positioned(
                left: -60,
                top: 30,
                child: SvgPicture.asset(
                  'assets/images/ellipse_3.svg',
                  colorFilter:
                      const ColorFilter.mode(Color(0xFF003F81), BlendMode.srcIn),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Xin chào',
                              style: TextStyle(
                                  fontSize: TextSize.medium + 2,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                            Text(
                              user?.fullName ?? '',
                              style: TextStyle(
                                  fontSize: TextSize.large,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            )
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            BlocProvider.of<UserBloc>(context).add(ClearUserEvent());
                          },
                          icon: const EtNotify(false),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white24,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
