class Company {
  Company({
    required this.name,
    required this.address,
    required this.contact,
    required this.description,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] as String,
      address: json['address'] as String,
      contact: Contact.fromJson(json['contact'] as Map<String, dynamic>),
      description: json['description'] as String,
    );
  }

  String name;
  String address;
  Contact contact;
  String description;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'contact': contact.toJson(),
      'description': description,
    };
  }
}

class Contact {
  Contact({required this.phone, required this.email});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'] as String,
      email: json['email'] as String,
    );
  }
  String phone;
  String email;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'phone': phone,
      'email': email,
    };
  }
}

class Service {
  Service({required this.name});

  factory Service.fromJson(String name) {
    return Service(name: name);
  }
  String name;

  String toJson() {
    return name;
  }
}

class Project {
  Project({
    required this.name,
    required this.type,
    required this.location,
    required this.status,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      status: json['status'] as String,
    );
  }
  String name;
  String type;
  String location;
  String status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'type': type,
      'location': location,
      'status': status,
    };
  }
}

class Employee {
  Employee({
    required this.name,
    required this.role,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'] as String,
      role: json['role'] as String,
    );
  }
  String name;
  String role;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'role': role,
    };
  }
}

class CompanyData {
  CompanyData({
    required this.id,
    required this.company,
    required this.services,
    required this.projects,
    required this.employees,
  });

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    return CompanyData(
      id: json['id'] as String, // Explicit cast to String
      company: Company.fromJson(json['company']
          as Map<String, dynamic>), // Cast to Map<String, dynamic>
      services: List<String>.from(
          json['services'] as List<dynamic>), // Cast to List<String>
      projects: (json['projects'] as List<dynamic>)
          .map((item) => Project.fromJson(item as Map<String,
              dynamic>)) // Cast each item to Map<String, dynamic>
          .toList(),
      employees: (json['employees'] as List<dynamic>)
          .map((item) => Employee.fromJson(item as Map<String,
              dynamic>)) // Cast each item to Map<String, dynamic>
          .toList(),
    );
  }
  String id;
  Company company;
  List<String> services;
  List<Project> projects;
  List<Employee> employees;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'company': company.toJson(),
      'services': services,
      'projects': projects.map((Project e) => e.toJson()).toList(),
      'employees': employees.map((Employee e) => e.toJson()).toList(),
    };
  }
}
