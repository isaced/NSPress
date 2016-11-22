import Vapor
import VaporMySQL

let drop = Droplet()
drop.preparations.append(User.self)
drop.preparations.append(Post.self)
try drop.addProvider(VaporMySQL.Provider.self)

drop.get { req in
    return "hello!"
}

drop.get("version") { request in
    if let db = drop.database?.driver as? MySQLDriver {
        let version = try db.raw("SELECT version()")
        return try JSON(node: version)
    }else{
        return "No db connection"
    }
}

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

drop.run()
