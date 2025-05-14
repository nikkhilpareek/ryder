import 'package:car_rental_app/utils/colors_constants.dart';
import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatelessWidget {
  const DropdownWidget(
      {super.key,
      required this.items,
      required this.defaultValue,
      required this.selectedValue});

  final List<T> items;
  final T defaultValue;
  final Function(T) selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: DropdownButtonFormField<T>(
        value: defaultValue,
        decoration: const InputDecoration(
          // labelText: 'Choose an option',
          border: InputBorder.none,
          filled: true,
          fillColor: ColorsConstants.inputTextfillColor,
        ),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString()),
          );
        }).toList(),
        onChanged: (T? value) {
          selectedValue(value ?? defaultValue);
        },
      ),
    );
  }
}

/*

List of option need to pass in dropdown widget,
 defaultValue need to pass in dropdown widget
selectedValue need to pass back to parent widget

 */

class ListAllOperations<T> {
  List<T> list = [];
  void add(T a) {
    list.add(a);
  }

  void remove(T a) {
    list.remove(a);
  }
}

class ListOperation {
  List<int> list = [1, 2, 3, 4, 5];
  void add(int a) {
    list.add(a);
  }

  void remove(int a) {
    list.remove(a);
  }
}

void main(List<String> args) {
  ListAllOperations<int> listAllOperations = ListAllOperations();
  listAllOperations.add(10);
  listAllOperations.remove(10);
  ListAllOperations<String> listAllOperationsString = ListAllOperations();
  listAllOperationsString.add("mahesh");
  listAllOperationsString.remove("mahesh");

  ListAllOperations<double> listAllOperationsDouble = ListAllOperations();
  listAllOperationsDouble.add(10.0);
  listAllOperationsDouble.remove(10.0);

  ListAllOperations<bool> listAllOperationsBool = ListAllOperations();
  listAllOperationsBool.add(true);
  listAllOperationsBool.remove(true);

  ListOperation listOperation = ListOperation();
  listOperation.add(10);
  listOperation.remove(10);

  ListStringOperation listStringOperation = ListStringOperation();
  listStringOperation.add("mahesh");
  listStringOperation.remove("mahesh");
}

class ListStringOperation {
  List<String> list = ["mahesh", "vinay", "suresh"];
  void add(String a) {
    list.add(a);
  }

  void remove(String a) {
    list.remove(a);
  }
}
