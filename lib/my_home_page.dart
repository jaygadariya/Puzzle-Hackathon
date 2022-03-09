import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  final int count;

  MyHomePage({Key? key, required this.count}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RxList list = [].obs, mainList = [].obs;
  RxInt matrixLength = 0.obs, steps = 0.obs;

  @override
  void initState() {
    super.initState();
    this.matrixLength.value = widget.count;
    for (int i = 1; i < (matrixLength.value * matrixLength.value); i++) {
      list.add(i);
      mainList.add(i);
    }
    list.add('');
    mainList.add('');
    list.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
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
            GestureDetector(
              onTap: () {
                list.shuffle();
              },
              child: Icon(
                Icons.refresh,
                color: Colors.black,
                size: 35.0,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40.0,
          ),
          Obx(
            () => Text(
              "Steps : $steps",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
          ),
          const SizedBox(
            height: 40.0,
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: list.length ~/ matrixLength.value,
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
                                showDialog(
                                    context: context,
                                    barrierDismissible: false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Game over'),
                                        content: const Text('congratulations you won'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Theme.of(context).primaryColor,
                              ),
                              height: 70,
                              width: 100,
                              child: Center(
                                child: Text(
                                  list[index].toString(),
                                  style: const TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
