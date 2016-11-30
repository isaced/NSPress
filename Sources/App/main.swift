import Vapor
import VaporMySQL

let drop = Droplet()
drop.preparations.append(User.self)
drop.preparations.append(Post.self)
try drop.addProvider(VaporMySQL.Provider.self)

// ---

drop.get { req in
    var posts: Node?
    if let db = drop.database?.driver as? MySQLDriver {
            posts = try Post.all().makeNode()
    }
    return try drop.view.make("index.leaf", ["posts":posts ?? []])
}

// ---

drop.get("test") { request in
    var user = User(name: "Jack")
    try user.save()
    return try JSON(node: User.all().makeNode())
}

drop.get("add-post") { request in
    var user = Post(title: "哈哈～", text: "aaa112345")
    try user.save()
    return try JSON(node: Post.all().makeNode())
}

// Admin routes
AdminController().addRoutes(drop)

drop.run()
