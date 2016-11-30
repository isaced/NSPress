import Vapor
import VaporMySQL
import Auth

let drop = Droplet()
drop.preparations.append(User.self)
drop.preparations.append(Post.self)
try drop.addProvider(VaporMySQL.Provider.self)

// Middleware
drop.middleware.append(AuthMiddleware(user: User.self))

// Home routes
drop.get { req in
    var posts = try Post.all().makeNode()
    return try drop.view.make("index.leaf", ["posts":posts])
}

// Admin routes
AdminController().addRoutes(drop)

// Run application
drop.run()
