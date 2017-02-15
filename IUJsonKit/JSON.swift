//
//  JSON.swift
//  IUJsonKit
//
//  Created by ricky on 2017. 2. 14..
//  Copyright © 2017년 Appcid. All rights reserved.
//

import Foundation

public typealias JsonDictionary = [String : JSON]

public enum JSON {
    case dictionary(JsonDictionary)
    case array([JSON])
    case string(String)
    case number(NSNumber)
    case bool(Bool)
    case null
    
    public var object: JsonDictionary? {
        switch self {
        case .dictionary(let value):
            return value
        default:
            return nil
        }
    }
    
    public var array: [JSON]? {
        switch self {
        case .array(let value):
            return value
        default:
            return nil
        }
    }
    
    public var string: String? {
        switch self {
        case .string(let value):
            return value
        case .number(let value):
            return value.stringValue
        default:
            return nil
        }
    }
    
    public var int: Int? {
        switch self {
        case .number(let value):
            return value.intValue
        case .string(let value):
            return Int(value)
        default:
            return nil
        }
    }
    
    public var int8: Int8? {
        switch self {
        case .number(let value):
            return value.int8Value
        case .string(let value):
            return Int8(value)
        default:
            return nil
        }
    }
    
    public var int16: Int16? {
        switch self {
        case .number(let value):
            return value.int16Value
        case .string(let value):
            return Int16(value)
        default:
            return nil
        }
    }
    
    public var int32: Int32? {
        switch self {
        case .number(let value):
            return value.int32Value
        case .string(let value):
            return Int32(value)
        default:
            return nil
        }
    }
    
    public var int64: Int64? {
        switch self {
        case .number(let value):
            return value.int64Value
        case .string(let value):
            return Int64(value)
        default:
            return nil
        }
    }
    
    public var uint: UInt? {
        switch self {
        case .number(let value):
            return value.uintValue
        case .string(let value):
            return UInt(value)
        default:
            return nil
        }
    }
    
    public var uint8: UInt8? {
        switch self {
        case .number(let value):
            return value.uint8Value
        case .string(let value):
            return UInt8(value)
        default:
            return nil
        }
    }
    
    public var uint16: UInt16? {
        switch self {
        case .number(let value):
            return value.uint16Value
        case .string(let value):
            return UInt16(value)
        default:
            return nil
        }
    }
    
    public var uint32: UInt32? {
        switch self {
        case .number(let value):
            return value.uint32Value
        case .string(let value):
            return UInt32(value)
        default:
            return nil
        }
    }
    
    public var uint64: UInt64? {
        switch self {
        case .number(let value):
            return value.uint64Value
        case .string(let value):
            return UInt64(value)
        default:
            return nil
        }
    }
    
    public var double: Double? {
        switch self {
        case .number(let value):
            return value.doubleValue
        case .string(let value):
            return Double(value)
        default:
            return nil
        }
    }
    
    public var float: Float? {
        switch self {
        case .number(let value):
            return value.floatValue
        case .string(let value):
            return Float(value)
        default:
            return nil
        }
    }
    
    public var bool: Bool? {
        switch self {
        case .bool(let value):
            return value
        case .number(let value):
            return value.boolValue
        default:
            return nil
        }
    }
    
    fileprivate static func from(object: Any) -> JSON? {
        switch object {
        case let value as String:
            return .string(value)
        case let value as NSNumber:
            return .number(value)
        case _ as NSNull:
            return .null
        case let value as NSDictionary:
            var jsonObject = JsonDictionary()
            for (k, v) in value {
                if let k = k as? String {
                    if let v = JSON.from(object: v) {
                        jsonObject[k] = v
                    }
                }
            }
            return .dictionary(jsonObject)
        case let value as NSArray:
            var jsonArray = [JSON]()
            for v in value {
                if let v = JSON.from(object: v) {
                    jsonArray.append(v)
                }
            }
            return .array(jsonArray)
        default:
            return nil
        }
    }
    
    public func isEmpty() -> Bool {
        switch self {
        case .null:
            return true
        default:
            return false
        }
    }
}

public enum JSONError: Error {
    case invalidString
}

// initialization
extension JSON {
    public init(data: Data) throws {
        if data.count == 0 {
            self = JSON.null
            return
        }
        
        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
        if let object = JSON.from(object: json) {
            self = object
        } else {
            self = JSON.null
        }
    }
    
    public init(string: String, encoding: String.Encoding = .utf8) throws {
        guard let data = string.data(using: encoding) else {
            throw JSONError.invalidString
        }
        
        try self.init(data: data)
    }
    
    public init(jsonObject: Any) {
        if let object = JSON.from(object: jsonObject) {
            self = object
        } else {
            self = JSON.null
        }
    }
    
    public static func object(for data: Data) -> Any? {
        if data.count == 0 {
            return nil
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            return json
        } catch {
            return nil
        }
    }
}

// subscript
extension JSON {
    public subscript(i: Int) -> JSON? {
        get {
            switch self {
            case .array(let value):
                return value[i]
            default:
                return nil
            }
        }
    }
    
    public subscript(key: String) -> JSON? {
        get {
            switch self {
            case .dictionary(let value):
                return value[key]
            default:
                return nil
            }
        }
    }
}

extension JSON: CustomStringConvertible {
    public var description: String {
        return prettyPrint()
    }
    
    public func prettyPrint(indent: String = "\t", tab tabCount: Int = 0) -> String {
        switch self {
        case .dictionary(let jsonDictionary):
            var returnString = "{\n"
            
            for (i, d) in jsonDictionary.enumerated() {
                for _ in 0...tabCount {
                    returnString += indent
                }
                
                returnString += "\"\(d.key)\" : \(d.value.prettyPrint(indent: indent, tab: tabCount + 1))"
                
                if i < jsonDictionary.count - 1 {
                    returnString += ",\n"
                } else {
                    returnString += "\n"
                }
            }
            
            for _ in 0..<tabCount {
                returnString += indent
            }
            
            returnString += "}"
            
            return returnString
        
        case .array(let jsonArray):
            var returnString = "[\n"
            
            for (i, v) in jsonArray.enumerated() {
                for _ in 0...tabCount {
                    returnString += indent
                }
                
                returnString += "\(v.prettyPrint(indent: indent, tab: tabCount + 1))"
                
                if i < jsonArray.count - 1 {
                    returnString += ",\n"
                } else {
                    returnString += "\n"
                }
            }
            
            for _ in 0..<tabCount {
                returnString += indent
            }
            
            returnString += "]"
            
            return returnString
        
        case .string(let string):
            return "\"\(string)\""
        
        case .number(let number):
            return "\(number)"
        
        case .bool(let booleanValue):
            return booleanValue ? "true" : "false"
        
        case .null:
            return "null"
        }
    }
    
    public static func jsonString(for jsonObject: Any, pretty: Bool = true) -> String? {
        let options: JSONSerialization.WritingOptions = pretty ? .prettyPrinted : []
        guard JSONSerialization.isValidJSONObject(jsonObject), let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: options) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}

