import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';



class PhilosophyScreen extends StatefulWidget {
  const PhilosophyScreen({Key? key}) : super(key: key);

  @override
  PhilosophyScreenState createState() => PhilosophyScreenState();
}

class PhilosophyScreenState extends State<PhilosophyScreen> {
  PhilosophyScreenState();

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Не вдається завантажити $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2f3c54),
      appBar: AppBar(
        backgroundColor: const Color(0xff414F69),
        leading: const BackButton(
            color: Colors.white
        ),
        title: const Text("Новини"),
        centerTitle: true,
      ),
      floatingActionButton: null,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Philosophy').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: (snapshot.data!).docs.map((document) {
                if (kDebugMode) {
                  print(document.get('title').toString());
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color(0xff2f3c54),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        _launchURL(document.get('title'));
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(document.get('title'),
                                style: const TextStyle(
                                  color: Colors.white54,fontSize: 18.0,
                                )),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: CachedNetworkImage(
                                imageUrl: document.get('image'),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
