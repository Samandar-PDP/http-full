import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_full/album.dart';
import 'package:http_full/api_service.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final ApiService _apiService = ApiServiceImpl();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Comment'),
        actions: [
          _isLoading ? const Padding(padding: EdgeInsets.all(12), child: CupertinoActivityIndicator()) :
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _handleSubmit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    setState(() {
      _isLoading = true;
    });
    final name = _nameController.text;
    final email = _emailController.text;
    final body = _bodyController.text;

    _apiService.createAlbum(Album(postId: 0, id: 0, name: name, email: email, body: body))
    .then((response) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        if(response) {
          Navigator.of(context).pop();
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Error occurred"))
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
