import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/venues/presentation/bloc/venue_bloc.dart';
import 'features/venues/presentation/bloc/venue_event.dart';
import 'features/venues/presentation/pages/venue_list_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GetMaterialApp(
      title: 'Hotel List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: GoogleFonts.montserratTextTheme(textTheme),
      ),
      home: BlocProvider(
        create: (_) => di.sl<VenueBloc>()..add(GetVenuesWithFiltersEvent()),
        child: const VenueListPage(),
      ),
    );
  }
}
