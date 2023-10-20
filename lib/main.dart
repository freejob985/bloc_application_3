import 'dart:convert';
import 'package:bloc_application_3/Apihelper.dart';
import 'package:bloc_application_3/Reservations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataInitial()) {
    fetchData();
  }
  void fetchData() async {
    try {
      List<dynamic> dataapi = [];
      emit(DataLoading());
      Apihelper api = Apihelper();
      final Cate = await api.fetchData('Reservations',
          tableName: 'Reservations',
          fromJson: (json) => Reservations.fromJson(json));
      if (Cate.data != null && Cate.data is List<dynamic>) {
        dataapi = Cate.data as List<dynamic>;
        emit(DataLoaded(dataapi));
      } else {
        emit(DataError('فشل في جلب البيانات'));
      }
      print(Cate);
    } catch (e) {
      print('حدث خطأ غير متوقع: $e');
      emit(DataError('حدث خطأ غير متوقع: $e'));
    }

    // try {
    //   final response = await http.get(
    //       Uri.parse('http://192.168.1.3/cafeteriaapp/public/api/Reservations'));

    //   if (response.statusCode == 200) {
    //     final jsonData = jsonDecode(response.body);
    //     if (jsonData is List<dynamic>) {
    //       final List<Map<String, dynamic>> data =
    //           jsonData.cast<Map<String, dynamic>>();
    //       emit(DataLoaded(data));
    //     } else {
    //       emit(DataError('فشل في جلب البيانات'));
    //     }
    //   } else {
    //     emit(DataError('فشل في جلب البيانات'));
    //   }
    // } catch (e) {
    //   print('حدث خطأ غير متوقع: $e');
    //   emit(DataError('حدث خطأ غير متوقع: $e'));
    // }
  }
}

abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataLoaded extends DataState {
  final List<dynamic> data;

  DataLoaded(this.data);
}

class DataError extends DataState {
  final String error;

  DataError(this.error);
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض البيانات'),
      ),
      body: BlocProvider(
        create: (context) => DataCubit(),
        child: DataListView(),
      ),
    );
  }
}

class DataListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataCubit = context.read<DataCubit>();
    return BlocBuilder<DataCubit, DataState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is DataLoaded) {
          return ListView.builder(
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              final item = state.data[index];
              final seat =
                  item['seat']; // افترض هنا أن "seat" هو مفتاح البيانات
              return ListTile(
                title: Text('Seat: $seat'),
              );
            },
          );
        } else if (state is DataError) {
          return Center(
            child: Text('حدث خطأ: ${state.error}'),
          );
        } else {
          return ElevatedButton(
            onPressed: () {
              dataCubit.fetchData();
            },
            child: Text('احصل على البيانات'),
          );
        }
      },
    );
  }
}
