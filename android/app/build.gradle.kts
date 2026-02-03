plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin Android ve Kotlin pluginlerinden sonra gelmeli
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.adimsayar_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Kotlin DSL’de böyle yazılır
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        // Yeni DSL ile uyumlu
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.adimsayar_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Şimdilik debug key ile imzalama
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Flutter bağımlılıkları otomatik ekleniyor
    // Desugaring için gerekli kütüphane
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}