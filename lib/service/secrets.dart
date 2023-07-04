import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiKey = dotenv.env['API_KEY'] ?? "No Api Found";
