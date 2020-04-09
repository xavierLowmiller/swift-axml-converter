extension Bytes {
    mutating func nextWord() -> Int {
        defer { removeFirst(4) }

        return Int(self[3]) << 24
            | Int(self[2]) << 16
            | Int(self[1]) << 8
            | Int(self[0]) << 0
    }
}
