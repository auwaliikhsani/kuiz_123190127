import 'package:flutter/material.dart';
import 'package:kuiz_123190127/data/data_deanses.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final Diseases disease;

  DetailPage({required this.disease});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isWishlist = false;

  void _toggleWishlist() {
    setState(() {
      isWishlist = !isWishlist;
    });
  }

  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.disease.name),
        actions: [
          IconButton(
            onPressed: () {
              _toggleWishlist();
              if (isWishlist) {
                showSnackbar(context, "Added to wishlist");
              } else {
                showSnackbar(context, "Removed from wishlist");
              }
            },
            icon: Icon(
              isWishlist ? Icons.favorite : Icons.favorite_border,
              color: isWishlist ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.disease.imgUrls,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Symptom:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(widget.disease.symptom),
              SizedBox(height: 20),
              Text(
                "Nutshell:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.disease.nutshell
                    .map(
                      (item) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check),
                          SizedBox(width: 5),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _launchInWebViewOrVC(Uri.parse(widget.disease.imgUrls));
        },
        child: const Icon(Icons.open_in_browser),
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
