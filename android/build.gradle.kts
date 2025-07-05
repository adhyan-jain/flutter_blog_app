allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// android/app/build.gradle
plugins {
    id 'com.adhyan.blog_app'
    id 'com.google.gms.google-services' // Apply the plugin here
}

dependencies {
    // Import the Firebase BoM to manage your SDK versions
    implementation platform('com.google.firebase:firebase-bom:32.x.x') // Check for the latest version!

    // Add the dependencies for the Firebase products you want to use
    // For example:
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.firebase:firebase-firestore'
    implementation 'com.google.firebase:firebase-crashlytics'
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
