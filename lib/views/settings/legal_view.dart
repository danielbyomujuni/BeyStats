import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:bey_stats/widgets/sub_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class LegalView extends StatelessWidget {
  const LegalView({super.key});

  @override
  Widget build(BuildContext context) {
    return SubRoot(
      subTitle: "Legal",
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
          return const Center(child: Text('Error loading privacy policy.'));
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Card(
              child: Accordion(
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
                  header: const Row(children: [Icon(Icons.lock),SizedBox(width: 20), Text("Privacy Policy")],), 
                  content: 
                  Card(color: 
                    Theme.of(context).colorScheme.primary, 
                    child: Padding(padding: const EdgeInsets.all(10.0),
                    child:MarkdownBody(data: snapshot.data!['privacy']!),))
                  ,),
                  AccordionSection(
                  header: const Row(children: [Icon(Icons.handshake),SizedBox(width: 20), Text("License Agreement")],), 
                  content: 
                  Card(color: 
                    Theme.of(context).colorScheme.primary, 
                    child: Padding(padding: const EdgeInsets.all(10.0),
                    child:MarkdownBody(data: snapshot.data!['license']!),))
                  ,),
                  ],
              )
            )
          );
        } else {
          return const Center(child: Text('No privacy policy found.'));
        }
      },
    ));
  }
}
