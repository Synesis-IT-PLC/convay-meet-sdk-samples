fun getProperty(key: String, defaultValue: String = ""): String {
    val properties = java.util.Properties()
    val propertiesFile = file("gradle.properties")
    if (propertiesFile.exists()) {
        propertiesFile.inputStream().use { properties.load(it) }
    }
    return properties.getProperty(key) ?: defaultValue
}

pluginManagement {
    repositories {
        google {
            content {
                includeGroupByRegex("com\\.android.*")
                includeGroupByRegex("com\\.google.*")
                includeGroupByRegex("androidx.*")
            }
        }
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
        maven {
            url =
                uri("https://raw.githubusercontent.com/Synesis-IT-PLC/convay-maven-repository/master/releases")
        }

    }
}

rootProject.name = "ConvaySdkTestApp"
include(":app")
