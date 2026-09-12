allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    afterEvaluate {
        val androidExt = extensions.findByName("android") ?: return@afterEvaluate
        val extensionClass = androidExt.javaClass

        extensionClass.methods
            .firstOrNull { it.name == "setCompileSdk" && it.parameterTypes.contentEquals(arrayOf(Int::class.javaPrimitiveType)) }
            ?.invoke(androidExt, 37)

        extensionClass.methods
            .firstOrNull { it.name == "setCompileSdkVersion" && it.parameterTypes.contentEquals(arrayOf(Int::class.javaPrimitiveType)) }
            ?.invoke(androidExt, 37)
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
