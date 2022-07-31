import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_perfect_demo_from_parth_rupareliya/API.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Page2Controller>(
      init: Page2Controller(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text("Page 2")),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.posts.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.posts.length,
                      itemBuilder: (context, index) {
                        Post p = controller.posts[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          color: Colors.white,
                          child: ListTile(
                            title: Text(p.title),
                            subtitle: Text(p.body),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        );
                      },
                    )
                  : const Text("No Posts available!"),
        );
      },
    );
  }
}

class Page2Controller extends GetxController {
  bool isLoading = false;
  List<Post> posts = [];

  @override
  void onInit() async {
    isLoading = true;
    update();
    try {
      var data = await API.dio2.get("posts");
      if (data.data != null && data.data is List && data.data.isNotEmpty) {
        for (var p in data.data as List) {
          posts.add(Post.fromMap(p));
        }
      }
    } catch (e) {}
    isLoading = false;
    update();
    super.onInit();
  }
}
