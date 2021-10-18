package dev.nycode

import au.com.southsky.jfreesane.SaneSession
import java.net.InetAddress

class SaneService {

    init {

    }

}

fun main() {
    val session = SaneSession.withRemoteSane(InetAddress.getByName("192.168.1.28"))
    println(session.listDevices().map { it.name })
}
