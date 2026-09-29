import CoreFoundation
import Foundation

public enum SchemaError: Error, CustomStringConvertible {
    case invalid(String)
    public var description: String { if case let .invalid(message) = self { message } else { "schema error" } }
}

/// Evaluates the keywords used by schemas/manifest-v1.schema.json. Unknown validation keywords fail closed.
public struct SchemaValidator {
    private let root: [String: Any]
    private let allowed: Set<String> = ["$schema", "$id", "$defs", "title", "$ref", "type", "additionalProperties",
                                        "required", "properties", "const", "enum", "minLength", "maxLength",
                                        "format", "minimum", "maximum", "minItems", "maxItems", "items",
                                        "pattern", "uniqueItems"]

    public init(schemaURL: URL) throws {
        guard let object = try JSONSerialization.jsonObject(with: Data(contentsOf: schemaURL)) as? [String: Any] else {
            throw SchemaError.invalid("schema root")
        }
        root = object
    }

    public func validate(_ data: Data) throws {
        let object = try JSONSerialization.jsonObject(with: data)
        try check(object, schema: root, path: "$", depth: 0)
    }

    private func check(_ value: Any, schema: [String: Any], path: String, depth: Int) throws {
        guard depth < 32 else { throw SchemaError.invalid("schema depth") }
        for key in schema.keys where !allowed.contains(key) { throw SchemaError.invalid("unknown schema keyword \(key)") }
        if let reference = schema["$ref"] as? String {
            guard reference.hasPrefix("#/$defs/"),
                  let definitions = root["$defs"] as? [String: Any],
                  let target = definitions[String(reference.dropFirst(8))] as? [String: Any] else {
                throw SchemaError.invalid("bad schema reference")
            }
            try check(value, schema: target, path: path, depth: depth + 1)
            return
        }
        if let type = schema["type"] as? String { try requireType(value, type, path) }
        if let types = schema["type"] as? [String] {
            guard types.contains(where: { matches(value, $0) }) else { throw SchemaError.invalid("\(path): type") }
        }
        if let constant = schema["const"], !equal(value, constant) { throw SchemaError.invalid("\(path): const") }
        if let choices = schema["enum"] as? [Any], !choices.contains(where: { equal(value, $0) }) {
            throw SchemaError.invalid("\(path): enum")
        }
        if let dictionary = value as? [String: Any] {
            let properties = schema["properties"] as? [String: Any] ?? [:]
            for name in schema["required"] as? [String] ?? [] where dictionary[name] == nil {
                throw SchemaError.invalid("\(path): missing \(name)")
            }
            if (schema["additionalProperties"] as? Bool) == false,
               dictionary.keys.contains(where: { properties[$0] == nil }) {
                throw SchemaError.invalid("\(path): unexpected property")
            }
            for (name, member) in dictionary {
                if let memberSchema = properties[name] as? [String: Any] {
                    try check(member, schema: memberSchema, path: "\(path).\(name)", depth: depth + 1)
                }
            }
        }
        if let array = value as? [Any] {
            if let min = schema["minItems"] as? Int, array.count < min { throw SchemaError.invalid("\(path): minItems") }
            if let max = schema["maxItems"] as? Int, array.count > max { throw SchemaError.invalid("\(path): maxItems") }
            if (schema["uniqueItems"] as? Bool) == true {
                for i in array.indices {
                    for j in array.indices where j > i {
                        if equal(array[i], array[j]) { throw SchemaError.invalid("\(path): uniqueItems") }
                    }
                }
            }
            if let itemSchema = schema["items"] as? [String: Any] {
                for (index, item) in array.enumerated() {
                    try check(item, schema: itemSchema, path: "\(path)[\(index)]", depth: depth + 1)
                }
            }
        }
        if let string = value as? String {
            if let min = schema["minLength"] as? Int, string.unicodeScalars.count < min { throw SchemaError.invalid("\(path): minLength") }
            if let max = schema["maxLength"] as? Int, string.unicodeScalars.count > max { throw SchemaError.invalid("\(path): maxLength") }
            if let pattern = schema["pattern"] as? String {
                let expression = try NSRegularExpression(pattern: pattern)
                guard expression.firstMatch(in: string, range: NSRange(string.startIndex..., in: string)) != nil else {
                    throw SchemaError.invalid("\(path): pattern")
                }
            }
            if let format = schema["format"] as? String {
                switch format {
                case "uuid": guard UUID(uuidString: string) != nil else { throw SchemaError.invalid("\(path): uuid") }
                case "date-time":
                    let formatter = ISO8601DateFormatter()
                    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    guard formatter.date(from: string) != nil else { throw SchemaError.invalid("\(path): date-time") }
                default: throw SchemaError.invalid("unsupported format")
                }
            }
        }
        if let number = value as? NSNumber, CFGetTypeID(number) != CFBooleanGetTypeID() {
            if let min = schema["minimum"] as? Double, number.doubleValue < min { throw SchemaError.invalid("\(path): minimum") }
            if let max = schema["maximum"] as? Double, number.doubleValue > max { throw SchemaError.invalid("\(path): maximum") }
        }
    }

    private func requireType(_ value: Any, _ type: String, _ path: String) throws {
        guard matches(value, type) else { throw SchemaError.invalid("\(path): expected \(type)") }
    }

    private func matches(_ value: Any, _ type: String) -> Bool {
        switch type {
        case "object": return value is [String: Any]
        case "array": return value is [Any]
        case "string": return value is String
        case "null": return value is NSNull
        case "boolean": return (value as? NSNumber).map { CFGetTypeID($0) == CFBooleanGetTypeID() } ?? false
        case "integer": return (value as? NSNumber).map { CFGetTypeID($0) != CFBooleanGetTypeID() && $0.doubleValue.rounded() == $0.doubleValue } ?? false
        case "number": return (value as? NSNumber).map { CFGetTypeID($0) != CFBooleanGetTypeID() } ?? false
        default: return false
        }
    }

    private func equal(_ lhs: Any, _ rhs: Any) -> Bool {
        guard let left = lhs as? NSObject, let right = rhs as? NSObject else { return false }
        return left.isEqual(right)
    }
}
