import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/postulation_card_dto.dart';

class PostulationsService {
  final http.Client client;
  static const String baseUrl =
      'https://innospacebackend-gebta4gkasgkhaap.chilecentral-01.azurewebsites.net';

  PostulationsService(this.client);

  Future<List<PostulationCardDto>> getPostulationsByManager(
    int managerId,
  ) async {
    final response = await client.get(
      Uri.parse('$baseUrl/api/v1/collaboration-cards/managers/$managerId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => PostulationCardDto.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load postulations: ${response.statusCode}');
    }
  }
}