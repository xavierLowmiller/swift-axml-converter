extension Array where Element == UInt8 {

    private enum TagType: Int {
        case startNamespace = 0x00100100
        case endNamespace = 0x00100101
        case startTag = 0x00100102
        case endTag = 0x00100103
        case text = 0x00100104
    }

    mutating func parseTags(strings: [String]) throws -> [UInt8] {
        var xmlLines = [#"<?xml version="1.0" encoding="utf-8"?>"#]

        var namespace: Namespace?
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
                namespace = parseNamespace(strings: strings)
                namespaceUrl = namespace?.urlAttribute

            case .endNamespace:
                removeFirst(4) // class attribute, unused
                removeFirst(4) // class attribute, unused
                namespace = nil
                namespaceUrl = nil

            case .startTag:
                let tag = parseStartTag(strings: strings,
                                        namespace: namespace,
                                        namespaceUrl: namespaceUrl)

                xmlLines += [spaces(for: indentationLevel) + "<\(tag)>"]

                namespaceUrl = nil
                indentationLevel += 1

            case .endTag:
                let tag = parseEndTag(strings: strings)

                indentationLevel -= 1
                xmlLines.append(spaces(for: indentationLevel) + "</\(tag)>")

            case .text:
                break
            }
        }

        return xmlLines.joined(separator: "\n").utf8.map { UInt8($0) }
    }

    private mutating func parseNamespace(strings: [String]) -> Namespace {
        let prefix = nextWord()
        let code = nextWord()
        return Namespace(
            code: code,
            uri: strings[code],
            prefix: strings[prefix]
        )
    }

    private mutating func parseStartTag(strings: [String],
                                        namespace: Namespace?,
                                        namespaceUrl: String?) -> String {
        removeFirst(4) // Tag URI
        let tagName = nextWord()
        removeFirst(4) // Unknown flags
        let attributeCount = nextWord()
        removeFirst(4) // class attribute, unused

        let attributes = (0..<attributeCount)
            .map { _ in Attribute(from: &self, strings: strings, namespace: namespace) }
            .map(\.description)

        let name = strings[tagName]
        return ([name, namespaceUrl] + attributes)
            .compactMap { $0 }
            .joined(separator: " ")
    }

    private mutating func parseEndTag(strings: [String]) -> String {
        removeFirst(4) // Tag URI
        let tagName = nextWord()

        return strings[tagName]
    }
}

private func spaces(for indentation: Int) -> String {
    String([Character](repeating: " ", count: indentation * 4))
}
