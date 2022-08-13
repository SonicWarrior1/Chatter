
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString username = "".obs;


  RxInt pageindex = 0.obs;
  setPage(int page) {
    pageindex.value = page;
  }
}
