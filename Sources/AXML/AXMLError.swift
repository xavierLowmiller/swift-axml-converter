enum AXMLError: Error {
	case invalidFileSectionNumber
	case invalidStringSectionNumber
	case invalidResourceSectionNumber
	case invalidFileSizeChecksum
	case unrecognizedTagType(Int)
}
