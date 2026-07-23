import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (!keystorePropertiesFile.exists()) {
    throw GradleException(
        "Missing android/key.properties. Release signing cannot be configured.",
    )
}

keystorePropertiesFile.inputStream().use {
    keystoreProperties.load(it)
}

android {
    namespace = "com.joritna.mobile"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.joritna.mobile"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
                ?: throw GradleException(
                    "Missing keyAlias in android/key.properties",
                )

            keyPassword = keystoreProperties.getProperty("keyPassword")
                ?: throw GradleException(
                    "Missing keyPassword in android/key.properties",
                )

            storePassword = keystoreProperties.getProperty("storePassword")
                ?: throw GradleException(
                    "Missing storePassword in android/key.properties",
                )

            val storeFilePath = keystoreProperties.getProperty("storeFile")
                ?: throw GradleException(
                    "Missing storeFile in android/key.properties",
                )

            storeFile = file(storeFilePath)
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

dependencies {
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.4",
    )
}

flutter {
    source = "../.."
}