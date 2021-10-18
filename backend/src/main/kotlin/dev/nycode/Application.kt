package dev.nycode

import dev.nycode.plugins.configureHTTP
import dev.nycode.plugins.configureMonitoring
import dev.nycode.plugins.configureRouting
import dev.nycode.plugins.configureSerialization
import io.ktor.application.Application
import io.ktor.routing.route
import io.ktor.routing.routing
import io.ktor.server.engine.embeddedServer
import io.ktor.server.netty.Netty

fun main() {
    embeddedServer(Netty, port = 8080, host = "0.0.0.0") {
        configureRouting()
        configureHTTP()
        configureMonitoring()
        configureSerialization()
        scanServRoutes()
    }.start(wait = true)
}

fun Application.scanServRoutes() {
    routing {
        route("context") {

        }
    }
}
