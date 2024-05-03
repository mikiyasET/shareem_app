import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shareem_app/controller/theme.controller.dart';

class Account extends StatelessWidget {
  Account({super.key});

  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: Image.network(
                        'https://avatars.githubusercontent.com/u/57899051?v=4')
                    .image,
              ),
              const SizedBox(height: 5),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                onPressed: null,
                child: const Text('Edit Photo'),
              ),
              const SizedBox(height: 20),
              ListTile(
                onTap: () =>
                    Get.toNamed('/editAccount', parameters: {'type': 'name'}),
                title: const Text('Name',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('John Doe',
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.5))),
                    const SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios,
                        size: 18,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.5)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                onTap: () => Get.toNamed(
                  '/editAccount',
                  parameters: {'type': 'username'},
                ),
                title: const Text('Username',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('johndoe',
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.5))),
                    const SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios,
                        size: 18,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.5)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                onTap: () => Get.toNamed('/editAccount', parameters: {'type': 'gender'}),
                title: const Text('Gender',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.male,
                        size: 20,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.5)),
                    const SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios,
                        size: 18,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.5)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                  onTap: () => Get.toNamed('/editAccount', parameters: {'type': 'email'}),
                  title: const Text('Email',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('mik***il.com',
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(.5))),
                        const SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios,
                            size: 18,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.5)),
                      ])),
              const SizedBox(height: 10),
              ListTile(
                title: const Text('BirthDate',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '19/01/2000',
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
