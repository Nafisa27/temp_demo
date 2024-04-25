import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:temp_demo/module/home/bloc/home_bloc.dart';
import 'package:temp_demo/module/home/bloc/home_event.dart';
import 'package:temp_demo/module/home/bloc/home_state.dart';
import 'package:temp_demo/module/weatherData/view/weather_view.dart';
import 'package:temp_demo/service/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final FireStoreService _fireStoreService = FireStoreService();

  @override
  void initState() {
    super.initState();
    _getLocationPermissionAndFetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff2BD2FF),
                Color(0xff2BFF88),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.09,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        20,
                      ),
                    ),
                  ),
                  child: Center(
                    child: TextFormField(
                      onFieldSubmitted: (String cityName) {
                        if (cityName.isNotEmpty) {
                          BlocProvider.of<HomeBloc>(context)
                              .add(FetchWeatherByCity(cityName));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('City name is required'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          ); //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: 'Please enter city name!'));
                        }
                      },
                      controller: _controller,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search city',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 25,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is HomeLoaded) {
                      return _buildWeatherInfo(state);
                    } else if (state is HomeError) {
                      return const Text('Error occurred!');
                    } else {
                      return Container();
                    }
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WeatherScreen()));
                    },
                    child: const Text('Store Data'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(HomeLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.pin_drop,
                color: Colors.red,
                size: 30,
              ),
              Text(
                state.cityName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        textItem('assets/images/thermometer.png', 'Temperature', 'ºC',
            state.temperature!.toInt()),
        const SizedBox(
          height: 20,
        ),
        textItem('assets/images/barometer.png', 'Pressure', 'hPa',
            state.pressure!.toInt()),
        const SizedBox(
          height: 20,
        ),
        textItem('assets/images/humidity.png', 'Humidity', '%',
            state.humidity!.toInt()),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: _storeWeatherData, child: const Text('Store Data'))
      ],
    );
  }

  void _storeWeatherData() {
    // Fetch weather data from the bloc or any other source
    // For example, you can fetch weather data from the current state of the bloc
    final blocState = context.read<HomeBloc>().state;
    if (blocState is HomeLoaded) {
      _fireStoreService.storeWeatherData(
        blocState.cityName,
        blocState.temperature!,
        blocState.pressure!.toInt(),
        blocState.humidity!.toInt(),
      );
    }
  }

  Widget textItem(String image, String title, String ext, int value) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.08,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade900,
            offset: const Offset(1, 2),
            blurRadius: 3,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage(image),
              width: MediaQuery.of(context).size.width * 0.09,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '$title: ${value} $ext',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _getLocationPermissionAndFetchWeather() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
      await Permission.locationWhenInUse.request();
      status = await Permission.locationWhenInUse.status;
    }
    if (status.isGranted) {
      BlocProvider.of<HomeBloc>(context).add(FetchWeatherByLocation());
    } else {
      // Handle if permission is not granted
    }
  }
}
