class SearchDto {
  final String org_name;
  final String org_type;
   int page;
  static String convert(String interests) {
    if (interests == "For-Profit") return "for_profit";
    if (interests == "Non-Profit") return "non_profit";
    if (interests == "Government") return "government";
    if (interests == "Community") return "community";
    if (interests == "Education") return "educational";
    if (interests == "Healthcare") {
      return "healthcare";
    } else if (interests == "Cultural") {
      return "cultural";
    } else
      return '';
  }

  SearchDto({required this.org_name, required org_type,this.page=1})
      : org_type = convert(org_type);
}
