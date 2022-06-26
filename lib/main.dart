import 'package:docs_saver/Bloc/Add_category/add_category_bloc.dart';
import 'package:docs_saver/Bloc/expirydate/expirydate_bloc.dart';
import 'package:docs_saver/Bloc/image/image_bloc.dart';
import 'package:docs_saver/Bloc/radiobutton/radiobutton_bloc.dart';
import 'package:docs_saver/Model/document_model.dart';
import 'package:docs_saver/Views/Details_page/details_screen.dart';
import 'package:docs_saver/Views/Home/home.dart';
import 'package:docs_saver/core/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'Bloc/home_categories/categorychanging_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // if (!Hive.isAdapterRegistered(DocumentCategoryAdapter().typeId)) {
  Hive.registerAdapter(DocumentCategoryAdapter());
  // }
  Hive.registerAdapter(DocumentModelAdapter());

  await Hive.openBox<DocumentCategory>(boxName);

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ImageBloc(),
        ),
        BlocProvider(
          create: (context) => CategorychangingBloc(),
        ),
        BlocProvider(
          create: (context) => ExpirydateBloc(),
        ),
        BlocProvider(
          create: (context) => RadiobuttonBloc(),
        ),
        BlocProvider(
          create: (context) => AddCategoryBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: themeClr,
          ),
        ),
        themeMode: ThemeMode.dark,
        home: HomeScreen(),
      ),
    );
  }
}
