import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pakistan_news/View Model/NewsModel.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Results> postdata = [];
  Future<List<Results>> getPostApi() async {
    var url = Uri.parse(
        "https://newsdata.io/api/1/latest?country=pk&apikey=pub_5487244216ef152ff88d703e69e3fcbc35732");
    var response = await http.get(url);
    var responsebody = jsonDecode(response.body);
    List results = responsebody["results"];
    for (var i = 0; i < results.length; i++) {
      postdata.add(Results.fromJson(results[i]));
    }
    return postdata;
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pakistan News"),
      ),
      body: FutureBuilder(
        future: getPostApi(),
        builder: (context,AsyncSnapshot Snapshot) {
          if (Snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: Snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    _launchUrl(Uri.parse(
                        Snapshot.data?[index].sourceUrl.toString() ?? "No ID"));
                  },
                  title:
                      Text(Snapshot.data?[index].title.toString() ?? "No ID"),
                  subtitle:
                      Text(Snapshot.data?[index].link.toString() ?? "No Title"),
                );
              },
            );
          }
        },
      ),
    );
  }
}
