class StockUser {
  final String name;
  final String? gmail;
  final String country;
  final String companyName;
  final String phoneNumber;
  final String role;
  final String password;

  StockUser({
    required this.password,
    required this.name,
    this.gmail,
    required this.country,
    required this.companyName,
    required this.phoneNumber,
    required this.role,
  });
}
