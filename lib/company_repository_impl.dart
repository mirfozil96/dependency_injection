import 'dart:convert';
import 'package:http/http.dart' as http;
import 'company_repository.dart';
import 'model.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final String apiUrl = 'https://65d3570a522627d50108ac00.mockapi.io/company';

  @override
  Future<List<CompanyData>> getCompanyData() async {
    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body)
            as List<dynamic>; // Explicit cast to List<dynamic>
        return jsonList
            .map<CompanyData>((json) => CompanyData.fromJson(
                json as Map<String, dynamic>)) // Add type annotation in map
            .toList();
      } else {
        throw Exception('Failed to load company data');
      }
    } catch (error) {
      throw Exception('Error fetching company data');
    }
  }

  @override
  Future<void> createCompanyData(CompanyData data) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create company data');
      }
    } catch (error) {
      throw Exception('Error creating company data');
    }
  }

  @override
  Future<void> updateCompanyData(String id, CompanyData data) async {
    try {
      final http.Response response = await http.put(
        Uri.parse(
            '$apiUrl/$id'), // Use the company ID to update a specific record
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update company data');
      }
    } catch (error) {
      throw Exception('Error updating company data');
    }
  }

  @override
  Future<void> deleteCompanyData(String id) async {
    try {
      final http.Response response = await http
          .delete(Uri.parse('$apiUrl/$id')); // Use the company ID for deletion

      if (response.statusCode != 200) {
        throw Exception('Failed to delete company data');
      }
    } catch (error) {
      throw Exception('Error deleting company data');
    }
  }
}
