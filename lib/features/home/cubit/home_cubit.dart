// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:card_scanner/core/db/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final LoclDatabase loclDatabase;
  HomeCubit(this.loclDatabase) : super(HomeInitial());

  addData(data) async {
    await loclDatabase.insertData(data);
  }

  fetchSavedData() async {
    try {
      emit(fetchSavedDataLoading());
      var data = await loclDatabase.fetCardData();
      emit(fetchSavedDataLoaded(cardData: data));
    } catch (e) {
      emit(fetchSavedDataFailed(errorMessage: e.toString()));
    }
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      emit(ImagePickerLoading());
      final ImagePicker picker = ImagePicker();

      final selectedSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text('Gallery'),
            ),
          ],
        ),
      );

      if (selectedSource != null) {
        final XFile? image = await picker.pickImage(source: selectedSource);
        if (image != null) {
          final CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: image.path,
            uiSettings: [
              AndroidUiSettings(
                lockAspectRatio: true,
                toolbarTitle: 'Crop the image correctly',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                aspectRatioPresets: [
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.ratio4x3,
                ],
              ),
              IOSUiSettings(
                title: 'Crop the image correctly',
                aspectRatioPresets: [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                ],
              ),
            ],
          );

          if (croppedFile != null) {
            var data = File(croppedFile.path);
            extractDataFromImage(data);
          } else {
            emit(ImagePickerFailed(errorMessage: 'Cropping failed'));
          }
        } else {
          emit(ImagePickerFailed(errorMessage: 'No image selected'));
        }
      } else {
        emit(ImagePickerFailed(errorMessage: 'No source selected'));
      }
    } catch (e) {
      emit(ImagePickerFailed(errorMessage: e.toString()));
    }
  }

  Future<void> extractDataFromImage(image) async {
    try {
      final inputImage = InputImage.fromFile(image);
      var textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;
      String email = _extractEmail(text);
      List<String> phoneNumbers = _extractPhoneNumbers(text);
      String address = _extractAddress(text);
      String name = _extractName(text);
      emit(
        ImagePickerLoaded(
            image: image,
            address: address,
            email: email,
            name: name,
            phoneNumber: phoneNumbers),
      );
    } catch (e) {
      emit(ImagePickerFailed(errorMessage: 'Failed to get data'));
      log('Failed to get data: $e');
    }
  }

  String _extractEmail(String text) {
    final RegExp emailRegex =
        RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    final match = emailRegex.firstMatch(text);
    return match != null ? match.group(0) ?? '' : 'No email found';
  }

  List<String> _extractPhoneNumbers(String text) {
    final RegExp phoneRegex = RegExp(r'\b\d{10,}\b');
    return phoneRegex
        .allMatches(text)
        .map((match) => match.group(0) ?? '')
        .toList();
  }

  String _extractAddress(String text) {
    final RegExp addressRegex = RegExp(
        r'[0-9]{1,4}[\s\w.,-]+(?:Road|Street|St|Ave|Avenue|Blvd|Lane|Ln|Drive|Dr|Complex|Plaza|Building|Tower|Pl|Square|Sq|Station|Market)[\s\w.,-]*'
        r'(?:\d{5,6})?');

    final match = addressRegex.firstMatch(text);
    return match != null ? match.group(0) ?? '' : 'No address found';
  }

  String _extractName(String text) {
    final RegExp nameRegex = RegExp(
        r'(Mr\.|Ms\.|Counsellor|Head|Centre Head|Manager|Dr\.\s?[A-Za-z]+|[A-Z][a-z]+\s[A-Z][a-z]+)');
    final match = nameRegex.firstMatch(text);
    return match != null ? match.group(0) ?? '' : 'No name found';
  }
}
