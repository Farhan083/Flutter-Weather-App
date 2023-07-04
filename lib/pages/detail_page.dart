import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_v2/constants.dart';
import 'package:weather_app_v2/message_map.dart';
import 'package:weather_app_v2/service/api_service.dart';

class DetailForecast extends StatefulWidget {
  final String location;
  final String weatherIconLocation;
  final List dailyWeatherForecast;
  final String currentWeatherStatus;
  const DetailForecast(
      {super.key,
      required this.location,
      required this.weatherIconLocation,
      required this.dailyWeatherForecast,
      required this.currentWeatherStatus});

  @override
  State<DetailForecast> createState() => _DetailForecastState();
}

class _DetailForecastState extends State<DetailForecast> {
  ApiService apiService = ApiService();
  String currentMessage = '';
  DateTime? forecastDate;
  String dayOfWeek = '';
  String maxTemp = '';
  String minTemp = '';
  String dailyForecastWeatherIcon = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentMessage =
        MessageMap.weatherDescriptions[widget.currentWeatherStatus] ??
            "Greetings today! Hope you enjoy your weather";
    // print(currentMessage);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.detailScreenColor,
      appBar: AppBar(
        backgroundColor: Constants.detailScreenColor,
        toolbarHeight: 70,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          widget.location,
          style: Constants.textStyle(
              fontColor: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // height: size.height * .3,
            margin: const EdgeInsets.symmetric(vertical: 10),
            // color: Colors.amber,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    // height: size.height * .2,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 40)
                            .copyWith(left: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Constants.messageColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "15 minutes ago",
                          style: Constants.textStyle(fontColor: Colors.grey),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          currentMessage,
                          style: Constants.textStyle(
                            fontColor: const Color.fromARGB(186, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -25,
                    right: 20,
                    child: Image.asset(
                      widget.weatherIconLocation,
                      height: 70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20, bottom: 15),
            child: Text(
              "Next Week",
              style: Constants.textStyle(
                  fontColor: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.dailyWeatherForecast.length - 1,
            itemBuilder: (context, index) {
              // variables
              index = index + 1;
              forecastDate =
                  DateTime.parse(widget.dailyWeatherForecast[index]['date']);
              dayOfWeek = DateFormat('EEEE').format(forecastDate!);
              maxTemp = widget.dailyWeatherForecast[index]['day']['maxtemp_c']
                  .round()
                  .toString();
              minTemp = widget.dailyWeatherForecast[index]['day']['mintemp_c']
                  .round()
                  .toString();

              dailyForecastWeatherIcon = widget.dailyWeatherForecast[index]
                      ['day']['condition']['icon']
                  .split('/')
                  .reversed
                  .take(2)
                  .toList()
                  .reversed
                  .join('/');

              // listview ui
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      child: Text(
                        dayOfWeek,
                        style: Constants.textStyle(
                          fontColor: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 2),
                          child: Text(
                            maxTemp,
                            style: Constants.textStyle(
                              fontColor: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          'o',
                          style: Constants.textStyle(
                            fontColor: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 2),
                          child: Text(
                            minTemp,
                            style: Constants.textStyle(
                              fontColor: Colors.grey,
                            ),
                          ),
                        ),
                        Text(
                          'o',
                          style: Constants.textStyle(
                            fontColor: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      "assets/$dailyForecastWeatherIcon",
                      height: 36,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      )),
    );
  }
}
