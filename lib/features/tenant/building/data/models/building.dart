class Building {
  final String id;
  final String buildingName;
  final String code;
  final String address;
  final int? managerId;
  final String managerName;
  final int totalApartments;
  final String emergencyPhone;

  const Building({
    required this.id,
    required this.buildingName,
    required this.code,
    required this.address,
    required this.managerId,
    required this.managerName,
    required this.totalApartments,
    required this.emergencyPhone,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'] as String,
      buildingName: json['buildingName'] as String,
      code: json['code'] as String,
      address: json['address'] as String,
      managerId: json['managerId'] as int?,
      managerName: json['managerName'] as String,
      totalApartments: json['totalApartments'] as int,
      emergencyPhone: json['emergencyPhone'] as String,
    );
  }
}