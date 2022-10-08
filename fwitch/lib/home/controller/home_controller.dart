import 'package:fwitch/resources/firestore_methods.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool darkTheme = Get.isDarkMode.obs;
  final firebaseMethods = FirestoreMethods.firestoreMethods;
 
}
