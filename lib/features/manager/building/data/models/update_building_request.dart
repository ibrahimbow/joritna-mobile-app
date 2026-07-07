class UpdateBuildingRequest {
  final String buildingName;
  final String address;
  final int totalApartments;
  final String emergencyPhone;

  const UpdateBuildingRequest({
    required this.buildingName,
    required this.address,
    required this.totalApartments,
    required this.emergencyPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'buildingName': buildingName,
      'address': address,
      'totalApartments': totalApartments,
      'emergencyPhone': emergencyPhone,
    };
  }
}
