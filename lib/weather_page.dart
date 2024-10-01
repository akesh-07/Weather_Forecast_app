import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
          final currenttemp = data['list'][0]['main']['temp'];
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
                         const Icon(
                          Icons.cloud,
                          size: 64,
                        ),
                         const SizedBox(height: 10),
                         const Text(
                          'Rain',
                          style: TextStyle(
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
             const  SingleChildScrollView(
               scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HourlyForecast(icon: Icons.sunny,time: '13:00',temperature: '303'),
                    HourlyForecast(icon: Icons.cloud, time: '14:00',temperature: '305'),
                    HourlyForecast(icon: Icons.air,time: '15:00',temperature: '301'),
                    HourlyForecast(icon: Icons.sunny,time: '16:00',temperature: '308'),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Text('Additional Information',style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 8,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [


                    additional_info(icon: Icons.water_drop,label: 'Humidity',value: '91',),
                    additional_info(icon: Icons.air,label: 'Wind Speed',value: '7.5',),
                    additional_info(icon: Icons.beach_access,label: 'Pressure',value: '1000',),

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



