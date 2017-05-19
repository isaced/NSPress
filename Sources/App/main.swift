import Vapor
import AuthProvider
import LeafProvider
import FluentProvider
import AuthProvider

let config = try Config()

// Provider
try config.addProvider(AuthProvider.Provider.self)
try config.addProvider(LeafProvider.Provider.self)
try config.addProvider(FluentProvider.Provider.self)

// Preparations
config.preparations.append(Post.self)

// Middleware
//config.addConfigurable(middleware: PasswordAuthenticationMiddleware(User.self, nil), name: "auth")

let drop = try Droplet(config)


// Home routes
drop.get { req in
    var posts = try Post.all()
    return try drop.view.make("index.leaf")
}

// Admin routes
AdminController().addRoutes(drop)

// Custom Tags
//if let leaf = drop.view as? LeafRenderer {
//    leaf.stem.register(Truncatechars())
//}

// Run application
try drop.run()
