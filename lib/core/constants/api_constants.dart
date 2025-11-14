class ApiConstants {
  // ---
  // NOTA: El backend que me diste (Azure) parece tener la URL base ya
  // incluida en todos los paths del OpenAPI. Si ese es el caso, 
  // la baseUrl sería solo "/", pero lo normal es lo siguiente:
  // ---
  
  // Base URL
  static const String baseUrl = "https://innospacebackend-gebta4gkasgkhaap.chilecentral-01.azurewebsites.net/api/v1";

  // Authentication
  static const String signIn = "/authentication/sign-in";
  static const String signUp = "/authentication/sign-up";

  // Manager Profiles
  static const String managerProfiles = "/manager-profiles";

  // ... (Aquí irán los demás endpoints)
}