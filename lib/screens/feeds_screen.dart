// ignore_for_file: avoid_print

import 'package:cp_store/consts/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/products_model.dart';
import '../services/api_handler.dart';
import '../widgets/feeds_widget.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ProductsModel> productsList = [];
  int limit = 10;
  bool _isLoading = false;
  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // getProducts();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isLoading = true;
        });
        print("_isLoading $_isLoading");
        limit += 10;
        await getProducts();
        setState(() {
          _isLoading = false;
        });
        print("limit $limit");
      }
    });
    super.didChangeDependencies();
  }

  Future<void> getProducts() async {
    productsList = await APIHandler.getAllProducts(
      limit: limit.toString(),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 4,
        title: const Text('All Products'),
      ),
      body: productsList.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                color: lightIconsColor,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: productsList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 0.0,
                                    mainAxisSpacing: 0.0,
                                    childAspectRatio: 0.7),
                            itemBuilder: (ctx, index) {
                              return ChangeNotifierProvider.value(
                                  value: productsList[index],
                                  child: const FeedsWidget());
                            }),
                        if (_isLoading)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: lightIconsColor,
                            )),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
