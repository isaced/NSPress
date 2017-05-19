import Foundation
import Vapor
import FluentProvider

final class Post: Model {
    var title: String
    var text: String
    var status: Int
    var createAt: Date
    
    let storage = Storage()
    
    var exists: Bool = false
    
    enum Error: Swift.Error {
        case dateNotSupported
    }
    
    init(title: String, text: String, status: Int = 1) {
        self.title = title
        self.text = text
        self.status = status
        self.createAt = Date()
    }
    
    init(row: Row) throws {
        title = try row.get("title")
        text = try row.get("text")
        status = try row.get("status")
        createAt = try row.get("createAt")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("id", id)
        try row.set("title", title)
        try row.set("text", text)
        try row.set("status", status)
        try row.set("date", createAt)
        return row
    }
}

extension Post: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { Post in
            //Post.id(for: self)
            Post.string("title")
            Post.string("text")
            Post.int("status")
            Post.date("createAt")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
