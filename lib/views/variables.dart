/*
import 'package:graduation___part1/views/httpCodeG.dart';
import 'dart:convert';
/*
List<Map<String, dynamic>> ads = [];
Future<void> getAds() async {
  HttpRequest.post({
    "endPoint": "/user/home",
  }).then((res) {
    if (res.statusCode == 200) {
      List<Map<String, dynamic>> responseData = json.decode(res.body);
      ads = responseData;
    } else {
      throw Exception('Failed to load ads');
    }
  });
}
*/
// List<Ad> getAds(List<Map<String, dynamic>> fromApi) {
//   List<Ad> put = [];
//   for (var element in fromApi) {
//     put.add(Ad.fromJson(element));
//   }
//   return put;
// }
List<Map<String, dynamic>> ads = [
  {
    "name": "Ali Cafe",
    "details":
        "Ali Cafe is a fast coffee brand, providing instant coffee solutions for people on the go. Known for its rich and strong flavor, it's perfect for a quick pick-me-up at any time of the day. Whether you're at home, at work, or traveling, Ali Cafe offers a convenient way to enjoy a delicious cup of coffee in seconds. Simply add hot water, stir, and you're ready to go!",
    "stars": 4,
    "potentialRevenue": 750,
    "images": [
      "https://i5.walmartimages.com/seo/Alicafe-Classic-3-In-1-Instant-Coffee-Bag-Ground-30-X-20G-600G_58d646a8-7b89-4524-a667-847665159273.a0da51f0eec72ac0cfd2f387788129da.jpeg",
      "https://m.media-amazon.com/images/I/51IozBoN4kL._SS1000_.jpg",
      "https://images.deliveryhero.io/image/product-information-management/663b03d05c2a36ba98195fe8.png?size=520"
    ],
    "availablePlaces": 12,
    "creatorName": "COMPANY NAME"
  },
  {
    "name": "Cafe 5438dc",
    "details":
        "Cafe 5438dc is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
    "stars": 1,
    "potentialRevenue": 569,
    "images": [
      "https://picsum.photos/200/300?random=40",
      "https://picsum.photos/200/300?random=177",
      "https://picsum.photos/200/300?random=230"
    ],
    "availablePlaces": 15,
    "creatorName": "COMPANY NAME"
  },
  {
    "name": "Cafe C24e9e",
    "details":
        "Cafe C24e9e is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
    "stars": 4,
    "potentialRevenue": 968,
    "images": [
      "https://picsum.photos/200/300?random=85",
      "https://picsum.photos/200/300?random=1310",
      "https://picsum.photos/200/300?random=2948"
    ],
    "availablePlaces": 20,
    "creatorName": "COMPANY NAME"
  },
  {
    "name": "Cafe 3f0de5",
    "details":
        "Cafe 3f0de5 is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
    "stars": 2,
    "potentialRevenue": 514,
    "images": [
      "https://picsum.photos/200/300?random=645",
      "https://picsum.photos/200/300?random=1450",
      "https://picsum.photos/200/300?random=2238"
    ],
    "availablePlaces": 14,
    "creatorName": "COMPANY NAME"
  },
  {
    "name": "Cafe 873a62",
    "details":
        "Cafe 873a62 is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
    "stars": 3,
    "potentialRevenue": 601,
    "images": [
      "https://picsum.photos/200/300?random=197",
      "https://picsum.photos/200/300?random=1072",
      "https://picsum.photos/200/300?random=2970"
    ],
    "availablePlaces": 12,
    "creatorName": "COMPANY NAME"
  },
  {
    "name": "Cafe 53fefd",
    "details":
        "Cafe 53fefd is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
    "stars": 1,
    "potentialRevenue": 716,
    "images": [
      "https://picsum.photos/200/300?random=30",
      "https://picsum.photos/200/300?random=1592",
      "https://picsum.photos/200/300?random=2758"
    ],
    "availablePlaces": 9,
    "creatorName": "COMPANY NAME"
  },
  {
    "name": "Cafe A5de3a",
    "details":
        "Cafe A5de3a is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
    "stars": 3,
    "potentialRevenue": 776,
    "images": [
      "https://picsum.photos/200/300?random=302",
      "https://picsum.photos/200/300?random=1275",
      "https://picsum.photos/200/300?random=2995"
    ],
    "availablePlaces": 9,
    "creatorName": "COMPANY NAME"
  },
  {
    "name": "Cafe 2b6ec0",
    "details":
        "Cafe 2b6ec0 is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
    "stars": 1,
    "potentialRevenue": 299,
    "images": [
      "https://picsum.photos/200/300?random=967",
      "https://picsum.photos/200/300?random=1032",
      "https://picsum.photos/200/300?random=2163"
    ],
    "availablePlaces": 6,
    "creatorName": "COMPANY NAME"
  },
  {
    "name": "Cafe B7ae1c",
    "details":
        "Cafe B7ae1c is known for its quick and flavorful coffee offerings. Customers love the convenience and rich taste, making it perfect for busy mornings or quick coffee breaks.",
    "stars": 1,
    "potentialRevenue": 675,
    "images": [
      "https://picsum.photos/200/300?random=994",
      "https://picsum.photos/200/300?random=1851",
      "https://picsum.photos/200/300?random=2379"
    ],
    "availablePlaces": 10,
    "creatorName": "COMPANY NAME"
  }
];

*/
/*
import 'dart:convert';

import 'package:graduation___part1/views/httpCodeG.dart';

List<Map<String, dynamic>> ads = [];

Future<void> getAds() async {
  final res = await HttpRequest.post({
    "endPoint": "/user/home",
  });

  //if (res.statusCode == 200) {
  final Map<String, dynamic> data = json.decode(res.body);
  if (data['messages']['content'] != null) {
    ads = List<Map<String, dynamic>>.from(data['messages']['content']);
  } else {
    throw Exception('No content found');
  }
  // } else {
  //error
  //throw Exception('Failed to load ads');
  //}
}
*/
/*
import 'dart:convert';

import 'package:graduation___part1/views/httpCodeG.dart';

List<Map<String, dynamic>> ads = [];

Future<void> getAds() async {
  // ignore: unused_local_variable
  final res = await HttpRequest.post({
    "endPoint": "/user/home",
  }).then((res) {
    print("error home_${res.toString()}");
    if (res.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(res.toString());
      print("zeft_home${data['messages']['content']}");
      if (data['messages']['content'] != null) {
        ads = List<Map<String, dynamic>>.from(data['messages']['content']);
        print(List<Map<String, dynamic>>.from(data['messages']['content']));
      } else {
        throw Exception('No content found');
      }
    } else {
      throw Exception('Failed to load ads');
    }
  });
}
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation___part1/views/httpCodeG.dart';

// Global navigator key for the entire app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// List to store ads data
List<Map<String, dynamic>> ads = [];

// Cubit for managing the state of ads fetching
class AdsCubit extends Cubit<List<Map<String, dynamic>>> {
  AdsCubit() : super([]);

  Future<void> getAds() async {
    try {
      final res = await HttpRequest.post({
        "endPoint": "/user/home",
      });

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.toString());
        if (data['messages']['content'] != null) {
          ads = List<Map<String, dynamic>>.from(data['messages']['content']);
          emit(ads); // Emit the new state with fetched ads
        } else {
          throw Exception('No content found');
        }
      } else {
        throw Exception('Failed to load ads');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
