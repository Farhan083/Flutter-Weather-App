import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:weather_app_v2/constants.dart';
import 'package:weather_app_v2/pages/detail_page.dart';
import 'package:weather_app_v2/responsive.dart';
import 'package:weather_app_v2/service/api_service.dart';
import 'package:weather_app_v2/service/geolocation.dart';
import 'package:weather_app_v2/weather_group.dart';
import 'package:weather_app_v2/widgets/weather_item.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // scaffold key
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerState =
      GlobalKey<ScaffoldMessengerState>();

  ApiService apiService = ApiService();
  final TextEditingController _cityController = TextEditingController();
  final Constants _constants = Constants();

  bool isLoading = true;
  String location = 'San Francisco';
  String currentWeatherStatus = '';
  var currentGradient = Constants.tealGradient;
  Color currentCardColor = Constants.cardColorT;
  String? weatherGroup = '';
  String lat = '';
  String long = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GlobalVariable.navigatorState.currentState?.hideCurrentSnackBar();

    getGeolocation(context);
  }

  getGeolocation(BuildContext context) async {
    try {
      Position position = await GeoLocation().determinePosition();
      // Placemark place = await GeoLocation().GetAddressFromLatLong(position);
      setState(() {
        // location = place.administrativeArea.toString();
        lat = position.latitude.toString();
        long = position.longitude.toString();
      });
      await getWeatherStatus(context, location, latitude: lat, longitude: long);
    } catch (e) {
      await getWeatherStatus(context, location);
      setState(() {
        isLoading = false;
      });
      // print('Error while getting geolocation: $e');
      GlobalVariable.navigatorState.currentState!.showSnackBar(
        SnackBar(
          content: Text('Error while getting geolocation: $e'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      // Handle the error here, show an error message to the user, or retry.
    }
  }

  getWeatherStatus(BuildContext context, String searchText,
      {String latitude = '', String longitude = ''}) async {
    try {
      // to get location directly from the langtitue and latitude, using geolocation
      if (latitude != '' && longitude != '') {
        searchText = '$latitude,$longitude';
      }
      await apiService.fetchWeatherData(searchText).then((value) {
        if (apiService.location != null &&
            apiService.currentWeatherStatus != null &&
            apiService.hourlyWeatherForecast != null) {
          setState(() {
            location = apiService.location;
            currentWeatherStatus = apiService.currentWeatherStatus;
            weatherGroup =
                WeatherStatusGroup().weatherGroups[currentWeatherStatus];
            if (weatherGroup == 'sunny') {
              currentGradient = Constants.orangeGradient;
              currentCardColor = Constants.cardColorS;
            } else if (weatherGroup == 'rain' || weatherGroup == 'snow') {
              currentGradient = Constants.blueGradient;
              currentCardColor = Constants.cardColorB;
            } else {
              currentGradient = Constants.tealGradient;
              currentCardColor = Constants.cardColorT;
            }
            isLoading = false;
          });
        } else {
          throw Exception(
              'Failed to fetch weather data: Response format is incorrect.');
        }
      });
      // print(apiService.hourlyWeatherForecast);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // print('Error while getting weather status: $e');

      //snackbar
      GlobalVariable.navigatorState.currentState!.showSnackBar(
        SnackBar(
          content: Text('Error while getting weather status: $e'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      // Handle the error here, show an error message to the user, or retry.
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: isLoading
          ? Center(
              child: LottieBuilder.asset(
                'animations/lottie_loading.json',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            )
          : Container(
              // height: size.height,
              // width: size.width,
              decoration: BoxDecoration(
                gradient: currentGradient,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      // height: size.height * .7,
                      // color: Colors.amber,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/pin.png',
                                    height: 20,
                                    width: 20,
                                    color: Constants.blackColor,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    apiService.location,
                                    style: Constants.textStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _cityController.clear();
                                        showMaterialModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return SingleChildScrollView(
                                              controller:
                                                  ModalScrollController.of(
                                                      context),
                                              child: Container(
                                                // height: size.height * .2,
                                                height: 200,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 10,
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width: 70,
                                                      child: Divider(
                                                        thickness: 3.5,
                                                        color: _constants
                                                            .greyColor,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextField(
                                                      // onChanged: (value) {
                                                      //   setState(() {
                                                      //     isLoading = true;
                                                      //   });
                                                      //   getWeatherStatus(
                                                      //       context, value);
                                                      // },
                                                      controller:
                                                          _cityController,
                                                      autofocus: true,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Search city e.g. London',
                                                        prefixIcon: const Icon(
                                                          Icons.search,
                                                          color: Constants
                                                              .detailScreenColor,
                                                        ),
                                                        suffixIcon:
                                                            GestureDetector(
                                                          onTap: () {
                                                            _cityController
                                                                .clear();
                                                          },
                                                          child: const Icon(
                                                            Icons.close,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Constants
                                                                .detailScreenColor,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        getWeatherStatus(
                                                            context,
                                                            _cityController
                                                                .text);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: Constants
                                                            .detailScreenColor,
                                                      ),
                                                      child: Text(
                                                        'Search',
                                                        style:
                                                            Constants.textStyle(
                                                          fontColor:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down))
                                ],
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return DetailForecast(
                                        location: apiService.location,
                                        weatherIconLocation:
                                            "assets/${apiService.weatherIcon}",
                                        dailyWeatherForecast:
                                            apiService.dailyWeatherForecast,
                                        currentWeatherStatus:
                                            apiService.currentWeatherStatus,
                                      );
                                    }));
                                  },
                                  child: const Icon(
                                      Icons.calendar_month_outlined)),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          isLoading
                              ? const SingleChildScrollView()
                              : Image.asset(
                                  "assets/${apiService.weatherIcon}",
                                  height: 200,
                                  width: 200,
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            apiService.currentWeatherStatus,
                            style: Constants.textStyle(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                apiService.temperature.toString(),
                                style: Constants.textStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 10),
                                child: Text(
                                  'o',
                                  style: Constants.textStyle(fontSize: 30),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              WeatherItem(
                                value: apiService.windSpeed.toInt(),
                                unit: 'km/h',
                                imageUrl: 'assets/icons/windy-line.png',
                              ),
                              WeatherItem(
                                value: apiService.humidity.toInt(),
                                unit: '%',
                                imageUrl: 'assets/icons/drop-line.png',
                              ),
                              WeatherItem(
                                value: apiService.cloud.toInt(),
                                unit: '%',
                                imageUrl: 'assets/icons/cloud.png',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: ScreenSize().getPhoneModel(size.height),
                      // color: Colors.amber,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            "Hourly Forecast",
                            style: Constants.textStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 80),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: const Divider(
                                thickness: 3,
                              )),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount:
                                  apiService.hourlyWeatherForecast.length,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                String currentTime = DateFormat('HH:mm::ss')
                                    .format(DateTime.now());
                                String currentHour =
                                    currentTime.substring(0, 2);
                                String forecastTime = apiService
                                    .hourlyWeatherForecast[index]['time']
                                    .substring(11, 16);
                                String forecastHour = apiService
                                    .hourlyWeatherForecast[index]['time']
                                    .substring(11, 13);

                                //converting 24 hour format to 12 hour
                                DateTime time =
                                    DateFormat("HH:mm").parse(forecastTime);
                                forecastTime =
                                    DateFormat("h:mm a").format(time);
                                String forecastTemperature = apiService
                                    .hourlyWeatherForecast[index]['temp_c']
                                    .round()
                                    .toString();
                                String weatherName =
                                    apiService.hourlyWeatherForecast[index]
                                        ['condition']['text'];

                                // to get the path of the icon
                                // eg day/112.png or night/112.png
                                String forecastWeatherIcon = apiService
                                    .hourlyWeatherForecast[index]['condition']
                                        ['icon']
                                    .split('/')
                                    .reversed
                                    .take(2)
                                    .toList()
                                    .reversed
                                    .join('/');

                                return Container(
                                  width: 120,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    // border: Border.all(
                                    //     color: const Color.fromARGB(
                                    //         255, 123, 245, 243)),
                                    color: currentCardColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.2),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: const Offset(2, 4),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        forecastTime,
                                        style:
                                            Constants.textStyle(fontSize: 12),
                                      ),
                                      Stack(children: [
                                        Image.asset(
                                          'assets/$forecastWeatherIcon',
                                          color: Constants.blackColor
                                              .withOpacity(.1),
                                          scale: .9,
                                        ),
                                        Image.asset(
                                          'assets/$forecastWeatherIcon',
                                          color: Constants.whiteColor,
                                        ),
                                      ]),

                                      //temperature

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 1.0, right: 3),
                                            child: Text(
                                              forecastTemperature,
                                              style: Constants.textStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            'o',
                                            style: Constants.textStyle(),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
