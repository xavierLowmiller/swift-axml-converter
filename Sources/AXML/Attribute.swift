struct Attribute {
	let uri: Int
	let key: Int
	let value: Int
	let type: Int
	let data: Int

	// swiftlint:disable:next cyclomatic_complexity
	func toString(_ strings: [String], namespace: Namespace?) -> String {
		let key = strings[self.key]

		let value: String
		switch type {
		// Null
		case 0:
			value = ""
		// Reference
		case 1:
			if data >> 24 == 1 {
				value = String(format: "@android:%08X", data)
			} else {
				value = String(format: "@%08X", data)
			}
		// Attribute
		case 2:
			if data >> 24 == 1 {
				value = String(format: "?android:%08X", data)
			} else {
				value = String(format: "?%08X", data)
			}
		// String
		case 3:
			value = strings[self.value]
		// Float
		case 4:
			value = "\(Float(bitPattern: UInt32(self.value)))"
		// Dimension
		case 5:
			let radixTable: [Float] = [0.00390625, 3.051758E-005, 1.192093E-007, 4.656613E-010]
			let dimensions = ["px", "dip", "sp", "pt", "in", "mm", "", ""]
			let dimension = dimensions[data & 0x0f]
			let amount = Float(data & 0xffffff00) * radixTable[(data >> 4) & 0x03]
			value = String(format: "%f", amount) + dimension
		// Hex
		case 17:
			value = String(format: "0x%08x", data)
		// Bool
		case 18:
			value = data == 0 ? "false" : "true"
		// Colors
		case 28..<32:
			value = String(format: "#%08x", data)
		// Integers
		case 16..<32:
			value = String(format: "%d", data)
		default:
			value = String(format: "<0x%x, type 0x%02x>", data, type)
		}

		let prefixedKey = key
			.withNamespacePrefix(namespace?.prefix, shouldPrefix: uri == namespace?.code)

		return "\(prefixedKey)=\"\(value)\""
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
