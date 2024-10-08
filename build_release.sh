echo BUILDING LANGUAGE FILES;
flutter gen-l10n
echo BUILDING IOS IPA;
flutter build ipa --release;
echo BUILDING ANDROID BUNDLE;
flutter build appbundle --release;