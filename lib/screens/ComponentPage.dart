import 'dart:ffi';

import 'package:flutter/material.dart';

class ComponentPage extends StatefulWidget {
  static const routeName = '/component_page';
  String componentName;

  ComponentPage(this.componentName);

  @override
  _ComponentPageState createState() => _ComponentPageState();
}

class _ComponentPageState extends State<ComponentPage> {
  final _kioskSerialFocusNode = FocusNode();
  final _componentSerialFocusNode = FocusNode();
  final kioskSerialController = TextEditingController();
  final compoentSerialController = TextEditingController();

  final _form = GlobalKey<FormState>();

  var components = List<Component>();

  _addNewComponentRows(String kioskSerial, String componentSerial) {
    components.add(
      Component(componentSerial: componentSerial, kioskSerial: kioskSerial),
    );
  }

  Future<void> _saveSerialsToDatabase(List<Component> components) async {
    components.forEach((component) {
      //await SEND SERIAL TO DB
      print("kiosk: " + component.kioskSerial);
      print("component: " + component.componentSerial);
    });

    setState(() {
      components.clear();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.componentName = "IQ BOX";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(widget.componentName),
          ),
          body: ConstrainedBox(
            constraints:
                BoxConstraints.expand(width: MediaQuery.of(context).size.width),
            child: Form(
              key: _form,
              child: Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: "Scanned Kiosk Serial"),
                              controller: kioskSerialController,
                              focusNode: _kioskSerialFocusNode,
                              autofocus: true,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(_componentSerialFocusNode);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Scanned Component Serial"),
                                controller: compoentSerialController,
                                focusNode: _componentSerialFocusNode,
                                onEditingComplete: () {
                                  _addNewComponentRows(
                                      kioskSerialController.text,
                                      kioskSerialController.text);
                                  FocusScope.of(context)
                                      .requestFocus(_kioskSerialFocusNode);
                                  setState(() {
                                    kioskSerialController.text = "";
                                    compoentSerialController.text = "";
                                  });
                                }),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    OutlineButton.icon(
                        onPressed: () {
                          _saveSerialsToDatabase(components);
                        },
                        icon: Icon(Icons.save),
                        label: Text("Save Serials")),
                    Expanded(
                      child: ListView(children: [
                        SingleChildScrollView(
                          child: DataTable(
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'KIOSK SERIAL',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  widget.componentName.toUpperCase() +
                                      ' SERIAL',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: components
                                .map(
                                  (e) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(e.kioskSerial)),
                                      DataCell(Text(e.componentSerial)),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class Component {
  String kioskSerial;
  String componentSerial;

  Component({this.componentSerial, this.kioskSerial});
}
