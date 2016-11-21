import Vapor

let drop = Droplet()

drop.get { req in
    return "hello world!"
}

drop.run()
