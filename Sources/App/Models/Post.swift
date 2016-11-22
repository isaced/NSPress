import Vapor
import Fluent


final class Post: Model {
    var id: Node?
    var title: String
    var text: String
    var status: Int
    
    
    init(title: String, text: String, status: Int = 1) {
        self.title = title
        self.text = text
        self.status = status
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
        text = try node.extract("text")
        status = try node.extract("status")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title,
            "text": text,
            "status": status
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("posts") { users in
            users.id()
            users.string("title")
            users.string("text")
            users.int("status")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("posts")
    }
}
