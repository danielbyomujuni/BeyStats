import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const ActionButtons({
    required this.onSave,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: FilledButton(
          onPressed: onSave,
          child: Text(AppLocalizations.of(context)!.saveLabel),
        ),
      ),
      const SizedBox(width: 15.0),
      Expanded(
        child: OutlinedButton(
          onPressed: onCancel,
          child: Text(AppLocalizations.of(context)!.cancelLabel),
        ),
      ),
    ]);
  }
}