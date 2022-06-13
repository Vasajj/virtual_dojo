import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  ArticleScreenState createState() => ArticleScreenState();
}

class ArticleScreenState extends State<ArticleScreen> {
  ArticleScreenState();




  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      if (kDebugMode) {
        print ('all is fine');
      }
    } else {
      throw 'Не вдається завантажити $url';
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2f3c54),
      appBar: AppBar(
        title: const Text(
          'Віртуальне доджо',
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff414f69),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '2');
          },
          child: const Icon(
            Icons.album_rounded, color: Colors.white, // add custom icons also
          ),
        ),
      ),
      floatingActionButton: null,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Videos').snapshots(),
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
                  print(document.get('url').toString());
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.0,
                    decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.circular(15.0),
                      color: Color(0xff2f3c54),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        _launchURL(document.get('url'));
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Text(document.get('title'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueGrey[50],
                                  fontSize: 18.0,
                                )),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
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

