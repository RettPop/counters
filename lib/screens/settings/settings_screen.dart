import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(settingsNotifierProvider);
    final syncEnabled = settingsAsync.valueOrNull?.syncEnabled ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SwitchListTile(
                  title: Text(l10n.settingsSyncTitle),
                  subtitle: Text(l10n.settingsSyncDescription),
                  value: syncEnabled,
                  onChanged: (value) {
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .setSyncEnabled(value);
                  },
                ),
              ],
            ),
          ),
          const _AppVersionFooter(),
        ],
      ),
    );
  }
}

class _AppVersionFooter extends StatelessWidget {
  const _AppVersionFooter();

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
      fontSize: 12,
    );

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                Text(info?.appName ?? '', style: labelStyle),
                Text(info?.version ?? '', style: labelStyle),
              ],
            ),
          ),
        );
      },
    );
  }
}
