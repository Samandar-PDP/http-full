import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_full/api_service.dart';
import 'package:http_full/second_page.dart';

class FirstPage extends StatelessWidget {
  FirstPage({super.key});

  final ApiService _apiService = ApiServiceImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: FutureBuilder(
        future: _apiService.fetchAllAlbums(),
        builder: (context, snapshot) {
          if(snapshot.data != null && snapshot.data?.isNotEmpty == true) {
            return ListView.separated(
              itemCount: snapshot.data?.length ?? 0,
              separatorBuilder: (context, index) => const Divider(color: Colors.grey,),
              itemBuilder: (context, index) {
                final album = snapshot.data?[index];
                return ListTile(
                  title: Text(album?.name ?? ""),
                  subtitle: Text(album?.body ?? ""),
                  trailing: Text(album?.email ?? ""),
                  onLongPress: () {
                    _apiService.deleteAlbum(album?.id).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Deleted"))
                      );
                    });
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const SecondPage())),
        child: const Icon(Icons.add),
      ),
    );
  }
}