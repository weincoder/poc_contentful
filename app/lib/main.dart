import 'package:flutter/material.dart';
import 'package:contentful/client.dart';
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Repository repository = Repository();
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: repository.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final contentFullData = snapshot.data;
                final enterpriseMenu =
                    contentFullData!.pricingContent.enterprise.menu.items;
                final plusMenu = contentFullData.pricingContent.plus.menu.items;
                return Scaffold(
                  appBar: AppBar(
                    title: Text(contentFullData.title),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(' ${contentFullData.description}'),
                          Text('Menu Empresa: '),
                          SizedBox(
                            height: 200,
                            child: Center(
                              child: ListView.builder(
                                itemCount: enterpriseMenu.length,
                                itemBuilder: (item, count) => Text(
                                  enterpriseMenu[count].label,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            ),
                          ),
                          Text('Menu Plus: '),
                          SizedBox(
                            height: 200,
                            child: Center(
                              child: ListView.builder(
                                itemCount: plusMenu.length,
                                itemBuilder: (item, count) =>
                                    Text(plusMenu[count].label),
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
                // return Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text('Titulo: ${contentFullData!.title}'),

                //   ],
                // );
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return Text('algo salio mal');
              }
            },
          ),
        ),
      ),
    );
  }
}

class Repository {
  Client contentful = Client(
    BearerTokenHTTPClient(
      'token',
    ),
    spaceId: 'space id',
  );

  Future<UserData> getProducts() async {
    dynamic data = {};
    await contentful.getEntries<dynamic>(
      {'content_type': 'content'},
      (dataContentFul) {
        data = jsonEncode(dataContentFul['fields']);
      },
    );
    final userData = userDataFromJson(data);
    return userData;
  }
}

// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  final String title;
  final PricingContent pricingContent;
  final String description;

  UserData({
    required this.title,
    required this.pricingContent,
    required this.description,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        title: json["title"],
        pricingContent: PricingContent.fromJson(json["pricingContent"]),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "pricingContent": pricingContent.toJson(),
        "description": description,
      };
}

class PricingContent {
  final Enterprise plus;
  final Enterprise enterprise;

  PricingContent({
    required this.plus,
    required this.enterprise,
  });

  factory PricingContent.fromJson(Map<String, dynamic> json) => PricingContent(
        plus: Enterprise.fromJson(json["plus"]),
        enterprise: Enterprise.fromJson(json["Enterprise "]),
      );

  Map<String, dynamic> toJson() => {
        "plus": plus.toJson(),
        "Enterprise ": enterprise.toJson(),
      };
}

class Enterprise {
  final Menu menu;

  Enterprise({
    required this.menu,
  });

  factory Enterprise.fromJson(Map<String, dynamic> json) => Enterprise(
        menu: Menu.fromJson(json["menu"]),
      );

  Map<String, dynamic> toJson() => {
        "menu": menu.toJson(),
      };
}

class Menu {
  final List<Item> items;

  Menu({
    required this.items,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  final String icon;
  final String label;
  final String action;

  Item({
    required this.icon,
    required this.label,
    required this.action,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        icon: json["icon"],
        label: json["label"],
        action: json["action"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "label": label,
        "action": action,
      };
}
