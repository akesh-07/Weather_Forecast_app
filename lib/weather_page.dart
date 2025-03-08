import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';
import 'additional_info.dart';
import 'hourly_forecast.dart';

class weather_page extends StatefulWidget {
  const weather_page({super.key});

  @override
  State<weather_page> createState() => _weather_pageState();
}

class _weather_pageState extends State<weather_page> {

  Future<Map<String,dynamic>> getcurrentweather() async
  {
    try
    {
  const String city='London';
  final result = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$appid'));
  final data = jsonDecode(result.body);
  if(data['cod']!='200')
    {
      throw "An Unexpected error occured";
    }

  // temp = data['list'][0]['main']['temp'];
  return data;
  }
    catch(e)
    {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    getcurrentweather();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.refresh))],
      ),
      body: FutureBuilder(
        future: getcurrentweather(),
        builder: (context,snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError) {
            print(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final currentweatherdata = data['list'][0];
          final currenttemp = currentweatherdata['main']['temp'];
          final currentsky = currentweatherdata['weather'][0]['main'];
          final pressure = currentweatherdata['main']['pressure'];
          final windspeed = currentweatherdata['wind']['speed'];
          final humidity = currentweatherdata['main']['humidity'];
          return Padding(
              padding: const EdgeInsets.all(16.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(
          width: double.infinity,
          child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          ),
          child:  Padding(
          padding:  const EdgeInsets.all(16.0),
          child: Column(
          children: [
          Text(
          '$currenttemp K',
          style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 32
        ,
                          ),
                        ),
                         const SizedBox(height: 10),
                          Icon(
                          currentsky=='Clouds' || currentsky=='Rain'?Icons.cloud:Icons.sunny,
                          size: 64,
                        ),
                         const SizedBox(height: 10),
                          Text(
                          currentsky,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Weather Forecast',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
             // const  SingleChildScrollView(
             //   scrollDirection: Axis.horizontal,
             //    child: Row(
             //      children: [
             //        HourlyForecast(icon: Icons.sunny,time: '13:00',temperature: '303'),
             //        HourlyForecast(icon: Icons.cloud, time: '14:00',temperature: '305'),
             //        HourlyForecast(icon: Icons.air,time: '15:00',temperature: '301'),
             //        HourlyForecast(icon: Icons.sunny,time: '16:00',temperature: '308'),
             //      ],
             //    ),
             //  ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final hourlyforecast = data['list'][index + 1];
                  final hourlysky = hourlyforecast['weather'][0]['main'];
                  final hourlytemp = hourlyforecast['main']['temp'].toString();
                  final time = DateTime.parse(hourlyforecast['dt_txt']); // Fixed key

                  return HourlyForecast(
                    time: DateFormat.Hm().format(time),
                    temperature: hourlytemp,
                    icon: hourlysky == 'Clouds' || hourlysky == 'Rain' ? Icons.cloud : Icons.sunny,
                  );
                },
              ),
            ),
            const SizedBox(height: 10,), // Ensure this is correctly placed

            const Text('Additional Information',style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 8,),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [


                    additional_info(icon: Icons.water_drop,label: 'Humidity',value: humidity.toString(),),
                    additional_info(icon: Icons.air,label: 'Wind Speed',value: windspeed.toString(),),
                    additional_info(icon: Icons.beach_access,label: 'Pressure',value: pressure.toString(),),

                ],
              )

            ],
          ),
        );
        },
      ),
    );
  }
}



