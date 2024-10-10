import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:bey_stats/widgets/sub_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LegalView extends StatelessWidget {
  const LegalView({super.key});

  @override
  Widget build(BuildContext context) {
    return SubRoot(
      subTitle: AppLocalizations.of(context)!.legalTitle,
      child: FutureBuilder<Map<String, String>>(
      future: () async {
        AssetBundle cxt = DefaultAssetBundle.of(context);

        return { 
          "privacy": await cxt.loadString("assets/privacy.md"),
          "license": await cxt.loadString("assets/license.md"),
        };
        }(),




      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(AppLocalizations.of(context)!.errorLoadingPrivacyPolicy));
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column( children:[
              Card(
                margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: 
                Center(child:
                Padding(padding: const EdgeInsets.all(10.0), child:
                Column(
                  children: [
                    const Icon(Icons.gavel,size: 50.0),
                    const SizedBox(height: 7.0,),
                    Text(AppLocalizations.of(context)!.legalDescription),
                  ],
                )))
              ),
                
              Accordion(
                scaleWhenAnimating: false,
                disableScrolling: true,
                headerBackgroundColor: Theme.of(context).colorScheme.primary,
                headerPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                contentBackgroundColor:  Theme.of(context).colorScheme.surface,
                sectionOpeningHapticFeedback: SectionHapticFeedback.light,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                contentHorizontalPadding: 0,
                children: [
                AccordionSection(
                  header: Row(children: [const Icon(Icons.lock),const SizedBox(width: 20), Text(AppLocalizations.of(context)!.privacyPolicy)],), 
                  content: 
                  Card(color: 
                    Theme.of(context).colorScheme.primary, 
                    child: Padding(padding: const EdgeInsets.all(10.0),
                    child:MarkdownBody(data: snapshot.data!['privacy']!),))
                  ,),
                  AccordionSection(
                  header: Row(children: [const Icon(Icons.handshake),const SizedBox(width: 20), Text(AppLocalizations.of(context)!.licenseAgreement)],), 
                  content: 
                  Card(color: 
                    Theme.of(context).colorScheme.primary, 
                    child: Padding(padding: const EdgeInsets.all(10.0),
                    child:MarkdownBody(data: snapshot.data!['license']!),))
                  ,),
                  ],
              )
            ])
          );
        } else {
          return Center(child: Text(AppLocalizations.of(context)!.noPoliciesFound));
        }
      },
    ));
  }
}
