plugins {
    application
    kotlin("jvm") version "1.5.31"
    kotlin("plugin.serialization") version "1.5.31"
}

group = "dev.nycode"
version = "0.0.1"

application {
    mainClass.set("dev.nycode.ApplicationKt")
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(platform("io.ktor:ktor-bom:1.6.4"))
    implementation("io.ktor:ktor-server-core")
    implementation("io.ktor:ktor-server-host-common")
    implementation("io.ktor:ktor-serialization")
    implementation("io.ktor:ktor-server-netty")
    implementation("ch.qos.logback:logback-classic:1.2.6")
    testImplementation("io.ktor:ktor-server-tests")

    implementation("com.googlecode.jfreesane", "jfreesane", "1.0")
}
