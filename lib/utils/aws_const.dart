class AWSConst {
  static List<AWSRegion> get regions {
    return [
      const AWSRegion(code: "us-east-1", name: "US East (N. Virginia)"),
      const AWSRegion(code: "us-east-2", name: "US East (Ohio)"),
      const AWSRegion(code: "us-west-1", name: "US West (N. California)"),
      const AWSRegion(code: "us-west-2", name: "US West (Oregon)"),
      const AWSRegion(code: "af-south-1", name: "Africa (Cape Town)"),
      const AWSRegion(code: "ap-east-1", name: "Asia Pacific (Hong Kong)"),
      const AWSRegion(code: "ap-south-2", name: "Asia Pacific (Hyderabad)"),
      const AWSRegion(code: "ap-southeast-3", name: "Asia Pacific (Jakarta)"),
      const AWSRegion(code: "ap-southeast-4", name: "Asia Pacific (Melbourne)"),
      const AWSRegion(code: "ap-south-1", name: "Asia Pacific (Mumbai)"),
      const AWSRegion(code: "ap-northeast-3", name: "Asia Pacific (Osaka)"),
      const AWSRegion(code: "ap-northeast-2", name: "Asia Pacific (Seoul)"),
      const AWSRegion(code: "ap-southeast-1", name: "Asia Pacific (Singapore)"),
      const AWSRegion(code: "ap-southeast-2", name: "Asia Pacific (Sydney)"),
      const AWSRegion(code: "ap-northeast-1", name: "Asia Pacific (Tokyo)"),
      const AWSRegion(code: "ca-central-1", name: "Canada (Central)"),
      const AWSRegion(code: "eu-central-1", name: "Europe (Frankfurt)"),
      const AWSRegion(code: "eu-west-1", name: "Europe (Ireland)"),
      const AWSRegion(code: "eu-west-2", name: "Europe (London)"),
      const AWSRegion(code: "eu-south-1", name: "Europe (Milan)"),
      const AWSRegion(code: "eu-west-3", name: "Europe (Paris)"),
      const AWSRegion(code: "eu-south-2", name: "Europe (Spain)"),
      const AWSRegion(code: "eu-north-1", name: "Europe (Stockholm)"),
      const AWSRegion(code: "eu-central-2", name: "Europe (Zurich)"),
      const AWSRegion(code: "me-south-1", name: "Middle East (Bahrain)"),
      const AWSRegion(code: "me-central-1", name: "Middle East (UAE)"),
      const AWSRegion(code: "sa-east-1", name: "South America (São Paulo)"),
    ];
  }
}

class AWSRegion {
  final String code;
  final String name;
  const AWSRegion({required this.code, required this.name});

  @override
  String toString() {
    return '$code ($name)';
  }
}
