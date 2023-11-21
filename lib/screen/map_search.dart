import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<String> _addressResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _searchAddress(_searchController.text);
      }
    });
  }

  Future<List<String>> _searchAddress(String address) async {
    const String clientId = '38k3gvz9d4'; // 발급받은 Client ID
    const String clientSecret =
        'vI48LFzg12g7qgNoy8pyS3b5MU5Ka5pyPvGkb0eW'; // 발급받은 Client Secret

    final response = await http.get(
      Uri.parse(
          'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$address'),
      headers: {
        "X-NCP-APIGW-API-KEY-ID": clientId,
        "X-NCP-APIGW-API-KEY": clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<String> results = [];
      for (var addr in jsonResponse['addresses']) {
        String fullAddress = addr['roadAddress'] ?? addr['jibunAddress'] ?? '';
        results.add(fullAddress);
      }

      setState(() {
        _addressResults = results;
      });

      return results;
    } else {
      throw Exception('Failed to load coordinates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('주소 검색')),
      body: Column(
        children: <Widget>[
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(labelText: '주소 검색'),
                ),
              ),
            ),
            IconButton(
              padding: const EdgeInsets.only(bottom: 0),
              alignment: Alignment.bottomCenter,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const FaIcon(
                FontAwesomeIcons.magnifyingGlass,
              ),
            ),
          ]),
          Expanded(
            child: FutureBuilder(
              future: _searchAddress(_searchController.text),
              builder: ((context, snapshot) {
                return ListView.builder(
                  itemCount: _addressResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_addressResults[index]),
                      onTap: () {
                        setState(() {
                          _searchController.text = _addressResults[index];
                        });
                      },
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
