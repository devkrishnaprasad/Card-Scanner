import 'package:card_scanner/features/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedItemList extends StatefulWidget {
  const SavedItemList({super.key});

  @override
  _SavedItemListState createState() => _SavedItemListState();
}

class _SavedItemListState extends State<SavedItemList> {
  @override
  void initState() {
    super.initState();

    context.read<HomeCubit>().fetchSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is fetchSavedDataLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is fetchSavedDataFailed) {
          return Text('Failed to get data: ${state.errorMessage}');
        }
        if (state is fetchSavedDataLoaded) {
          if (state.cardData.isEmpty) {
            return const Text('No saved data available.');
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Save card deatils',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 10),
              ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 5);
                },
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.cardData.length,
                itemBuilder: (context, index) {
                  final cardData = state.cardData[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
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
                        ]),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Name : '),
                            Text(cardData.name)
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Email : '),
                            Text(cardData.email)
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Phone Number : '),
                            Text(cardData.phoneNumber
                                .replaceAll('[', '')
                                .replaceAll(']', ''))
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Address : '),
                            Text(cardData.address)
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
