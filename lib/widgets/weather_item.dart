import 'package:flutter/material.dart';
import 'package:weather_app_v2/constants.dart';

class WeatherItem extends StatelessWidget {
  final int value;
  final String unit;
  final String imageUrl;

  const WeatherItem({
    Key? key,
    required this.value,
    required this.unit,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset(
            imageUrl,
            color: Constants.iconColor,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          value.toString() + unit,
          style: Constants.textStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontColor: Constants.iconColor,
          ),
        ),
      ],
    );
  }
}
