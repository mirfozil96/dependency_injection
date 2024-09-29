import 'model.dart';

abstract class CompanyRepository {
  Future<List<CompanyData>> getCompanyData();  // Fetch all companies
  Future<void> createCompanyData(CompanyData data);  // Create a new company
  Future<void> updateCompanyData(String id, CompanyData data);  // Update an existing company
  Future<void> deleteCompanyData(String id);  // Delete a company by ID
}
