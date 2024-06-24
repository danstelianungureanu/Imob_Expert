// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadWidget extends StatefulWidget {
  final List<XFile>? imageFileList;
  final Function(List<XFile>?)? onImagesSelected;
  // final bool isMandatory;
  final String? Function()? imageValidator;

  const ImageUploadWidget({
    super.key,
    this.imageFileList,
    this.onImagesSelected,
    // this.isMandatory = false,
    this.imageValidator,
  });

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  bool _isPickingImage = false;

  Future<void> _getImage(ImageSource source) async {
    if (_isPickingImage) return;
    setState(() {
      _isPickingImage = true;
    });

    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          widget.imageFileList!.add(image);
          widget.onImagesSelected!(widget.imageFileList);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Eroare la selectarea imaginii: ${e.toString()}'),
        ),
      );
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Selectare imagine'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        GestureDetector(
                          child: const Text('Galerie'),
                          onTap: () {
                            Navigator.of(context).pop();
                            _getImage(ImageSource.gallery);
                          },
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          child: const Text('Cameră'),
                          onTap: () {
                            Navigator.of(context).pop();
                            _getImage(ImageSource.camera);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: const Text('Adaugă imagini'),
        ),
        if (widget.imageValidator != null) // Adaugă această verificare
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.imageValidator!() ?? '',
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        const SizedBox(height: 10),
        if (widget.imageFileList != null && widget.imageFileList!.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imageFileList!.length,
              itemBuilder: (context, index) {
                final XFile image = widget.imageFileList![index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.file(
                    File(image.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
