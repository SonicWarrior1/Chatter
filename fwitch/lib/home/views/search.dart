import 'package:flutter/material.dart';
import 'package:fwitch/home/controller/search_controller.dart';
import 'package:fwitch/resources/authMethods.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  // SearchScreen({Key? key}) : super(key: key);
  final AuthMethods _authMethods = AuthMethods();
  SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(actions: const [
          // IconButton(
          //   icon: Icon(Get.isDarkMode ? Icons.sunny : Icons.wb_sunny_outlined),
          //   onPressed: () {
          //     Get.changeThemeMode(
          //         Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
          //   },
          // ),
        ]),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchController.username,
                    decoration:
                        const InputDecoration(label: Text("Search Username")),
                  )),
                  GestureDetector(
                      onTap: () {
                        searchController.getUserByUsername(
                            userName: searchController.username.text);
                      },
                      child: const SizedBox(
                        width: 40,
                        child: Icon(Icons.search),
                      ))
                ],
              ),
            ),
            Expanded(child: Obx(() {
              if (searchController.isUserNameLoading.isTrue) {
                return const Center(child: CircularProgressIndicator());
              } else if (searchController.userNameFilterList.isEmpty &&
                  searchController.username.text.isNotEmpty) {
                return const Center(child: Text("No user name found"));
              } else {
                return ListView.builder(
                  itemCount: searchController.userNameFilterList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(searchController
                              .userNameFilterList[index].username),
                          Text(
                            searchController.userNameFilterList[index].email,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                          onPressed: () {
                            searchController.createChatRoom(
                                searchController
                                    .userNameFilterList[index].username,
                                context);
                          },
                          child: const Text("Message")),
                    );
                  },
                );
              }
            }))
          ],
        ),
      ),
    );
  }
}
