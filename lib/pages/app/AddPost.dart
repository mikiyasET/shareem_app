import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/temp.controller.dart';
import 'package:shareem_app/widgets/EMInput.dart';

class AddPost extends StatelessWidget {
  AddPost({super.key});

  final tempController = Get.find<TempController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: tempController.postTitle.value,
              onChanged: (value) => tempController.postTitleText.value = value,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              cursorColor: Theme.of(context).colorScheme.onSurface,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                hintText: 'Title',
                hintStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.5),
                ),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15,bottom: 10, top: 10),
              child: Row(
                children: [
                  MaterialButton(
                    elevation: 0,
                    highlightElevation: 0,
                    highlightColor: Colors.blueGrey[90],
                    onPressed: () {},
                    color:  Theme.of(context).colorScheme.onSurface.withOpacity(.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text('Add tags',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        )),
                  ),
                  SizedBox(width: 10),
                  MaterialButton(
                    elevation: 0,
                    highlightElevation: 0,
                    highlightColor: Colors.blueGrey[90],
                    onPressed: () {},
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text('Add feelings',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        )),
                  ),
                ],
              ),
            ),
            TextField(
              controller: tempController.postBody.value,
              onChanged: (value) => tempController.postBodyText.value = value,
              maxLines: null,
              minLines: 25,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              cursorColor: Theme.of(context).colorScheme.onSurface,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                hintText: 'body text',
                hintStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.5),
                ),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            )
          ],
        ),
      ),
    );
  }
}
