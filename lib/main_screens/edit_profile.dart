import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digital_preps/basic_files/app_buttons.dart';
import 'package:digital_preps/basic_files/app_colors.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickFromGallery() async {
    return await _pickImage(ImageSource.gallery);
  }

  Future<File?> pickFromCamera() async {
    return await _pickImage(ImageSource.camera);
  }

  Future<File?> _pickImage(ImageSource source) async {
    try {
      PermissionStatus status;
      if (source == ImageSource.camera) {
        status = await Permission.camera.request();
      } else {
        if (Platform.isIOS) {
          status = await Permission.photos.request();
        } else {
          status = await Permission.storage.request();
        }
      }

      if (!status.isGranted) {
        debugPrint("Permission denied");
        return null;
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
    return null;
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  final ImagePickerService _imageService = ImagePickerService();
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  final img = await _imageService.pickFromCamera();
                  if (img != null) {
                    setState(() => _image = img);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final img = await _imageService.pickFromGallery();
                  if (img != null) {
                    setState(() => _image = img);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Column(
              children: [
                SizedBox(height: h * 0.025),

                /// HEADER
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(w * 0.03),
                        decoration: BoxDecoration(
                          color: const Color(0xFF36BCFF).withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_back_ios_new, size: w * 0.045),
                      ),
                    ),
                    SizedBox(width: w * 0.05),
                    Text(
                      'Edit Profile',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkblue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.06),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : const AssetImage('assets/images/h1.png')
                                as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImagePickerOptions,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF36BCFF).withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.03),
                _buildSimpleTextField("Enter new Name"),
                SizedBox(height: h * 0.01),
                _buildSimpleTextField("Enter new Gmail"),
                SizedBox(height: h * 0.01),
                _buildSimpleTextField("Details"),
                SizedBox(height: h * 0.08),
                SizedBox(
                  width: double.infinity,
                  child: MainButton(
                    text: 'Save Changes',
                    onTap: () => Get.back(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleTextField(String hint) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF979696)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: const Color(0xFF979696),
            fontSize: 13,
          ),
          filled: true,
          fillColor: const Color(0xFFD9D9D9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
