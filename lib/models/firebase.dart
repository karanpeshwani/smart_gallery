/*
Token

"1//0g8kbozblS6oWCgYIARAAGBASNwF-L9IrXX_IxH-u5IoMmV1ou24lY5OHpmjinTS8E_Dc4ZC6W5y16SIAHpEXFmArEPStibMrqRk"


Example
firebase deploy --token "$FIREBASE_TOKEN"




import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);


*/




// import 'package:firebase_core/firebase_core.dart';
// import '../firebase_options.dart';

// import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
// import 'package:firebase_core/firebase_core.dart';

// FirebaseModelDownloader.instance
//     .getModel(
//         "yourModelName",
//         FirebaseModelDownloadType.localModel,
//         FirebaseModelDownloadConditions(
//           iosAllowsCellularAccess: true,
//           iosAllowsBackgroundDownloading: false,
//           androidChargingRequired: false,
//           androidWifiRequired: false,
//           androidDeviceIdleRequired: false,
//         )
//     )
//     .then((customModel) {
//       // Download complete. Depending on your app, you could enable the ML
//       // feature, or switch from the local model to the remote model, etc.

//       // The CustomModel object contains the local path of the model file,
//       // which you can use to instantiate a TensorFlow Lite interpreter.
//       final localModelPath = customModel.file;

//       // ...
//     });