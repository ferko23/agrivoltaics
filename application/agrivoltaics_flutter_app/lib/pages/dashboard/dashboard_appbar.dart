import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_constants.dart';
import 'dashboard_state.dart';

/*

Dashboard App Bar
- App Bar on Dashboard page which extends over the top of the screen.
Controls navigation. Contains buttons ("actions")

*/
class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            var dashboardStateProvider = Provider.of<DashboardState>(context, listen: false);
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return ChangeNotifierProvider.value(
                  value: dashboardStateProvider,
                  child: FilterModal()
                );
              }
            );
          },
          icon: const Icon(Icons.filter_alt_outlined),
        ),
        IconButton(
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          icon: const Icon(Icons.analytics_outlined)
        ),
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/*

Filter Modal
- Modal which displays various filters for data

*/
class FilterModal extends StatefulWidget {
  const FilterModal({
    super.key,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  @override
  Widget build(BuildContext context) {
    var dashboardState = context.watch<DashboardState>();

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      children: [
                        for (int i = 1; i <= 3; i++)...[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: dashboardState.zoneSelection[i],
                                    onChanged: (value) {
                                      setState(() {
                                        dashboardState.zoneSelection[i] = value!;
                                      });
                                    }
                                  ),
                                  Text('Zone ${i}'),
                                ],
                              )
                            ),
                          )
                        ]
                      ],
                    ),
                  )
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    // decoration: const BoxDecoration(
                    //   border: Border(
                    //     right: BorderSide(
                    //       // TODO: update to match parent theme
                    //       color: Colors.black,
                    //       width: 3
                    //     )
                    //   )
                    // ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: dashboardState.fieldSelection[SensorType.humidity],
                                    onChanged: (value) {
                                      setState(() {
                                        dashboardState.fieldSelection[SensorType.humidity] = value!;
                                      });
                                    }
                                  ),
                                  Text(SensorType.humidity.displayName!),
                                ],
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: dashboardState.fieldSelection[SensorType.temperature],
                                    onChanged: (value) {
                                      setState(() {
                                        dashboardState.fieldSelection[SensorType.temperature] = value!;
                                      });
                                    }
                                  ),
                                  Text(SensorType.temperature.displayName!)
                                ],
                              )
                            ),
                          )
                        ]
                      )
                    ),
                  )
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed:() {
              dashboardState.finalizeState();
            },
            child: const Text('Apply')
          ),
        ),
      ],
    );
  }
}