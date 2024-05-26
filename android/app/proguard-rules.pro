# Flutter wrapper
-ignorewarnings
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keepclassmembers class * extends io.flutter.app.FlutterActivity { *; }
-keepclassmembers class * extends io.flutter.app.FlutterFragmentActivity { *; }
-dontwarn io.flutter.embedding.**
