import 'dart:convert';
import 'package:frontend/core/env_service.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/modules/questionnaire/model/questionnaire_detail_model.dart';
import 'package:frontend/modules/questionnaire/model/questionnaire_model.dart';
import 'package:frontend/modules/questionnaire/model/questionnaire_response_model.dart';
import 'package:frontend/modules/questionnaire/model/ai_response_model.dart';

class QuestionnaireService {
  static final String baseUrl = EnvService.baseUrl;

  Future<List<QuestionnaireModel>> getAllQuestionnaires() async {
    final url = Uri.parse("$baseUrl/api/v1/queationnaire/all");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> data = body['data']['questionnaires'];

      return data.map((e) => QuestionnaireModel.fromMap(e)).toList();
    } else {
      throw Exception("Failed to load questionnaires");
    }
  }

  Future<QuestionnaireDetailModel> fetchQuestionnaireById(String id) async {
    final url = Uri.parse("$baseUrl/api/v1/queationnaire/get/$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data']['questionnaire'];

      return QuestionnaireDetailModel.fromJson(data);
    } else {
      throw Exception("Failed to load questionnaire details");
    }
  }

  Future<AIResponseModel?> submitQuestionnaireResponse(
    QuestionnaireResponseModel model,
  ) async {
    final url = Uri.parse("$baseUrl/api/v1/response");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(model.toJson()),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return AIResponseModel.fromJson(body['data']);
    } else {
      return null;
    }
  }
}
