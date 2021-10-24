import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Shimmer.fromColors(
              child: TextFormField(),
              baseColor: Theme.of(context).primaryColorLight,
              highlightColor: Theme.of(context).primaryColorDark,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Shimmer.fromColors(
              child: Column(
                children: [
                  ListTile(
                    minLeadingWidth: 16,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    leading: Icon(Icons.edit),
                    title: Align(
                      alignment: Alignment(-1.1, 0),
                      child: Text(
                        AppLocalizations.of(context).description,
                        style: TextStyle(fontSize: 21),
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              baseColor: Theme.of(context).primaryColorLight,
              highlightColor: Theme.of(context).primaryColorDark,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Shimmer.fromColors(
              child: Column(
                children: [
                  ListTile(
                    minLeadingWidth: 16,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    leading: Icon(Icons.list_alt_outlined),
                    title: Align(
                      alignment: Alignment(-1.1, 0),
                      child: Text(
                        AppLocalizations.of(context).state,
                        style: TextStyle(fontSize: 21),
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              baseColor: Theme.of(context).primaryColorLight,
              highlightColor: Theme.of(context).primaryColorDark,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Shimmer.fromColors(
              child: Column(
                children: [
                  ListTile(
                    minLeadingWidth: 16,
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    leading: Icon(Icons.animation_outlined),
                    title: Align(
                      alignment: Alignment(-1.1, 0),
                      child: Text(
                        AppLocalizations.of(context).attributes,
                        style: TextStyle(fontSize: 21),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 100,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.flag_outlined),
                                Text(''),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 100,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_add),
                                Text(''),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Card(
                    child: Container(
                      height: 175,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              baseColor: Theme.of(context).primaryColorLight,
              highlightColor: Theme.of(context).primaryColorDark,
            ),
          ),
        ],
      ),
    );
  }
}
