// // ignore_for_file: library_private_types_in_public_api

// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import '../../models/ad.dart';
// import '../../view_models/ad_view_model.dart';

// // Ad Carousel to Display the Created Ads
// class AdCarousel extends StatelessWidget {
//   final List<Ad> ads;

//   const AdCarousel({super.key, required this.ads});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: ads.length,
//         itemBuilder: (context, index) {
//           final ad = ads[index];
//           return Card(
//             margin: const EdgeInsets.all(8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildAdImage(ad),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(ad.name,
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       Text(ad.description,
//                           maxLines: 2, overflow: TextOverflow.ellipsis),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildAdImage(Ad ad) {
//     if (ad.imageFile != null) {
//       return Image.file(
//         ad.imageFile!,
//         height: 120,
//         width: 200,
//         fit: BoxFit.cover,
//       );
//     } else {
//       return Image.network(
//         ad.imageUrl
//             as String, // Provide a default empty string if imageUrl is null
//         height: 120,
//         width: 200,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           return Container(
//             height: 120,
//             width: 200,
//             color: Colors.grey[300],
//             child: const Icon(Icons.image, size: 50),
//           );
//         },
//       );
//     }
//   }
// }

// // Create Ad Form to Add New Ads
// class CreateAdView extends StatefulWidget {
//   const CreateAdView({super.key});

//   @override
//   _CreateAdViewState createState() => _CreateAdViewState();
// }

// class _CreateAdViewState extends State<CreateAdView> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _imageUrlController =
//       TextEditingController(); 
//    int _id =0;
//       // Controller for image URL
 
//    File? _image; // To hold the selected image file

//   // Function to pick an image from the gallery or camera
//   Future<void> _getImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);

//     setState(() {
//       if (pickedFile != null) {
//         _image =
//             File(pickedFile.path); // Store the image in the _image variable
//       }
//     });
//   }

//   // Dialog for selecting image source (Gallery or Camera)
//   void _showImageSourceDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Choose Image Source'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 GestureDetector(
//                   child: const Text('Gallery'),
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     _getImage(ImageSource.gallery); // Open gallery
//                   },
//                 ),
//                 const Padding(padding: EdgeInsets.all(8.0)),
//                 GestureDetector(
//                   child: const Text('Camera'),
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     _getImage(ImageSource.camera); // Open camera
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _id.dispose();
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _priceController.dispose();
//     _imageUrlController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Ad'),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.purple[700]!, Colors.blue[500]!],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               children: [
//                 GestureDetector(
//                   onTap: _showImageSourceDialog,
//                   child: Container(
//                     height: 200,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: _image != null
//                         ? Image.file(_image!, fit: BoxFit.cover)
//                         : Icon(Icons.camera_alt,
//                             size: 50, color: Colors.grey[600]),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     labelText: 'Ad Name',
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.7),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter an ad name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _descriptionController,
//                   decoration: InputDecoration(
//                     labelText: 'Description',
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.7),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   maxLines: 3,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a description';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _priceController,
//                   decoration: InputDecoration(
//                     labelText: 'Price',
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.7),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a price';
//                     }
//                     if (double.tryParse(value) == null) {
//                       return 'Please enter a valid number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _imageUrlController,
//                   decoration: InputDecoration(
//                     labelText: 'Image URL',
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.7),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.purple[700],
//                     backgroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       final adViewModel =
//                           Provider.of<AdViewModel>(context, listen: false);
//                       final newAd = Ad(
//                         id: ,
//                         name: _nameController.text,
//                         details: "Some details here", // Example parameter
//                         earnings: 100.0, // Example parameter
//                         stars: 5, // Example parameter
//                         potentialRevenue: 2000.0, // Example parameter
//                         availablePlaces: 10, // Example parameter
//                         creatorName: "Creator Name", // Example parameter
//                         description: _descriptionController.text,
//                         // price: double.parse(_priceController.text),
//                         imageFile: _image,
//                         imageUrl: _imageUrlController.text.isNotEmpty
//                             ? [_imageUrlController.text]
//                             : null,

//                         createdAt: DateTime.now(),
//                       );
//                       adViewModel.addAd(newAd);
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: const Text('Create Ad'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
