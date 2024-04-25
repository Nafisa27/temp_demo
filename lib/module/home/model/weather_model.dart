class WeatherData {
  final double? temperature;
  final int? pressure;
  final int? humidity;
  final int? cloudCover;
  final String cityName;

  WeatherData({
    required this.temperature,
    required this.pressure,
    required this.humidity,
    required this.cloudCover,
    required this.cityName,
  });

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    return WeatherData(
      temperature: (map['main']['temp'] - 273.15) as double?,
      pressure: (map['main']['pressure']) as int?,
      humidity: (map['main']['humidity']) as int?,
      cloudCover: (map['clouds']['all']) as int?,
      cityName: (map['name']) as String,
    );
  }
}