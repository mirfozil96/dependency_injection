import 'dart:developer';

import 'package:flutter/material.dart';

import 'company_repository.dart';
import 'get_it.dart';
import 'model.dart';

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CompanyScreen(),
    );
  }
}

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  CompanyScreenState createState() => CompanyScreenState();
}

class CompanyScreenState extends State<CompanyScreen> {
  final CompanyRepository repository = getIt<CompanyRepository>();

  late Future<List<CompanyData>> _companiesFuture;

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  // Function to load company data
  void _loadCompanyData() {
    setState(() {
      _companiesFuture = repository.getCompanyData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Info'),
      ),
      body: FutureBuilder<List<CompanyData>>(
        future: _companiesFuture,
        builder: (BuildContext context, AsyncSnapshot<List<CompanyData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            log('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Data Available'));
          } else {
            final List<CompanyData> companies = snapshot.data!;

            return ListView.builder(
              itemCount: companies.length,
              itemBuilder: (BuildContext context, int index) {
                final CompanyData company = companies[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Company: ${company.company.name}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text('Address: ${company.company.address}'),
                        Text('Phone: ${company.company.contact.phone}'),
                        Text('Email: ${company.company.contact.email}'),
                        const SizedBox(height: 10),
                        const Text('Services:'),
                        for (final String service in company.services)
                          Text('• $service'),
                        const SizedBox(height: 10),
                        const Text('Projects:'),
                        for (final Project project in company.projects)
                          Text(
                              '${project.name} (${project.type}) - ${project.status}'),
                        const SizedBox(height: 10),
                        const Text('Employees:'),
                        for (final Employee employee in company.employees)
                          Text('${employee.name} - ${employee.role}'),
                        const SizedBox(height: 10),

                        // Buttons for Update and Delete operations
                        Row(
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                updateCompany(repository, company.id, company);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Updated company')),
                                );
                              },
                              child: const Text('Update'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                deleteCompany(repository, company.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Deleted company')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),

      // Floating action button for creating a new company
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewCompany(repository);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Created new company')),
          );
        },
        tooltip: 'Create New Company',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Create a new company
  Future<void> createNewCompany(CompanyRepository repository) async {
    final CompanyData newCompany = CompanyData(
        id: '2',
        company: Company(
            name: 'New Company Ltd.',
            address: '456 Oak Street, San Francisco, CA, USA',
            contact: Contact(
                phone: '+1-555-678-9101', email: 'contact@newcompany.com'),
            description: 'A new company specializing in tech products.'),
        services: <String>[
          'Software Development',
          'Cloud Services'
        ],
        projects: <Project>[
          Project(
              name: 'Project Alpha',
              type: 'Software',
              location: 'San Francisco',
              status: 'In Progress')
        ],
        employees: <Employee>[
          Employee(name: 'Alice Johnson', role: 'Developer'),
          Employee(name: 'Mark Taylor', role: 'Manager')
        ]);

    await repository.createCompanyData(newCompany);
    _loadCompanyData(); // Refresh the UI after creating a company
  }

  // Update an existing company
  Future<void> updateCompany(CompanyRepository repository, String companyId,
      CompanyData company) async {
    final CompanyData updatedCompany = CompanyData(
      id: '2',
      company: Company(
        name: 'Updated Company Ltd.',
        address: company.company.address,
        contact: company.company.contact,
        description: company.company.description,
      ),
      services: company.services, // Assuming same services for now
      projects: company.projects, // Assuming same projects
      employees: company.employees, // Assuming same employees
    );

    await repository.updateCompanyData(companyId, updatedCompany);
    _loadCompanyData(); // Refresh the UI after updating a company
  }

  // Delete a company
  Future<void> deleteCompany(CompanyRepository repository, String companyId) async {
    await repository.deleteCompanyData(companyId);
    _loadCompanyData(); // Refresh the UI after deleting a company
  }
}
