public typealias Bytes = [UInt8]

public func axmlToXml(_ bytes: Bytes) throws -> Bytes {
	var bytes = bytes
	try bytes.validateHead()
	let strings = try bytes.parseStrings()
	try bytes.validateResources()

	return try bytes.parseTags(strings: strings)
}

private extension Array where Element == UInt8 {

	private enum TagType: Int {
		case startNamespace = 0x00100100
		case endNamespace = 0x00100101
		case startTag = 0x00100102
		case endTag = 0x00100103
		case text = 0x00100104
	}

	mutating func parseTags(strings: [String]) throws -> [UInt8] {
		var xmlLines = [#"<?xml version="1.0" encoding="utf-8"?>"#]

		var currentNamespace: String?
		var namespaceUrlCode: Int?
		var namespaceUrl: String?
		var indentationLevel = 0

		while !isEmpty {
			let rawValue = nextWord()
			guard let tagType = TagType(rawValue: rawValue)
				else { throw AXMLError.unrecognizedTagType(rawValue) }

			removeFirst(4) // Chunk Size, unused
			removeFirst(4) // Line Number, unused
			removeFirst(4) // Unknown, unused

			switch tagType {
			case .startNamespace:
				let prefix = nextWord()
				let uri = nextWord()
				currentNamespace = strings[prefix]
				namespaceUrlCode = uri
				namespaceUrl = strings[uri]
			case .endNamespace:
				removeFirst(4) // class attribute, unused
				removeFirst(4) // class attribute, unused
				currentNamespace = nil
				namespaceUrlCode = nil
				namespaceUrl = nil
			case .startTag:
				removeFirst(4) // Tag URI
				let tagName = nextWord()
				removeFirst(4) // Unknown flags
				let attributeCount = nextWord()
				removeFirst(4) // class attribute, unused

				let attributes = (0..<attributeCount).map { _ in
					Attribute(
						uri: nextWord(),
						key: nextWord(),
						value: nextWord(),
						type: nextWord() >> 24,
						data: nextWord()
					).toString(strings, namespace: currentNamespace, namespaceCode: namespaceUrlCode)
				}

				let namespaceUrlAttribute: String?
				if namespaceUrl != nil {
					namespaceUrlAttribute = "xmlns:\(currentNamespace!)=\"\(namespaceUrl!)\""
					namespaceUrl = nil
				} else {
					namespaceUrlAttribute = nil
				}

				let name = strings[tagName]
				let tagContent = ([name, namespaceUrlAttribute] + attributes)
					.compactMap { $0 }
					.joined(separator: " ")
				xmlLines.append(spaces(for: indentationLevel) + "<\(tagContent)>")
				indentationLevel += 1
			case .endTag:
				indentationLevel -= 1
				removeFirst(4) // Tag URI
				let tagName = nextWord()

				let name = strings[tagName]
				xmlLines.append(spaces(for: indentationLevel) + "</\(name)>")
			case .text:
				break
			}
		}

		return xmlLines.joined(separator: "\n").utf8.map { UInt8($0) }
	}
}

private func spaces(for indentation: Int) -> String {
	String([Character](repeating: " ", count: indentation * 4))
}
