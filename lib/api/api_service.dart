import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class ApiService {
  static const String url = 'http://192.168.1.105:8081';

  Future<List<LatLng>> fetchCoordinates(int idKurir) async {
    final response = await http.get(Uri.parse('$url/dataPengantaran/$idKurir'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final filteredData =
          (data as List).where((i) => i['kurir_id'] == idKurir).toList();

      return filteredData
          .map((i) => LatLng(i['latitude'], i['longitude']))
          .toList();
    } else {
      throw Exception('Coordinat tidak dapat diambil');
    }
  }

  Future<List<dynamic>> fetchDataPengantaran(int idKurir) async {
    final response = await http.get(Uri.parse('$url/dataPengantaran/$idKurir'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data;
    } else {
      throw Exception('List Paket Kosong');
    }
  }

  Future<void> sendDeliveryStatus(Map<String, dynamic> data) async {
    final ambilurl =
        Uri.parse('$url/riwayat/1'); // Ganti dengan endpoint yang sesuai
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(data);

    try {
      final response = await http.post(ambilurl, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Status pengiriman berhasil terkirim');
      } else {
        throw Exception('Gagal mengirim status pengiriman');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
