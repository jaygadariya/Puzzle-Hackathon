import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puzzle_hack/level_Selection.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RxList list = [].obs, mainList = [].obs;
  RxInt matrixLength = 0.obs, steps = 0.obs;

  @override
  void initState() {
    super.initState();
    if (Get.parameters['count'] == null || Get.parameters['count'] == '') {
      Get.offNamedUntil("/", (route) => route.isFirst);
    } else {
      this.matrixLength.value = int.tryParse(Get.parameters['count'].toString()) ?? 0;
      for (int i = 1; i < (matrixLength.value * matrixLength.value); i++) {
        list.add(i);
        mainList.add(i);
      }
      list.add('');
      mainList.add('');
      list.shuffle();
    }
  }

  Size? size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final double itemHeight = (size!.height) / matrixLength.value;
    final double itemWidth = size!.width / matrixLength.value;
    return WillPopScope(
      onWillPop: () {
        Get.back();
        return Future(() => true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: kIsWeb
              ? null
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 35.0,
                          ),
                          Text(
                            " Back",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  dialog(context: context, isReload: true);
                },
                child: Icon(
                  Icons.refresh,
                  color: Colors.black,
                  size: 35.0,
                ),
              ),
            ),
          ],
        ),
        body: kIsWeb ? web() : phone(),
      ),
    );
  }

  Widget phone() {
    return Column(
      children: commonWidget(),
    );
  }

  Widget web() {
    return Row(
      children: commonWidget(),
    );
  }

  List<Widget> commonWidget() {
    return [
      const SizedBox(
        height: 40.0,
      ),
      Expanded(
        flex: kIsWeb ? 3 : 1,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (kIsWeb) ...{
                FlutterLogo(
                  size: 100.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "A ${matrixLength.value} x ${matrixLength.value} Puzzle",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
              },
              Obx(
                () => Text(
                  "Steps : $steps",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 40.0,
      ),
      Expanded(
        flex: kIsWeb ? 7 : 9,
        child: Obx(() => Container(
              width: size!.width,
              height: size!.height,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: kIsWeb ? ((size!.width * .7) / (matrixLength.value)) : 8),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: list.length ~/ matrixLength.value,
                  childAspectRatio: 1,
                  mainAxisExtent: 100,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return list[index] == ''
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: FlutterLogo(),
                        )
                      : GestureDetector(
                          onTap: () {
                            List moveAbleList = [];
                            int i = list.indexOf('');
                            try {
                              moveAbleList.add(list[i - 1]);
                            } catch (e) {}
                            try {
                              moveAbleList.add(list[i + matrixLength.value]);
                            } catch (e) {}
                            try {
                              moveAbleList.add(list[i + 1]);
                            } catch (e) {}
                            try {
                              moveAbleList.add(list[i - matrixLength.value]);
                            } catch (e) {}
                            if (moveAbleList.contains(list[index])) {
                              list.insert(i + 1, list[index]);
                              list.removeAt(i);
                              list.insert(index + 1, '');
                              list.removeAt(index);
                              steps++;
                            }

                            if (mainList.toString() == list.toString()) {
                              dialog(context: context, isReload: false);
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Center(
                              child: Text(
                                list[index].toString(),
                                style: TextStyle(
                                  fontSize: !kIsWeb ? 30 : size!.height * .03,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                },
              ),
            )),
      ),
      const SizedBox(
        height: 40.0,
      ),
    ];
  }

  dialog({required context, required bool isReload}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(isReload == true ? 'Reload' : 'Game over'),
            content: Text(isReload == true ? 'are you sure to reload game?' : 'congratulations you won'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  if (isReload == true) {
                    steps.value = 0;
                    list.shuffle();
                    Get.back();
                  } else {
                    Get.offAll(LevelSelection());
                  }
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        });
  }
}
