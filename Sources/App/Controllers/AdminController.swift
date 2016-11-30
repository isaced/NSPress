import Vapor
import HTTP

final class AdminController {

    func addRoutes(_ drop: Droplet) {
        let basic = drop.grouped("admin")
        basic.get("", handler: index)
    }

    func index(_ request: Request) throws -> ResponseRepresentable {
        return "hey"
    }
}
