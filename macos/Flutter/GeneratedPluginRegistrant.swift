//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import firebase_core
import firebase_ml_model_downloader
import path_provider_macos
import shared_preferences_macos
import tflite_flutter_helper

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FLTFirebaseCorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCorePlugin"))
  FirebaseModelDownloaderPlugin.register(with: registry.registrar(forPlugin: "FirebaseModelDownloaderPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  TfliteFlutterHelperPlugin.register(with: registry.registrar(forPlugin: "TfliteFlutterHelperPlugin"))
}
