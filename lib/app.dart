import 'package:beam_checkout_assignment/src/presentation/checkout/add_note_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'src/presentation/checkout/checkout_page.dart';
import 'src/presentation/landing/landing_page.dart';
import 'src/presentation/payment/payment_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LandingPage.routeName,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: const Color.fromRGBO(33, 37, 41, 1),
            fontFamily: GoogleFonts.lexendDeca().fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 27 / 18,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: const Color.fromRGBO(79, 112, 253, 1),
          unselectedItemColor: const Color.fromRGBO(115, 123, 132, 1),
          selectedLabelStyle: TextStyle(
            fontFamily: GoogleFonts.assistant().fontFamily,
            fontSize: 12,
            height: 16 / 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: GoogleFonts.assistant().fontFamily,
            fontSize: 12,
            height: 16 / 12,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              width: 1,
              color: Color.fromRGBO(222, 226, 230, 1),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(20),
            foregroundColor: const Color.fromRGBO(33, 37, 41, 1),
            textStyle: TextStyle(
              fontFamily: GoogleFonts.lexendDeca().fontFamily,
              fontSize: 24,
              fontWeight: FontWeight.w300,
              height: 40 / 24,
            ),
          ),
        ),
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: GoogleFonts.lexendDeca().fontFamily,
            fontSize: 24,
            height: 36 / 24,
          ),
          displayMedium: TextStyle(
            fontFamily: GoogleFonts.lexendDeca().fontFamily,
            fontSize: 16,
            color: const Color.fromRGBO(33, 37, 41, 1),
            height: 24 / 16,
          ),
          headlineLarge: TextStyle(
            fontFamily: GoogleFonts.lexendDeca().fontFamily,
            fontSize: 48,
            height: 56 / 48,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
            height: 22 / 14,
          ),
        ),
      ),
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case LandingPage.routeName:
                return const LandingPage();
              case CheckoutPage.routeName:
                return const CheckoutPage();
              case AddNotePage.routeName:
                return AddNotePage(
                  args: routeSettings.arguments as AddNotePageArgs,
                );
              case PaymentPage.routeName:
                return PaymentPage(
                  args: routeSettings.arguments as PaymentPageArgs,
                );
              default:
                return const LandingPage();
            }
          },
        );
      },
    );
  }
}
