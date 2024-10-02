
class DonationOptions {
  late final String _id;
  late final double _value;

  DonationOptions(this._id, this._value);

  String getID() {return _id;}
  double getValue() {return _value;}

  static final List<DonationOptions> _options = [
    DonationOptions("beystats_five_dollar_donation", 4.99),
    DonationOptions("beystats_ten_dollar_donation", 9.99),
    DonationOptions("beystats_twenty_five_dollar_donation", 24.99),
  ];

  static List<String> getAllID() {
    return _options.map((opt) => opt.getID()).toList();
  }

  static Set<String> getSetOfID() {
    return Set.from(DonationOptions.getAllID());
  }

  static List<DonationOptions> getOptions() {
    return _options;
  }
}