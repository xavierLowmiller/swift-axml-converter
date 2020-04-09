public typealias Bytes = [UInt8]

public func axmlToXml(_ bytes: Bytes) throws -> Bytes {
    var bytes = bytes
    try bytes.validateHead()
    let strings = try bytes.parseStrings()
    try bytes.validateResources()

    return try bytes.parseTags(strings: strings)
}

#if canImport(Foundation)
import Foundation

public func axmlToXml(_ axml: Data) throws -> Data {
    let bytes = [UInt8](axml)

    return try Data(axmlToXml(bytes))
}

#endif
