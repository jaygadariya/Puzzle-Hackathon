import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LevelSelection extends StatelessWidget {
  const LevelSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "Choose Level",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      commonLevel(
                        context: context,
                        text: 'Easy (3x3)',
                        count: 3,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      commonLevel(
                        context: context,
                        text: 'Medium (4x4)',
                        count: 4,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      commonLevel(
                        context: context,
                        text: 'Hard (5x5)',
                        count: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commonLevel({
    required BuildContext context,
    required String text,
    required int count,
  }) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: !kIsWeb ? size.width * .1 : size.width * .3),
      child: ListTile(
        dense: false,
        onTap: () {
          var parameters = <String, String>{"count": "$count"};
          Get.toNamed('/game', parameters: parameters);
        },
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
