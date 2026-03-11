import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/features/tracking/presentation/route/route_data.dart';

import '../../../../../shared/design_system/design_system.dart';

class OpenLiveLocationDialog extends HookWidget {
  const OpenLiveLocationDialog({super.key, required this.hostContext});

  final BuildContext hostContext;

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => OpenLiveLocationDialog(hostContext: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputController = useTextEditingController();
    final inputFocusNode = useFocusNode();
    final errorMessage = useState<String?>(null);
    final showHelp = useState(false);

    void submit() {
      final token = _extractLiveLocationToken(inputController.text);
      if (token == null) {
        errorMessage.value =
            'Collez le lien reçu, ou juste le code de partage si vous l’avez.';
        inputFocusNode.requestFocus();
        return;
      }

      Navigator.of(context).pop();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!hostContext.mounted) {
          return;
        }
        LiveLocationRouteData(token: token).push<void>(hostContext);
      });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        title: Text(
          'Ouvrir un suivi en direct',
          style: GSTypography.headingSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GSTextField(
              controller: inputController,
              focusNode: inputFocusNode,
              label: 'Lien reçu',
              placeholder: 'Collez le lien de partage ici',
              maxLines: 3,
              keyboardActions: TextInputAction.done,
              onValueChange: (_) => errorMessage.value = null,
              onSubmitted: (_) => submit(),
              errorMessage: errorMessage.value,
            ),
            const SizedBox(height: GSSpacing.m),
            GestureDetector(
              onTap: () => showHelp.value = !showHelp.value,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    showHelp.value ? Icons.expand_less : Icons.help_outline,
                    size: 18,
                    color: GSColors.primary600,
                  ),
                  const SizedBox(width: GSSpacing.xs),
                  Text(
                    showHelp.value
                        ? 'Masquer l’aide'
                        : 'Je ne sais pas quoi coller',
                    style: GSTypography.bodyAccentSmall.copyWith(
                      color: GSColors.primary600,
                    ),
                  ),
                ],
              ),
            ),
            if (showHelp.value) ...[
              const SizedBox(height: GSSpacing.m),
              GSCard(
                padding: const EdgeInsets.all(GSSpacing.l),
                color: GSColors.neutral100,
                border: Border.all(color: GSColors.neutral300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Aide',
                            style: GSTypography.bodyAccentMedium.copyWith(
                              color: GSColors.neutral800,
                            ),
                          ),
                        ),
                        GSIconButton(
                          icon: Icons.close,
                          onPressed: () => showHelp.value = false,
                          color: GSColors.neutral600,
                          size: 20,
                        ),
                      ],
                    ),
                    Text(
                      'Collez exactement le lien que votre ami vous a envoyé.',
                      style: GSTypography.bodyDefaultSmall.copyWith(
                        color: GSColors.neutral600,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.s),
                    Text(
                      'Exemple',
                      style: GSTypography.bodyAccentSmall.copyWith(
                        color: GSColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.xs),
                    Text(
                      'https://mint-silkworm-optimum.ngrok-free.app/api/location/public/9480c4bb-7f4b-4b9c-a604-e99552451515',
                      style: GSTypography.bodyDefaultSmall.copyWith(
                        color: GSColors.neutral700,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: GSSpacing.s),
                    Text(
                      'Si on vous a envoyé seulement le code final, vous pouvez aussi le coller.',
                      style: GSTypography.bodyDefaultSmall.copyWith(
                        color: GSColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          GSOutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            text: 'Annuler',
          ),
          GSFilledButton(onPressed: submit, text: 'Ouvrir'),
        ],
      ),
    );
  }
}

String? _extractLiveLocationToken(String rawInput) {
  final value = rawInput.trim();
  if (value.isEmpty) {
    return null;
  }

  final parsedUri = Uri.tryParse(value);
  if (parsedUri == null) {
    return _normalizeToken(value);
  }

  final queryToken = parsedUri.queryParameters['token'];
  if (queryToken != null && queryToken.trim().isNotEmpty) {
    return _normalizeToken(queryToken);
  }

  final pathSegments = parsedUri.pathSegments
      .where((segment) => segment.trim().isNotEmpty)
      .toList();
  final liveIndex = pathSegments.lastIndexOf('live-location');
  if (liveIndex != -1 && liveIndex + 1 < pathSegments.length) {
    return _normalizeToken(pathSegments[liveIndex + 1]);
  }

  final publicIndex = pathSegments.lastIndexOf('public');
  if (publicIndex != -1 && publicIndex + 1 < pathSegments.length) {
    return _normalizeToken(pathSegments[publicIndex + 1]);
  }

  if (!value.contains('://') &&
      pathSegments.length == 1 &&
      parsedUri.queryParameters.isEmpty) {
    return _normalizeToken(pathSegments.first);
  }

  return null;
}

String? _normalizeToken(String rawToken) {
  final normalized = Uri.decodeComponent(rawToken).trim();
  if (normalized.isEmpty) {
    return null;
  }
  return normalized;
}
