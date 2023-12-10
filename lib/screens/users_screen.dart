import 'package:cp_store/consts/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/users_model.dart';
import '../services/api_handler.dart';
import '../widgets/users_widget.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: FutureBuilder<List<UsersModel>>(
        future: APIHandler.getAllUsers(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: lightIconsColor,
              ),
            );
          } else if (snapshot.hasError) {
            Center(
              child: Text("An error occured ${snapshot.error}"),
            );
          } else if (snapshot.data == null) {
            const Center(
              child: Text("No products has been added yet"),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              // itemCount: 3,
              itemBuilder: (ctx, index) {
                return ChangeNotifierProvider.value(
                  value: snapshot.data![index],
                  child: const UsersWidget(),
                );
              });
        }),
      ),
    );
  }
}
