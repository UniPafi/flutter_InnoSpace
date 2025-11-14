class ApiConstants {
  static const String baseUrl = "https://innospacebackend-gebta4gkasgkhaap.chilecentral-01.azurewebsites.net/api/v1";

  // Authentication
  static const String signIn = "/authentication/sign-in";
  static const String signUp = "/authentication/sign-up";

  // Manager Profiles
  static const String managerProfiles = "/manager-profiles";

  // Opportunities (¡NUEVO!)
  static const String opportunities = "/opportunities";
  static const String opportunitiesByCompany = "/opportunities/company"; // Usaremos -> /opportunities/company/{managerId}
  static const String publishOpportunity = "/publish"; // Usaremos -> /opportunities/{id}/publish
  static const String closeOpportunity = "/close";   // Usaremos -> /opportunities/{id}/close
}