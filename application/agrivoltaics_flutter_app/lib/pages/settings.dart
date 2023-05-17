import 'package:agrivoltaics_flutter_app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

import '../app_constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Setting()
          ],
        ),
      ),
    );
  }
}

class Setting extends StatefulWidget {
  const Setting({
    super.key,
  });

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    Map<String, tz.Location> locations = tz.timeZoneDatabase.locations;
    tz.Location dropdownValue = appState.timezone;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Timezone:'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
              items: [
                for (var location in locations.values)...[
                  DropdownMenuItem(
                    value: location,
                    child: Text(location.toString())
                  )
                ]
              ],
              onChanged: (value) {
                appState.timezone = value!;
                setState(() {
                  dropdownValue = value;
                });
              },
              value: dropdownValue
            )
          ),
          const Text('Sites:'),
          Padding(padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding( // Assuming that there is always going to be at least one site, populate the first site to always show
                padding: EdgeInsets.all(8.0),
                child: SiteCheckbox(
                  site: 1, 
                  initVal: true)
              ),
              for (int site = 2; site <= AppConstants.numSites; site++)...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SiteCheckbox(site: site),),
              ]
          ],
          )
          )
        ],
      ),
    );
  }
}

class SiteCheckbox extends StatefulWidget{
  const SiteCheckbox({
    super.key,
    required this.site,
    this.initVal = false});
   final int site;
   final bool initVal;
  @override
  State<SiteCheckbox> createState() => _SiteCheckboxState();
}

class _SiteCheckboxState extends State<SiteCheckbox>{
  late bool isChecked;
  @override
  void initState(){
    isChecked = widget.initVal;
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    var appState = context.watch<AppState>();
    return 
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text('Site ${widget.site}'),
          Checkbox(
            checkColor: Colors.black,
            value: isChecked,
            onChanged: (bool? value){
              setState((){
                isChecked = value!;
              });
              if (appState.sites.contains(widget.site)){
                if (!isChecked){
                  appState.sites.remove(widget.site);
                }
              }else{
                if (isChecked){
                  appState.sites.add(widget.site);
                }
              }
            }
          ),
        ]
      )
    );
  }
}
