import 'package:flutter/material.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../../authentication/domain/entity/user/user_entity.dart';

class ProfileHeader extends StatelessWidget {

  const ProfileHeader({super.key, required this.user});
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 100,
      pinned: false,
      backgroundColor: GSColors.primary600,
      flexibleSpace: FlexibleSpaceBar(
        background: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: GSColorTokens.primaryGradientVertical,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(GSSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mon Profil',
                        style: GSTypography.headingLarge.copyWith(
                          color: GSColors.neutral000,
                          fontSize: GSFontScale.sf09,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
