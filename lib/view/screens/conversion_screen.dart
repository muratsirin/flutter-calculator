import 'package:calculator_final/provider/conversion_data.dart';
import 'package:calculator_final/view/components/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversionScreen extends StatelessWidget {
  final int conversionIndex;
  const ConversionScreen({
    Key? key,
    required this.conversionIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Conversion'),
        ),
        drawer: AppDrawer(),
        body: Consumer<ConversionData>(
          builder: (context, conversionData, child) {
            final conversion = conversionData.getConversionList(
                conversionIndex: conversionIndex);
            return LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                return Column(
                  verticalDirection: VerticalDirection.down,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      child: Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight * 0.1,
                        child: Row(
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * 0.5,
                              child: ListTile(
                                title: Text(conversionData.getSelectedItem()),
                                subtitle: Text(
                                  conversion
                                      .where((element) =>
                                          element.unitName ==
                                          conversionData.getSelectedItem())
                                      .first
                                      .unitAbbreviation,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Icon(Icons.unfold_more),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Scaffold(
                                        appBar: AppBar(),
                                        body: ListView.separated(
                                          itemBuilder: (context, index) {
                                            final conversionItem =
                                                conversion[index];
                                            return ListTile(
                                              title:
                                                  Text(conversionItem.unitName),
                                              subtitle: Text(conversionItem
                                                  .unitAbbreviation),
                                              trailing:
                                                  conversionItem.unitName ==
                                                          conversionData
                                                              .getSelectedItem()
                                                      ? Icon(Icons.check)
                                                      : Text(''),
                                              onTap: () {
                                                conversionData.setSelectedItem(
                                                    value: conversionItem
                                                        .unitName);
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return Divider();
                                          },
                                          itemCount: conversion.length,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                autofocus: true,
                                showCursor: true,
                                cursorColor: Colors.grey,
                                readOnly: true,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.01,
                      child: Divider(),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.89,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final conversionItem = conversion[index];
                          return ListTile(
                            title: Text(conversionItem.unitName),
                            subtitle: Text(conversionItem.unitAbbreviation),
                            trailing: Text(
                              conversionData.result(
                                unitFactor: conversionItem.unitFactor,
                                unitName: conversionItem.unitName,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: conversion.length,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
