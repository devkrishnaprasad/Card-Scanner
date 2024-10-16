import 'package:card_scanner/core/db/local_storage.dart';
import 'package:card_scanner/features/home/cubit/home_cubit.dart';
import 'package:card_scanner/features/home/view/widget/saved_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  final LoclDatabase loclDatabase;
  const HomePage({super.key, required this.loclDatabase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Scanner'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocProvider(
            create: (context) => HomeCubit(loclDatabase),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Center(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is ImagePickerLoaded && state.image != null) {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(width: 0.3)),
                              child: Image.file(
                                state.image!,
                                width: double.infinity,
                                height: 200,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Name : '),
                                Text(state.name)
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Email : '),
                                Text(state.email)
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Phone Number : '),
                                Text(state.phoneNumber.join(', '))
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Address : '),
                                Text(state.address)
                              ],
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<HomeCubit>().addData(
                                          CardData(
                                            name: state.name,
                                            email: state.email,
                                            address: state.address,
                                            phoneNumber:
                                                state.phoneNumber.toString(),
                                          ),
                                        );

                                    context.read<HomeCubit>().fetchSavedData();
                                  },
                                  child: const Text('Save'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<HomeCubit>()
                                        .pickImage(context);
                                  },
                                  child: const Text('Try another'),
                                )
                              ],
                            )
                          ],
                        );
                      }
                      if (state is ImagePickerLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is ImagePickerFailed) {
                        return GestureDetector(
                          onTap: () {
                            context.read<HomeCubit>().pickImage(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/scan.png',
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(height: 10),
                                const Text('Tap to scan card'),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            context.read<HomeCubit>().pickImage(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/scan.png',
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(height: 10),
                                const Text('Tap to scan card'),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const SavedItemList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
