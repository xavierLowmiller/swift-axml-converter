struct Attribute {
    let uri: Int
    let key: Int
    let value: Int
    let type: Int
    let data: Int

    private let strings: [String]
    private let namespace: Namespace?

    init(from data: inout [UInt8],
         strings: [String],
         namespace: Namespace?) {

        self.uri = data.nextWord()
        self.key = data.nextWord()
        self.value = data.nextWord()
        self.type = data.nextWord() >> 24
        self.data = data.nextWord()

        self.strings = strings
        self.namespace = namespace
    }
}

extension Attribute: CustomStringConvertible {
    // swiftlint:disable:next cyclomatic_complexity
    var description: String {
        "\(attributeKey)=\"\(attributeValue)\""
    }

    private var attributeKey: String {
        strings[self.key]
            .withNamespacePrefix(namespace?.prefix, shouldPrefix: uri == namespace?.code)
    }

    private var attributeValue: String {
        switch type {
        // Null
        case 0:
            return ""
        // Reference
        case 1:
            if data >> 24 == 1 {
                return String(format: "@android:%08X", data)
            } else {
                return String(format: "@%08X", data)
            }
        // Attribute
        case 2:
            if data >> 24 == 1 {
                return String(format: "?android:%08X", data)
            } else {
                return String(format: "?%08X", data)
            }
        // String
        case 3:
            return strings[self.value]
        // Float
        case 4:
            return "\(Float(bitPattern: UInt32(self.value)))"
        // Dimension
        case 5:
            let radixTable: [Float] = [0.00390625, 3.051758E-005, 1.192093E-007, 4.656613E-010]
            let dimensions = ["px", "dip", "sp", "pt", "in", "mm", "", ""]
            let dimension = dimensions[data & 0x0f]
            let amount = Float(data & 0xffffff00) * radixTable[(data >> 4) & 0x03]
            return String(format: "%f", amount) + dimension
        // Hex
        case 17:
            return String(format: "0x%08x", data)
        // Bool
        case 18:
            return data == 0 ? "false" : "true"
        // Colors
        case 28..<32:
            return String(format: "#%08x", data)
        // Integers
        case 16..<32:
            return String(format: "%d", data)
        default:
            return String(format: "<0x%x, type 0x%02x>", data, type)
        }
    }
}

private extension String {
    func withNamespacePrefix(_ prefix: String?, shouldPrefix: Bool) -> String {
        if shouldPrefix, let prefix = prefix {
            return prefix + ":" + self
        } else {
            return self
        }
    }
}
