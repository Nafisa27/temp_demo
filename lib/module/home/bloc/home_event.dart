import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchWeatherByCity extends HomeEvent {
  final String city;

  const FetchWeatherByCity(this.city);

  @override
  List<Object?> get props => [city];
}

class FetchWeatherByLocation extends HomeEvent {}