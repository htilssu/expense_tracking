import 'package:expense_tracking/presentation/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/text_constant.dart';
import '../clipper/home_app_bar_clipper.dart';

class EtHomeAppbar extends StatelessWidget {
  const EtHomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
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
                  colorFilter: const ColorFilter.mode(
                      Color(0xFF003F81), BlendMode.srcIn),
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
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            String fullName = '';
                            if (state is UserLoaded) {
                              fullName = state.user.fullName;
                            }

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Xin chào',
                                  style: TextStyle(
                                      fontSize: TextSize.medium + 2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                                Text(
                                  fullName,
                                  style: TextStyle(
                                      fontSize: TextSize.large,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                )
                              ],
                            );
                          },
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
