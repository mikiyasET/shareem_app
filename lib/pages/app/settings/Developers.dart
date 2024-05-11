import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Developers extends StatelessWidget {
  const Developers({super.key});

  static const devs = [
    {
      'name': 'Mikiyas Lemlemu',
      'role': 'Flutter Developer',
      'image': 'https://avatars.githubusercontent.com/u/25723129?v=4',
    },
    {
      'name': 'Surafel Zeleke',
      'role': 'Flutter Developer',
      'image': 'https://avatars.githubusercontent.com/u/61004133?v=4',
    },
    {
      'name': 'Solomon Nigussie',
      'role': 'Flutter Developer',
      'image': 'https://avatars.githubusercontent.com/u/112338752?v=4',
    },
    {
      'name': 'Yoseph Tadesse',
      'role': 'Flutter Developer',
      'image': 'https://avatars.githubusercontent.com/u/161206221?v=4',
    },
    {
      'name': 'Naol Ebbisa',
      'role': 'Flutter Developer',
      'image': 'https://avatars.githubusercontent.com/u/161126555?v=4',
    }
  ];

  void handleHeart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: const Text(
          'Thanks for the love!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.teal[300],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Developers'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: devs.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadowColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(.2),
              elevation: 4,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    devs[index]['image']!,
                  ),
                ),
                title: Text(devs[index]['name']!,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  devs[index]['role']!,
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(.5),
                  ),
                ),
                // github
                trailing: IconButton(
                  icon: Icon(
                    CupertinoIcons.heart_circle_fill,
                    color: Colors.teal.shade300,
                    fill: 0.1,
                  ),
                  onPressed: () => handleHeart(context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
