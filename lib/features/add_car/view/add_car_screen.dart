import 'dart:io';

import 'package:car_rental_app/features/add_car/model/addcar_request_model.dart';
import 'package:car_rental_app/features/add_car/view_model/add_car_view_model.dart';
import 'package:car_rental_app/features/cars/view_model/cars_view_model.dart';
import 'package:car_rental_app/services/navigation_services.dart';
import 'package:car_rental_app/utils/loader_utils.dart';
import 'package:car_rental_app/widget/button_widget.dart';
import 'package:car_rental_app/widget/dropdown_widget.dart';
import 'package:car_rental_app/widget/input_text_field_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({Key? key}) : super(key: key);

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _brandTextController = TextEditingController();
  final TextEditingController _yearTextController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _priceTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    final AddCarViewModel viewModel = Provider.of<AddCarViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Add Car"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              InputTextFieldWidget(
                  hintText: "Enter Name of the Car",
                  textEditingController: _nameTextController),
              const SizedBox(
                height: 10,
              ),
              InputTextFieldWidget(
                  hintText: "Enter Brand of the Car",
                  textEditingController: _brandTextController),
              const SizedBox(
                height: 10,
              ),
              DropdownWidget<int>(
                items: viewModel.yearsList,
                defaultValue:
                    viewModel.selectedYear ?? viewModel.yearsList.first,
                selectedValue: (year) {
                  viewModel.setSelectedYear(year);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownWidget<String>(
                items: viewModel.transmissionList,
                defaultValue: viewModel.selectedTransmission ??
                    viewModel.transmissionList.first,
                selectedValue: (transmission) {
                  viewModel.setSelectedTransmission(transmission);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownWidget<String>(
                items: viewModel.fuelTypeList,
                defaultValue:
                    viewModel.selectedFuelType ?? viewModel.fuelTypeList.first,
                selectedValue: (fuelType) {
                  viewModel.setSelectedFuelType(fuelType);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              InputTextFieldWidget(
                  hintText: "Enter Price of the Car",
                  textEditingController: _priceTextController),
              const SizedBox(
                height: 10,
              ),
              InputTextFieldWidget(
                  hintText: "Enter Description of the Car",
                  textEditingController: _descriptionTextController),
              const SizedBox(
                height: 10,
              ),
              InputTextFieldWidget(
                  maxLines: 5,
                  hintText: "Enter Addres of the car",
                  textEditingController: _addressController),
              const SizedBox(
                height: 10,
              ),
              imageSelectionWidget(viewModel),
              const SizedBox(
                height: 10,
              ),
              ButtonWidget(
                  buttonWidth: 300,
                  buttonTitle: "Add Car",
                  onPressed: () {
                    addCarToServer(viewModel);
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget imageSelectionWidget(AddCarViewModel viewModel) {
    return Column(
      children: [
        SizedBox(
          width: 150,
          child: ButtonWidget(
              buttonTitle: "Take Picture",
              onPressed: () {
                //Show the Bottom sheet with two options 1. Camera 2. Gallery
                showBottomSheet(viewModel);
              }),
        ),
        const SizedBox(
          height: 10,
        ),
        viewModel.selectedImage == null
            ? const SizedBox()
            : Image.file(File(viewModel.selectedImage?.path ?? ""))
        // Image.file(file)
      ],
    );
  }

  void showBottomSheet(AddCarViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  // Open the camera
                  takePicture(ImageSource.camera, viewModel);
                },
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
              ),
              ListTile(
                onTap: () {
                  // Open the gallery
                  takePicture(ImageSource.gallery, viewModel);
                },
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }

  takePicture(ImageSource soure, AddCarViewModel viewModel) async {
    Navigator.pop(context);
    final ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: soure, imageQuality: 20);
    viewModel.setSelectedImage(file);
  }

  void addCarToServer(AddCarViewModel model) async {
    final AddCarRequestModel addCarRequestModel = AddCarRequestModel(
        name: _nameTextController.text,
        brand: _brandTextController.text,
        year: "${model.selectedYear ?? 0}",
        fuelType: model.selectedFuelType ?? "",
        transmission: model.selectedTransmission ?? "",
        address: _addressController.text,
        pricePerDay: _priceTextController.text,
        description: _descriptionTextController.text,
        imagePath:
            await MultipartFile.fromFile(model.selectedImage?.path ?? ""));
    LoaderWidget.showLoader();
    final response = await model.addCar(addCarRequestModel);
    LoaderWidget.hideLoader();

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response.message ?? "")));
  //Call the getCars method of the CarsViewModel
    NavigationServices().goBack(); //Go back to the previous screen
  }
}

/*
Name
Brand
yerar
fuel type
transmission type
addres
pricePerDay
description
UploadImage


TASK -> 
	1. Splash screen ->  
	2. Login ->  
	3. Sign up ->  
	4. Home screen (cars list) ->
	6. Add Car -> 

<key>NSCameraUsageDescription</key>
<string>We need to access your camera to take pictures.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need to access your gallery to pick photos.</string>


Take Picture -> 1.  Camera 2. Gallery

 */
