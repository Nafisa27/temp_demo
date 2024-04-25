import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> storeWeatherData(String cityName, double temperature, int pressure, int humidity) async {
    try {
      await _firestore.collection('weatherData').add({
        'cityName': cityName,
        'temperature': temperature,
        'pressure': pressure,
        'humidity': humidity,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to store weather data: $e');
    }
  }

  Future<List<Object?>> getAllWeatherData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('weatherData').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch weather data: $e');
    }
  }
}
