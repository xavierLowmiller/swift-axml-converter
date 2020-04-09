extension Bytes {
    mutating func validateHead() throws {
        let headSection = 0x00080003
        let count = self.count
        guard nextWord() == headSection else { throw AXMLError.invalidHeadSectionNumber }
        guard nextWord() == count else { throw AXMLError.invalidFileSizeChecksum }
    }

    mutating func parseStrings() throws -> [String] {
        let stringSection = 0x001c0001
        guard nextWord() == stringSection else { throw AXMLError.invalidStringSectionNumber }
        let chunkSize = nextWord()

        // The string section starts of with a bunch of metadata
        let numberOfStrings = nextWord()
        let numberOfStyles = nextWord()
        let flags = nextWord()

        let stringOffset = nextWord()
        let styleOffset = nextWord()

        let offsets = (0..<numberOfStrings).map { _ in nextWord() }
            + [(styleOffset == 0 ? chunkSize : styleOffset) - stringOffset]

        // Skip style offsets
        removeFirst(numberOfStyles * 4)

        let stringLengths = zip(offsets, offsets.dropFirst()).map { $1 - $0 }

        let utf8Flag = 1 << 8
        let isUTF8 = (flags & utf8Flag) != 0

        let strings: [String]
        if isUTF8 {
            strings = stringLengths.map { readUTF8String(length: $0) }
        } else {
            strings = stringLengths.map { readUTF16String(length: $0) }
        }

        // Skip style data
        if styleOffset != 0 {
            removeFirst(chunkSize - styleOffset)
        }

        return strings
    }

    mutating func validateResources() throws {
        let resourceSection = 0x00080180
        guard nextWord() == resourceSection else { throw AXMLError.invalidResourceSectionNumber }
        let chunkSize = nextWord()
        // Skip resource section
        removeFirst(chunkSize - 8)
    }
}

private extension Bytes {
    mutating func readUTF8String(length: Int) -> String {
        defer { removeFirst(length) }
        let count = Int(self[1])
        let chars = self[2..<count + 2]
        return String(decoding: chars, as: UTF8.self)
    }

    mutating func readUTF16String(length: Int) -> String {
        func getUInt16(at offset: Int) -> UInt16 {
            UInt16(self[offset + 1]) << 8 | UInt16(self[offset + 0])
        }
        defer { removeFirst(length) }

        let characterCount = getUInt16(at: 0)
        let chars = (0..<characterCount).map { offset in
            getUInt16(at: (Int(offset) + 1) * 2)
        }

        return String(decoding: chars, as: UTF16.self)
    }
}
