import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_demo/module/weatherData/bloc/weather_bloc.dart';
import 'package:temp_demo/module/weatherData/bloc/weather_state.dart';


class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WeatherLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WeatherLoaded) {
            return ListView.builder(
              itemCount: state.weatherData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.weatherData[index]),
                );
              },
            );
          } else if (state is WeatherError) {
            return Center(
              child: Text('Error: ${state.errorMessage}'),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
