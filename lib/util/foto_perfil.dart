import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePicture extends StatefulWidget {
  final double size;
  final Function(File) onPictureSelected;

  const ProfilePicture({super.key, this.size = 100.0, required this.onPictureSelected});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  late File _image;

  _getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        widget.onPictureSelected(_image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _getImage,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            // ignore: unnecessary_null_comparison
            image: FileImage(_image), // Substitua 'assets/placeholder.png' pelo caminho do seu placeholder
          ),
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        child: _image == null
            ? Icon(
                Icons.add_a_photo,
                size: widget.size * 0.6,
                color: Colors.grey,
              )
            : null,
      ),
    );
  }
}
