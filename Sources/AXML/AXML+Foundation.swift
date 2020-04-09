#if canImport(Foundation)
import Foundation

public func axmlToXml(_ axml: Data) throws -> Data {
	let bytes = [UInt8](axml)

	return try Data(axmlToXml(bytes))
}

#endif
