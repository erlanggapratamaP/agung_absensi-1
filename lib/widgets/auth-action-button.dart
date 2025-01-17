// import 'package:face_net_authentication/utils/logging.dart';

// import 'package:face_net_authentication/locator.dart';
// import 'package:face_net_authentication/pages/absen/absen_page.dart';

// import 'package:face_net_authentication/pages/widgets/app_button.dart';
// import 'package:face_net_authentication/services/ml_service.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../../application/face_recognition/db/databse_helper.dart';
// import '../../application/face_recognition/models/user.model.dart';
// import '../../application/routes/route_names.dart';
// import '../../style/style.dart';
// import 'app_text_field.dart';

// class AuthActionButton extends StatefulWidget {
//   AuthActionButton(
//       {Key? key,
//       required this.onPressed,
//       required this.isLogin,
//       required this.reload});
//   final Function onPressed;
//   final bool isLogin;
//   final Function reload;
//   @override
//   _AuthActionButtonState createState() => _AuthActionButtonState();
// }

// class _AuthActionButtonState extends State<AuthActionButton> {
//   final MLService _mlService = locator<MLService>();

//   final TextEditingController _userTextEditingController =
//       TextEditingController(text: '');
//   final TextEditingController _passwordTextEditingController =
//       TextEditingController(text: '');

//   User? predictedUser;

//   Future _signUp(context) async {
//     // DatabaseHelper _databaseHelper = DatabaseHelper.instance;
//     List predictedData = _mlService.predictedData;
//     String user = _userTextEditingController.text;
//     String password = _passwordTextEditingController.text;
//     User userToSave = User(
//       user: user,
//       password: password,
//       modelData: predictedData,
//     );
//     await _databaseHelper.insert(userToSave);
//     debugger(message: 'inserted');
//     this._mlService.setPredictedData([]);
//     Navigator.push(context,
//         MaterialPageRoute(builder: (BuildContext context) => AbsenPage()));
//   }

//   Future _signIn(context) async {
//     String password = _passwordTextEditingController.text;
//     if (this.predictedUser!.password == password) {
//       return;
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Text('Wrong password!'),
//           );
//         },
//       );
//     }
//   }

//   Future<User?> _predictUser() async {
//     User? userAndPass = await _mlService.predict();
//     return userAndPass;
//   }

//   Future onTap() async {
//     try {
//       bool faceDetected = await widget.onPressed();
//       if (faceDetected) {
//         if (widget.isLogin) {
//           var user = await _predictUser();
//           if (user != null) {
//             this.predictedUser = user;
//           }
//         }
//         PersistentBottomSheetController bottomSheetController =
//             Scaffold.of(context)
//                 .showBottomSheet((context) => signSheet(context));
//         bottomSheetController.closed.whenComplete(
//             () => context.pushNamed(RouteNames.absenDaftarNameRoute));
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: onTap,
//       child: Container(
//         height: 56,
//         width: MediaQuery.of(context).size.width * 0.8,
//         decoration: BoxDecoration(
//             color: Palette.primaryColor,
//             borderRadius: BorderRadius.circular(10)),
//         alignment: Alignment.center,
//         padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'CAPTURE',
//               style: TextStyle(color: Colors.white),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Icon(Icons.camera_alt, color: Colors.white)
//           ],
//         ),
//       ),
//     );
//   }

//   signSheet(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           widget.isLogin && predictedUser != null
//               ? Container(
//                   child: Text(
//                     'Welcome back, ' + predictedUser!.user + '.',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 )
//               : widget.isLogin
//                   ? Container(
//                       child: Text(
//                       'User not found 😞',
//                       style: TextStyle(fontSize: 20),
//                     ))
//                   : Container(),
//           Container(
//             child: Column(
//               children: [
//                 !widget.isLogin
//                     ? AppTextField(
//                         controller: _userTextEditingController,
//                         labelText: "Your Name",
//                       )
//                     : Container(),
//                 SizedBox(height: 10),
//                 widget.isLogin && predictedUser == null
//                     ? Container()
//                     : AppTextField(
//                         controller: _passwordTextEditingController,
//                         labelText: "Password",
//                         isPassword: true,
//                       ),
//                 SizedBox(height: 10),
//                 Divider(),
//                 SizedBox(height: 10),
//                 widget.isLogin && predictedUser != null
//                     ? AppButton(
//                         text: 'LOGIN',
//                         onPressed: () async {
//                           _signIn(context);
//                         },
//                         icon: Icon(
//                           Icons.login,
//                           color: Colors.white,
//                         ),
//                       )
//                     : !widget.isLogin
//                         ? AppButton(
//                             text: 'SIGN UP',
//                             onPressed: () async {
//                               await _signUp(context);
//                             },
//                             icon: Icon(
//                               Icons.person_add,
//                               color: Colors.white,
//                             ),
//                           )
//                         : Container(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
