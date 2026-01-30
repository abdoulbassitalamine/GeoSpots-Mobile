import 'package:flutter/material.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../../authentication/domain/entity/user/user_entity.dart';

class ProfileStats extends StatelessWidget {
  final UserEntity user;
  final int totalPlaces;
  final int totalCollections;
  final int sharedPlaces;

  const ProfileStats({
    super.key,
    required this.user,
    required this.totalPlaces,
    required this.totalCollections,
    required this.sharedPlaces,
  });

  @override
  Widget build(BuildContext context) {
    return GSCard(
      padding: const EdgeInsets.all(GSSpacing.xl3),
      child: Column(
        children: [
          Row(
            children: [
              _ProfileAvatar(user: user),
              const SizedBox(width: GSSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: GSTypography.headingSmall.copyWith(
                        fontSize: GSFontScale.sf06,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.xs),
                    if (user.email != null)
                      Text(
                        user.email!,
                        style: GSTypography.bodyDefaultSmall.copyWith(
                          color: GSColors.neutral600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: GSSpacing.xl3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(value: totalPlaces.toString(), label: 'Lieux'),
              _VerticalDivider(),
              _StatItem(
                value: totalCollections.toString(),
                label: 'Collections',
              ),
              _VerticalDivider(),
              _StatItem(
                value: sharedPlaces.toString(),
                label: 'Partagées',
                isComingSoon: sharedPlaces == 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final UserEntity user;

  const _ProfileAvatar({required this.user});

  String get _initials {
    final firstName = user.firstName ?? '';
    final lastName = user.lastName ?? '';

    if (firstName.isEmpty && lastName.isEmpty) {
      return user.email?.substring(0, 2).toUpperCase() ?? '??';
    }

    final firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0] : '';

    return '$firstInitial$lastInitial'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: GSColors.primary600,
        borderRadius: BorderRadius.circular(GSRadius.l),
      ),
      child: Center(
        child: Text(
          _initials,
          style: GSTypography.headingMedium.copyWith(
            color: GSColors.neutral000,
            fontSize: GSFontScale.sf08,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool isComingSoon;

  const _StatItem({
    required this.value,
    required this.label,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GSTypography.headingMedium.copyWith(
            color: isComingSoon ? GSColors.neutral400 : GSColors.primary600,
            fontSize: GSFontScale.sf08,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: GSSpacing.xs),
        Text(
          label,
          style: GSTypography.bodyDefaultSmall.copyWith(
            color: GSColors.neutral600,
          ),
        ),
        if (isComingSoon) ...[
          const SizedBox(height: GSSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: GSSpacing.s,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: GSColors.warning100,
              borderRadius: BorderRadius.circular(GSRadius.full),
            ),
            child: Text(
              'Bientôt',
              style: GSTypography.captionDefault.copyWith(
                color: GSColors.warning600,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: GSColors.neutral300);
  }
}
