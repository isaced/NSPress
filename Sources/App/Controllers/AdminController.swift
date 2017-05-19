import Vapor
import HTTP
import Routing
import AuthProvider
    
final class AdminController {

    func addRoutes(_ drop: Droplet) {
        
        //
        let router = drop.grouped("admin")
        router.get("login", handler: loginView)
        router.post("login", handler: login)
        
        
        //
        let protect = PasswordAuthenticationMiddleware(User.self)
        let routerSecure = router.grouped(protect)

        routerSecure.get("", handler: index)
        routerSecure.get("write-post", handler: writePostView)
        routerSecure.post("write-post", handler: writePost)
//        routerSecure.get("edit-post", Post.self, handler: editPostView)
//        routerSecure.post("edit-post", Post.self, handler: editPost)
        routerSecure.get("posts", handler: postsView)
        routerSecure.get("logout", handler: logout)
    }

     func index(_ request: Request) throws -> ResponseRepresentable {
         let postcCount = try Post.all().count
         return try drop.view.make("admin/index.leaf", ["postCount":postcCount])
     }

     func loginView(_ request: Request) throws -> ResponseRepresentable {
        if request.auth.isAuthenticated(User.self) {
             return Response(redirect: "/admin/")
         } else {
             return try drop.view.make("admin/login.leaf")
         }
     }

     func login(_ request: Request) throws -> ResponseRepresentable {
        
        if request.auth.isAuthenticated(User.self) {
            return Response(redirect: "/admin/")
        }else{
            do {
//                let ident = password
//                try request.auth.login(ident)
                return Response(redirect: "/admin/")
            } catch {
                return try drop.view.make("admin/login.leaf")
            }
        }
     }

     func logout(_ request: Request) throws -> ResponseRepresentable {
        if request.auth.isAuthenticated(User.self) {
             return Response(redirect: "/")
         } else {
             return Response(redirect: "/admin")
         }
     }

     func writePostView(_ request: Request) throws -> ResponseRepresentable {
         return try drop.view.make("/admin/write-post.leaf")
     }

     func writePost(_ request: Request) throws -> ResponseRepresentable {
         if let title = request.data["title"]?.string, let text = request.data["text"]?.string {
             let post = Post(title: title, text:text)
             do {
                 try post.save()
                 return Response(redirect: "/admin/posts")
             }
         }
         return try drop.view.make("/admin/write-post.leaf")
     }

     func postsView(_ request: Request) throws -> ResponseRepresentable {
         let posts = try Post.all()
         return try drop.view.make("admin/posts.leaf", ["posts":posts])
     }

     func editPostView(_ request: Request, post: Post) throws -> ResponseRepresentable {
         return try drop.view.make("/admin/write-post.leaf", ["post": post])
     }
     func editPost(_ request: Request, post: Post) throws -> ResponseRepresentable {
         guard let title = request.data["title"]?.string, let text = request.data["text"]?.string else {
             throw Abort(.noContent)
         }
        
//         if var p = try Post.query().filter("id", post.id!).first() {
//             p.title = title
//             p.text = text
//             try p.save()
//         }

         return Response(redirect: "/admin/posts")
     }
}
