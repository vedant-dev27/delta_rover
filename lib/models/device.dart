class Device {
  final String name;
  final String ip;

  Device({
    required this.name,
    required this.ip,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ip': ip,
    };
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      name: json['name'],
      ip: json['ip'],
    );
  }
}
