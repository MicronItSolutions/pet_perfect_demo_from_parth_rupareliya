import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pet_perfect_demo_from_parth_rupareliya/API.dart';
import 'package:pet_perfect_demo_from_parth_rupareliya/Util.dart';
import 'package:pet_perfect_demo_from_parth_rupareliya/page2.dart';
import 'package:video_player/video_player.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Page1Controller>(
      init: Page1Controller(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Page 1"),
          ),
          floatingActionButton: controller.isLoading
              ? null
              : FloatingActionButton(
                  child: const Icon(Icons.navigate_next),
                  onPressed: () async {
                    await controller.box.put("url", controller.url);
                    Get.to(() => const Page2());
                  },
                ),
          body: Center(
            child: SizedBox(
              width: Get.width * .9,
              height: Get.height * .5,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: controller.isLoading
                      ? const CircularProgressIndicator()
                      : controller.mediaType == MediaType.none
                          ? const Text(
                              "Something went wrong! please restart app!")
                          : controller.mediaType == MediaType.image ||
                                  controller.mediaType == MediaType.gif
                              ? CachedNetworkImage(
                                  imageUrl: controller.url,
                                  fit: BoxFit.cover,
                                  errorWidget: (c, s, e) {
                                    Util.addToast(
                                        "${controller.url} endpoint not reachable!");
                                    return const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    );
                                  },
                                  progressIndicatorBuilder: (c, url, p) =>
                                      CircularProgressIndicator(
                                          value: p.progress),
                                )
                              : controller.mediaType == MediaType.video &&
                                      controller.flickManager != null
                                  ? FlickVideoPlayer(
                                      flickManager: controller.flickManager!)
                                  : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum MediaType { none, image, gif, video }

class Page1Controller extends GetxController {
  MediaType mediaType = MediaType.none;
  String url = "";
  bool isLoading = false;
  FlickManager? flickManager;
  var box = Hive.box<String>("common");

  @override
  void onInit() async {
    isLoading = true;
    update();
    if (!box.containsKey("url")) {
      try {
        var data = await API.dio.get("woof.json");
        if (data.data != null &&
            data.data["url"] is String &&
            data.data["url"].isNotEmpty) {
          url = data.data["url"]?.toString() ?? "";
        }
      } catch (e) {}
    } else {
      url = box.get("url") ?? "";
    }

    if (url.isNotEmpty) {
      url = url.toLowerCase();
      print(url);
      Util.addToast(url);
      if (url.endsWith(".jpg") ||
          url.endsWith(".png") ||
          url.endsWith(".jpeg")) {
        mediaType = MediaType.image;
      } else if (url.endsWith(".gif")) {
        mediaType = MediaType.gif;
      } else if (url.endsWith(".mp4") || url.endsWith(".webm")) {
        mediaType = MediaType.video;
      }
      if (mediaType == MediaType.video) {
        flickManager = FlickManager(
          videoPlayerController: VideoPlayerController.network(url),
        );
      }
    }
    isLoading = false;
    update();
    super.onInit();
  }

  @override
  void onClose() {
    flickManager?.dispose();
    super.onClose();
  }
}
