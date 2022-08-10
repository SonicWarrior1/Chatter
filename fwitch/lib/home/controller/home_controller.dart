import 'package:fwitch/shared_prefs.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString username = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUsername() async {
      var x = await SharedPrefs.getUsername();
      username.value = x!;
    }
  }

  RxInt pageindex = 0.obs;
  setPage(int page) {
    pageindex.value = page;
  }
}
