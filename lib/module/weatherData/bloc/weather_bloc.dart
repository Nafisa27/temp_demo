import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_demo/module/weatherData/bloc/weather_event.dart';
import 'package:temp_demo/module/weatherData/bloc/weather_state.dart';
import 'package:temp_demo/service/firebase_service.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  FireStoreService _fireStoreService = FireStoreService();
  WeatherBloc() : super(WeatherInitial()) {
    on<FetchWeatherData>((event, emit) {
      emit(WeatherLoading());
      try {
        var weatherData = _fetchWeatherData();
        emit(WeatherLoaded(weatherData));
      } catch (_) {
        emit(WeatherError('No Data Found'));
      }
    });
  }

  _fetchWeatherData() {
    _fireStoreService.getAllWeatherData();
  }
}