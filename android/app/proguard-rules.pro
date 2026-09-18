-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_face.** { *; }
-keepclassmembers class * { @com.google.mlkit.** <methods>; }
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.**

# --- Flutter core + plugin registration (required, currently missing) ---
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Keep the generated plugin registrant explicitly
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Keep any class that implements FlutterPlugin / MethodCallHandler (covers plugins generically)
-keep class * implements io.flutter.embedding.engine.plugins.FlutterPlugin { *; }
-keep class * implements io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }

# Pigeon-generated plugin APIs (path_provider_android uses this pattern)
-keep class dev.flutter.pigeon.** { *; }
-keepclassmembers class * {
    @io.flutter.plugin.common.* *;
}

# path_provider specifically
-keep class io.flutter.plugins.pathprovider.** { *; }

-keep class com.dexterous.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod,InnerClasses,Exceptions
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**