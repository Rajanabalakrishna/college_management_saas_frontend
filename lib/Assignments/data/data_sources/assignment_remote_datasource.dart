

import 'dart:convert';
import 'package:http/http.dart' as http;

class AssignmentRemoteDataSource {
  final String baseUrl;
  final String accessToken;

  AssignmentRemoteDataSource({required this.baseUrl, required this.accessToken});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  // GET all assignments (auto-scoped by role on backend)
  Future<Map<String, dynamic>> getAssignments({int page = 1, int limit = 10}) async {
    final uri = Uri.parse('$baseUrl/api/v1/assignments?page=$page&limit=$limit');
    final res  = await http.get(uri, headers: _headers);
    return jsonDecode(res.body);
  }

  // GET single
  Future<Map<String, dynamic>> getAssignment(String id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/v1/assignments/$id'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  // POST create (faculty)
  Future<Map<String, dynamic>> createAssignment(Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/v1/assignments'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return jsonDecode(res.body);
  }

  // PATCH update/publish
  Future<Map<String, dynamic>> updateAssignment(String id, Map<String, dynamic> body) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/api/v1/assignments/$id'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return jsonDecode(res.body);
  }

  // POST submit (student)
  Future<Map<String, dynamic>> submitAssignment(String id, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/v1/assignments/$id/submit'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return jsonDecode(res.body);
  }

  // GET my submission
  Future<Map<String, dynamic>> getMySubmission(String assignmentId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/v1/assignments/$assignmentId/my-submission'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  // GET all submissions (faculty)
  Future<Map<String, dynamic>> getSubmissions(String assignmentId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/v1/assignments/$assignmentId/submissions'),
      headers: _headers,
    );
    return jsonDecode(res.body);
  }

  // PATCH grade
  Future<Map<String, dynamic>> gradeSubmission(
      String assignmentId, String submissionId, Map<String, dynamic> body
      ) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/api/v1/assignments/$assignmentId/submissions/$submissionId/grade'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return jsonDecode(res.body);
  }
}