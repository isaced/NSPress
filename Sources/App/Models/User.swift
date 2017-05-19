import Vapor
import FluentProvider
import AuthProvider

 final class User: Model {
    var name: String
    let storage = Storage()

     init(name: String) {
         self.name = name
     }

    init(row: Row) throws {
        name = try row.get("name")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        return row
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { Post in
            Post.string("name")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}


extension User: PasswordAuthenticatable { }
