import Leaf

// class Truncatechars: BasicTag {
//   let name = "Truncatechars"

//     func run(arguments: [Argument]) throws -> Node? {
//         guard arguments.count == 2, let string = arguments.first?.value?.string, let maxLength = arguments[1].value?.int else {
//             return arguments.first?.value
//         }
//         let startIndex = string.index(string.startIndex, offsetBy: maxLength)
//         return Node(string.substring(to: startIndex))
//     }
// }
