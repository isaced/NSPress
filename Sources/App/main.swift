import Vapor
import VaporMySQL

let drop = Droplet()
try drop.addProvider(VaporMySQL.Provider.self)

drop.get { req in
    let query = try User.query()
    return "hello world!"
}

drop.run()