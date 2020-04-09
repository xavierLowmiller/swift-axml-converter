enum AXMLError: Error {
    case invalidHeadSectionNumber
    case invalidStringSectionNumber
    case invalidResourceSectionNumber
    case invalidFileSizeChecksum
    case unrecognizedTagType(Int)
}

#if canImport(Foundation)
import Foundation

extension AXMLError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidHeadSectionNumber:
            return "The head section checksum is incorrect"
        case .invalidStringSectionNumber:
            return "The string section checksum is incorrect"
        case .invalidResourceSectionNumber:
            return "The resource section checksum is incorrect"
        case .invalidFileSizeChecksum:
            return "The file size doesn't match the checksum"
        case .unrecognizedTagType(let type):
            return "Tags of type \(type) couldn't be recognized"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidHeadSectionNumber:
            return "Check the head section magic number and offset"
        case .invalidStringSectionNumber:
            return "Check the string section magic number and offset"
        case .invalidResourceSectionNumber:
            return "Check the resource section magic number and offset"
        case .invalidFileSizeChecksum:
            return "Verify the file size and offset"
        case .unrecognizedTagType:
            return "Check that the tag type is one of the magic numbers"
        }
    }
}
#endif
