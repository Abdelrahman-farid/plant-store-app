import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project1/utilies/constants.dart';
import 'package:project1/views/widgets/profile_widget.dart';
import 'package:project1/views/pages/addresses_page.dart';
import 'package:project1/views/pages/payment_methods_page.dart';
import 'package:project1/views/pages/my_orders_page.dart';
import 'package:project1/views/pages/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'John Doe';
  String _userEmail = 'johndoe@gmail.com';
  String? _profileImagePath;
  bool _notificationsEnabled = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'John Doe';
      _userEmail = prefs.getString('user_email') ?? 'johndoe@gmail.com';
      _profileImagePath = prefs.getString('profile_image_path');
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _userName);
    await prefs.setString('user_email', _userEmail);
    if (_profileImagePath != null) {
      await prefs.setString('profile_image_path', _profileImagePath!);
    }
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                  // Profile Photo with Edit Button
                  Stack(
                    children: [
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Constants.primaryColor.withOpacity(.5),
                            width: 5.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.transparent,
                          backgroundImage: _profileImagePath != null
                              ? FileImage(File(_profileImagePath!))
                              : const ExactAssetImage('assets/images/profile.jpg')
                                  as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImagePickerOptions,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Constants.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Name with Edit Button
                  GestureDetector(
                    onTap: _editName,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _userName,
                          style: TextStyle(
                            color: Constants.blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          height: 24,
                          child: Image.asset("assets/images/verified.png"),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.edit,
                          size: 18,
                          color: Constants.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _userEmail,
                    style: TextStyle(
                      color: Constants.blackColor.withOpacity(.3),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Profile Options
                  ProfileOption(
                    icon: Icons.person,
                    title: 'My Profile',
                    onTap: _editProfile,
                  ),
                  ProfileOption(
                    icon: Icons.shopping_bag,
                    title: 'My Orders',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyOrdersPage()),
                      );
                    },
                  ),
                  ProfileOption(
                    icon: Icons.location_on,
                    title: 'Addresses',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddressesPage()),
                      );
                    },
                  ),
                  ProfileOption(
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PaymentMethodsPage()),
                      );
                    },
                  ),
                  ProfileOption(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                  ProfileOption(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                        _saveUserData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              value
                                  ? 'Notifications enabled'
                                  : 'Notifications disabled',
                            ),
                          ),
                        );
                      },
                      activeColor: Constants.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera, color: Constants.primaryColor),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Constants.primaryColor),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      
      if (image != null) {
        setState(() {
          _profileImagePath = image.path;
        });
        await _saveUserData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile photo updated!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _editName() {
    final controller = TextEditingController(text: _userName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter your name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _userName = controller.text;
                  });
                  _saveUserData();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name updated!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.primaryColor,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: _userName);
        final emailController = TextEditingController(text: _userEmail);
        
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty) {
                  setState(() {
                    _userName = nameController.text;
                    _userEmail = emailController.text;
                  });
                  _saveUserData();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.primaryColor,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
