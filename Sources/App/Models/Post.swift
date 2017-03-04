import Foundation
import Vapor
import Fluent

final class Post: Model {
    var id: Node?
    var title: String
    var text: String
    var status: Int
    var date: Date
    
    var exists: Bool = false
    
    enum Error: Swift.Error {
        case dateNotSupported
    }
    
    init(title: String, text: String, status: Int = 1) {
        self.title = title
        self.text = text
        self.status = status
        self.date = Date()
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
        text = try node.extract("text")
        status = try node.extract("status")
        
        if let unix = node["date"]?.double {
            // allow unix timestamps (easy to send this format from Paw)
            date = Date(timeIntervalSince1970: unix)
        } else if let raw = node["date"]?.string {
            // if it's a string we assume it's in mysql date format
            // this could be expanded to support many formats
            guard let date = dateFormatter.date(from: raw) else {
                throw Error.dateNotSupported
            }
            
            self.date = date
        } else {
            throw Error.dateNotSupported
        }
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title,
            "text": text,
            "status": status,
            // simply use the mysql date format for JSON responses and
            // obviously serializing to mysql.
            "date": dateFormatter.string(from: date)
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("posts") { users in
            users.id()
            users.string("title")
            users.string("text", length: 10000)
            users.int("status")
            users.double("date")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("posts")
    }
}

// MARK: Re-usable Date Formatter

private var _df: DateFormatter?
private var dateFormatter: DateFormatter {
    if let df = _df {
        return df
    }
    
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    _df = df
    return df
}
