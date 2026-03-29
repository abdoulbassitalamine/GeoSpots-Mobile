import 'package:flutter/material.dart';
import 'package:geo_spots/core/constants/app_constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../view_model/upsert_place_view_model.dart';
import 'widgets/upsert_place_basic_info_step.dart';
import 'widgets/upsert_place_location_step.dart';
import 'widgets/upsert_place_progress_indicator.dart';

class UpsertPlacePage extends ConsumerStatefulWidget {
  const UpsertPlacePage({super.key, required this.placeId, this.initialExtra});

  final String placeId;
  final Map<String, Object?>? initialExtra;

  @override
  ConsumerState<UpsertPlacePage> createState() => _UpsertPlacePageState();
}

class _UpsertPlacePageState extends ConsumerState<UpsertPlacePage> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    final initialData = _UpsertPlaceInitialData.fromExtra(widget.initialExtra);
    if (initialData == null) {
      return;
    }

    ref
        .read(upsertPlaceViewModelProvider(widget.placeId).notifier)
        .applyInitialDeepLinkData(
          latitude: initialData.latitude,
          longitude: initialData.longitude,
          title: initialData.title,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      upsertPlaceViewModelProvider(
        widget.placeId,
      ).select((state) => state.snackbarMessage),
      (previous, next) {
        if (next == null || previous == next) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) {
            return;
          }
          next.show(context);
          ref
              .read(upsertPlaceViewModelProvider(widget.placeId).notifier)
              .consumeSnackbar();
        });
      },
    );

    final state = ref.watch(upsertPlaceViewModelProvider(widget.placeId));
    final viewModel = ref.read(
      upsertPlaceViewModelProvider(widget.placeId).notifier,
    );

    final steps = [
      UpsertPlaceBasicInfoStepView(state: state, notifier: viewModel),
      UpsertPlaceLocationStepView(state: state, notifier: viewModel),
    ];
    final hasLoadError = state.loadErrorMessage != null;
    final canRenderForm = !state.isLoading && !hasLoadError;

    return GSScaffold(
      backgroundColor: GSColorTokens.backgroundPrimary,
      body: Column(
        children: [
          _UpsertPlaceHeader(
            currentStep: _currentStep,
            isEditMode: state.isEditMode,
          ),
          if (canRenderForm)
            Padding(
              padding: const EdgeInsets.all(GSSpacing.xl),
              child: UpsertPlaceProgressIndicator(
                currentIndex: _currentStep,
                size: steps.length,
              ),
            ),
          Expanded(
            child: switch ((state.isLoading, hasLoadError)) {
              (true, _) => const Center(child: GSCircularLoader()),
              (false, true) => GSErrorState(
                title: 'Impossible de charger le lieu',
                message: state.loadErrorMessage!,
                onRetry: state.isEditMode ? viewModel.reload : null,
                retryLabel: state.isEditMode ? 'Réessayer' : null,
              ),
              _ => SingleChildScrollView(
                padding: const EdgeInsets.all(GSSpacing.xl),
                child: steps[_currentStep],
              ),
            },
          ),
          if (canRenderForm)
            _UpsertPlaceBottomActions(
              currentStep: _currentStep,
              totalSteps: steps.length,
              placeId: widget.placeId,
              onBack: () => setState(() => _currentStep--),
              onNext: () => setState(() => _currentStep++),
            ),
        ],
      ),
    );
  }
}

class _UpsertPlaceHeader extends StatelessWidget {
  const _UpsertPlaceHeader({
    required this.currentStep,
    required this.isEditMode,
  });
  final int currentStep;
  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    final titles = ['Informations de base', 'Position et organisation'];

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: GSColorTokens.primaryGradientVertical,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            GSSpacing.xl,
            GSSpacing.xl,
            GSSpacing.xl,
            GSSpacing.xl3,
          ),
          child: Row(
            children: [
              GSBackButton(
                color: GSColors.neutral000,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: GSSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditMode ? 'Modifier le lieu' : 'Nouveau lieu',
                      style: GSTypography.headingMedium.copyWith(
                        color: GSColors.neutral000,
                        fontSize: GSFontScale.sf07,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.xs),
                    Text(
                      titles[currentStep],
                      style: GSTypography.bodyDefaultMedium.copyWith(
                        color: GSColors.neutral000.withValues(alpha: 0.8),
                      ),
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

class _UpsertPlaceBottomActions extends ConsumerWidget {
  const _UpsertPlaceBottomActions({
    required this.currentStep,
    required this.totalSteps,
    required this.placeId,
    required this.onBack,
    required this.onNext,
  });
  final int currentStep;
  final int totalSteps;
  final String placeId;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(upsertPlaceViewModelProvider(placeId));
    final viewModel = ref.read(upsertPlaceViewModelProvider(placeId).notifier);

    return Container(
      padding: const EdgeInsets.all(GSSpacing.xl),
      decoration: BoxDecoration(
        color: GSColors.neutral000,
        boxShadow: [GSShadows.m(direction: GSShadowsDirection.top)],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (currentStep > 0) ...[
              Expanded(
                child: GSOutlinedButton(onPressed: onBack, text: 'Retour'),
              ),
              const SizedBox(width: GSSpacing.l),
            ],
            Expanded(
              child: currentStep == totalSteps - 1
                  ? GSFilledButton(
                      enabled: viewModel.isStep1Valid,
                      onPressed: () async {
                        final isSaved = await viewModel.savePlace();
                        if (isSaved && context.mounted) {
                          GSScaffoldSnackbar.showSuccess(
                            context,
                            message: state.isEditMode
                                ? 'Lieu mis à jour'
                                : 'Lieu créé',
                          );
                          Navigator.of(context).pop(true);
                        }
                      },
                      text: state.isSaving
                          ? 'Enregistrement...'
                          : state.isEditMode
                          ? 'Mettre à jour'
                          : 'Créer le lieu',
                      isLoading: state.isSaving,
                    )
                  : GSFilledButton(
                      enabled: viewModel.isStep0Valid,
                      onPressed: viewModel.isStepValid(currentStep)
                          ? onNext
                          : () {},
                      text: 'Suivant',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpsertPlaceInitialData {
  const _UpsertPlaceInitialData({this.latitude, this.longitude, this.title});

  final double? latitude;
  final double? longitude;
  final String? title;

  static _UpsertPlaceInitialData? fromExtra(Map<String, Object?>? extra) {
    if (extra == null || extra.isEmpty) {
      return null;
    }

    final latitude = _asDouble(extra[kExtraLatitude]);
    final longitude = _asDouble(extra[kExtraLongitude]);
    final title = _asNonEmptyString(extra[kExtraTitle]);

    if (latitude == null && longitude == null && title == null) {
      return null;
    }

    return _UpsertPlaceInitialData(
      latitude: latitude,
      longitude: longitude,
      title: title,
    );
  }

  static double? _asDouble(Object? value) {
    return switch (value) {
      final double v => v,
      final int v => v.toDouble(),
      final String v => double.tryParse(v),
      _ => null,
    };
  }

  static String? _asNonEmptyString(Object? value) {
    if (value is! String) {
      return null;
    }
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }
}
