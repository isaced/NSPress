import Vapor
import HTTP
import Auth

final class AdminController {

    func addRoutes(_ drop: Droplet) {
        let protect = ProtectMiddleware(error: Abort.custom(status: .forbidden, message: "Not authorized."))
        
        let router = drop.grouped("admin")
        let routerSecure = router.grouped(protect)
        
        router.get("login", handler: login)
        router.post("login", handler: loginAction)
        routerSecure.get("", handler: index)
        routerSecure.get("logout", handler: logout)
    }

    func index(_ request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("admin/index.leaf")
    }
    
    func login(_ request: Request) throws -> ResponseRepresentable {
        do {
            _ = try request.auth.user()
            
            // Not login, redirect to login
            return Response(redirect: "/admin")
        } catch {
            return try drop.view.make("admin/login.leaf")
        }
    }
    
    func loginAction(_ request: Request) throws -> ResponseRepresentable {
        do {
            _ = try request.auth.user()
            return Response(redirect: "/admin")
        } catch {
            do {
                let ident = Identifier(id: Node("testid"))
                try request.auth.login(ident)
                return Response(redirect: "/admin")
            } catch {
                return try drop.view.make("admin/login.leaf")
            }
        }
    }

    func logout(_ request: Request) throws -> ResponseRepresentable {
        do {
            try request.auth.logout()
            return Response(redirect: "/")
        } catch {
            return Response(redirect: "/admin")
        }
    }
}
