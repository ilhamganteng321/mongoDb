class Supplier {
  final String id;
  final String nama;
  final String merek;
  final int harga;
  final String alamat;
  final String email;
  final String nomorTelepon;

  Supplier({
    required this.id,
    required this.nama,
    required this.merek,
    required this.harga,
    required this.alamat,
    required this.email,
    required this.nomorTelepon,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'merek': merek,
      'harga': harga,
      'alamat': alamat,
      'email': email,
      'nomor_telepon': nomorTelepon,
    };
  }
}