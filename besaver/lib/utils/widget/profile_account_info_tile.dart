import 'package:flutter/material.dart';
import '/utils/constants.dart';

class GeneralAccountInfoTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imageUrl;

  const GeneralAccountInfoTile(
      {key,
      required this.title,
      required this.subTitle,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultSpacing / 4, vertical: defaultSpacing / 2),
        child: Image.asset(imageUrl),
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .subtitle2
            ?.copyWith(color: const Color.fromARGB(255, 87, 124, 89)),
      ),
      subtitle: Text(
        subTitle,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            ?.copyWith(color: const Color.fromARGB(255, 87, 124, 89)),
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right_rounded,
        color: Color.fromARGB(255, 87, 124, 89),
      ),
    );
  }
}

class ProfileAccountInfoTile extends StatelessWidget {
  final String iconUrl;
  final String heading;
  const ProfileAccountInfoTile(
      {key, required this.iconUrl, required this.heading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: defaultSpacing + 4),
            child: Image.asset(iconUrl),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultSpacing),
            child: Text(heading,
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: const Color.fromARGB(255, 87, 124, 89),
                    fontSize: 20)),
          ),
          const Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: defaultSpacing),
                    child: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Color.fromARGB(255, 87, 124, 89),
                    ),
                  )))
        ],
      ),
    );
  }
}
