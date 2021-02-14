import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
  List<Component> selecteComponents;

//SHOULD NOT BE INCLUDED
  String barcode = 'Unknown';

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

  onSelectedRow(bool selected, Component component) async {
    setState(() {
      if (selected) {
        selecteComponents.add(component);
      } else {
        selecteComponents.remove(component);
      }
    });
  }

  deleteSelected() async {
    setState(() {
      if (selecteComponents.isNotEmpty) {
        List<Component> temp = [];
        temp.addAll(selecteComponents);
        for (Component comp in temp) {
          components.remove(comp);
          selecteComponents.remove(comp);
        }
      }
    });
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        components.sort((a, b) => a.kioskSerial.compareTo(b.kioskSerial));
      } else {
        components.sort((a, b) => b.kioskSerial.compareTo(a.kioskSerial));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    selecteComponents = [];
    widget.componentName = "Computer";
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
          actions: [
            OutlineButton.icon(
                onPressed: () {
                  _saveSerialsToDatabase(components);
                  setState(() {
                    kioskSerialController.text = "";
                    compoentSerialController.text = "";
                  });
                },
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                label: Text(
                  "Save Serials",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
        body: ConstrainedBox(
          constraints:
              BoxConstraints.expand(width: MediaQuery.of(context).size.width),
          child: Form(
            key: _form,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Kiosk Serial",
                                    labelStyle: TextStyle(fontSize: 12),
                                    suffixIcon: IconButton(
                                        onPressed: () async {
                                          try {
                                            final barcode =
                                                await FlutterBarcodeScanner
                                                    .scanBarcode(
                                              '#ff6666',
                                              'Cancel',
                                              true,
                                              ScanMode.QR,
                                            );

                                            if (!mounted) return;

                                            setState(() {
                                              kioskSerialController.text =
                                                  barcode;
                                            });
                                          } on PlatformException {
                                            barcode =
                                                'Failed to get platform version.';
                                          }

                                          _form.currentState.validate();
                                          FocusScope.of(context).requestFocus(
                                              _componentSerialFocusNode);
                                        },
                                        icon: Icon(Icons.qr_code)),
                                    hintText: "Kiosk Serial"),
                                controller: kioskSerialController,
                                focusNode: _kioskSerialFocusNode,
                                autofocus: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Cant be empty";
                                  }
                                  return null;
                                },
                                onEditingComplete: () {
                                  _form.currentState.validate();
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
                                      suffixIcon: IconButton(
                                          onPressed: () async {
                                            try {
                                              final barcode =
                                                  await FlutterBarcodeScanner
                                                      .scanBarcode(
                                                '#ff6666',
                                                'Cancel',
                                                true,
                                                ScanMode.QR,
                                              );

                                              if (!mounted) return;

                                              setState(() {
                                                compoentSerialController.text =
                                                    barcode;
                                              });
                                            } on PlatformException {
                                              barcode =
                                                  'Failed to get platform version.';
                                            }

                                            final isValid =
                                                _form.currentState.validate();

                                            if (!isValid) {
                                              return;
                                            }
                                            _addNewComponentRows(
                                                kioskSerialController.text,
                                                compoentSerialController.text);
                                            FocusScope.of(context).requestFocus(
                                                _kioskSerialFocusNode);
                                            setState(() {
                                              kioskSerialController.text = "";
                                              compoentSerialController.text =
                                                  "";
                                            });
                                          },
                                          icon: Icon(Icons.qr_code)),
                                      border: OutlineInputBorder(),
                                      labelText: "Component Serial",
                                      labelStyle: TextStyle(fontSize: 12),
                                      hintText: "Component Serial"),
                                  controller: compoentSerialController,
                                  focusNode: _componentSerialFocusNode,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Cant be empty";
                                    }
                                    return null;
                                  },
                                  onEditingComplete: () {
                                    final isValid =
                                        _form.currentState.validate();

                                    if (!isValid) {
                                      return;
                                    }
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
                      Expanded(
                        child: ListView(children: [
                          SingleChildScrollView(
                            child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith(
                                (states) {
                                  return Colors.red;
                                },
                              ),
                              columns: <DataColumn>[
                                DataColumn(
                                  numeric: false,
                                  label: Text(
                                    'KIOSK SERIAL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    widget.componentName.toUpperCase() +
                                        ' SERIAL',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              rows: components
                                  .map(
                                    (e) => DataRow(
                                      key: ObjectKey(e),
                                      selected: selecteComponents.contains(e),
                                      onSelectChanged: (value) {
                                        print(e.kioskSerial);
                                        onSelectedRow(value, e);
                                      },
                                      cells: <DataCell>[
                                        DataCell(
                                          TextFormField(
                                            initialValue: e.kioskSerial,
                                            readOnly: true,
                                          ),
                                        ),
                                        DataCell(
                                          TextFormField(
                                            initialValue: e.componentSerial,
                                            readOnly: true,
                                          ),
                                        ),
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
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          children: [
            OutlineButton.icon(
              label: Text("Delete row"),
              icon: Icon(Icons.delete),
              onPressed: () async {
                await deleteSelected();
              },
            )
          ],
        ),
      ),
    );
  }
}

class Component {
  String kioskSerial;
  String componentSerial;

  Component({this.componentSerial, this.kioskSerial});
}
