import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacionforms1_udemy/screens/screens.dart';
import 'package:validacionforms1_udemy/services/services.dart';
 
void main() => runApp(AppState());

//instanciar el ProductService pero se crea hasta que se usa
class AppState extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Se usa el ChangeNotifierProvider
        ChangeNotifierProvider(
          create: ( _ ) => ProductsService() , 
          // lazy: true,
        ),
        //v237 auth
        ChangeNotifierProvider(create: ( _ ) => AuthService() ,)
      ],
      child: MyApp(),
    );
  }
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login & Productos App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'checking',
      routes: {
        
        'checking'   : ( _ ) => CheckAuthScreen(),
        
        'home'      : ( _ ) => HomeScreen(),
        'product'   : ( _ ) => ProductScreen(),
        
        'login'     : ( _ ) => LoginScreen(),
        'register'  : ( _ ) => RegisterScreen(),

      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.pink[600],
          elevation: 0,

        ),
        
      ),
      scaffoldMessengerKey: NotificationsService.messengerKey,
      
      
    );
  }
}