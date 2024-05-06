class Employee {
  final String nama;
  final String jabatan;
  final String nomorTelepon;
  final String email;
  final String imageUrl;

  Employee({
    required this.nama,
    required this.jabatan,
    required this.nomorTelepon,
    required this.email,
    required this.imageUrl,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      nama: json['nama'],
      jabatan: json['jabatan'],
      nomorTelepon: json['nomor_telepon'],
      email: json['email'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'jabatan': jabatan,
      'nomor_telepon': nomorTelepon,
      'email': email,
      'image_url': imageUrl,
    };
  }
}
