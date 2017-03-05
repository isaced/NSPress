import Vapor
import HTTP
import Auth

final class AdminController {

    func addRoutes(_ drop: Droplet) {
        let protect = AdminProtectMiddleware()
        
        let router = drop.grouped("admin")
        let routerSecure = router.grouped(protect)
        
        router.get("login", handler: loginView)
        router.post("login", handler: login)
        routerSecure.get("", handler: index)
        routerSecure.get("write-post", handler: writePostView)
        routerSecure.post("write-post", handler: writePost)
        routerSecure.get("edit-post", Post.self, handler: editPostView)
        routerSecure.post("edit-post", Post.self, handler: editPost)
        routerSecure.get("posts", handler: postsView)
        routerSecure.get("logout", handler: logout)
    }

    func index(_ request: Request) throws -> ResponseRepresentable {
        let postcCount = try Post.all().count
        return try drop.view.make("admin/index.leaf", ["postCount":postcCount])
    }
    
    func loginView(_ request: Request) throws -> ResponseRepresentable {
        do {
            _ = try request.auth.user()
            
            // Not login, redirect to login
            return Response(redirect: "/admin")
        } catch {
            return try drop.view.make("admin/login.leaf")
        }
    }
    
    func login(_ request: Request) throws -> ResponseRepresentable {
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

    func writePostView(_ request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("/admin/write-post.leaf")
    }

    func writePost(_ request: Request) throws -> ResponseRepresentable {
        if let title = request.data["title"]?.string, let text = request.data["text"]?.string {
            var post = Post(title: title, text:text)
            do {
                try post.save()
                return Response(redirect: "/admin/posts")
            }
        }
        return try drop.view.make("/admin/write-post.leaf")
    }

    func postsView(_ request: Request) throws -> ResponseRepresentable {
        let posts = try Post.all().makeNode()
        return try drop.view.make("admin/posts.leaf", ["posts":posts])
    }
    
    func editPostView(_ request: Request, post: Post) throws -> ResponseRepresentable {
        return try drop.view.make("/admin/write-post.leaf", ["post": post])
    }
    func editPost(_ request: Request, post: Post) throws -> ResponseRepresentable {
        guard let title = request.data["title"]?.string, let text = request.data["text"]?.string else {
            throw Abort.custom(status: .ok, message: "content blank")
        }
        
        if var p = try Post.query().filter("id", post.id!).first() {
            p.title = title
            p.text = text
            try p.save()
        }

        return Response(redirect: "/admin/posts")
    }
}

public class AdminProtectMiddleware: Middleware {
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        do {
            _ = try request.auth.user()
            return try next.respond(to: request)
        } catch {
            return Response(redirect: "/admin/login")
        }
    }
}

