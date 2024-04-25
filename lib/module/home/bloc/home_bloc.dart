import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_demo/module/home/bloc/home_event.dart';
import 'package:temp_demo/module/home/bloc/home_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:temp_demo/module/home/model/weather_model.dart';
import 'package:temp_demo/utils/constants.dart';

import 'package:geolocator/geolocator.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc() : super(HomeInitial()) {
    on<FetchWeatherByCity>(fetchWeatherByCity);
    on<FetchWeatherByLocation>(fetchWeatherByLocation);
  }

  Future<void> fetchWeatherByCity(FetchWeatherByCity event,Emitter<HomeState> emit,) async {
    emit(HomeLoading());
    try {
      var weatherData = await _fetchWeatherData(city: event.city);
      emit(HomeLoaded(
        temperature: weatherData.temperature,
        pressure: weatherData.pressure,
        humidity: weatherData.humidity,
        cloudCover: weatherData.cloudCover,
        cityName: weatherData.cityName,
      ));
    } catch (_) {
      emit(HomeError());
    }
  }

  Future<void> fetchWeatherByLocation(FetchWeatherByLocation event,Emitter<HomeState> emit,) async {
    emit(HomeLoading());
    try {
      var position = await _getCurrentPosition();
      var weatherData = await _fetchWeatherData(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      emit(HomeLoaded(
        temperature: weatherData.temperature,
        pressure: weatherData.pressure,
        humidity: weatherData.humidity,
        cloudCover: weatherData.cloudCover,
        cityName: weatherData.cityName,
      ));
    } catch (_) {
      emit(HomeError());
    }
  }

  Future<WeatherData> _fetchWeatherData({String? city, double? latitude, double? longitude}) async {
    var client = http.Client();
    var uri = city != null ? '${domain}q=$city&appid=${apiKey}' : '${domain}lat=$latitude&lon=$longitude&appid=${apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = json.decode(data);
      return WeatherData.fromMap(decodedData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Position> _getCurrentPosition() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    if (position.latitude != 0.0) {
      return position;
    } else {
      throw Exception('Failed to get current position');
    }
  }
}