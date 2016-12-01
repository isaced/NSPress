import Vapor
import HTTP
import Auth


final class AdminController {

    func addRoutes(_ drop: Droplet) {
        let protect = ProtectMiddleware(error: Abort.custom(status: .forbidden, message: "Not authorized."))
        
        let router = drop.grouped("admin")
        let routerSecure = router.grouped(protect)
        
        router.get("login", handler: login)
        routerSecure.get("", handler: index)
    }

    func index(_ request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("admin/index.leaf")
    }
    
    func login(_ request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("admin/login.leaf")
    }

}
