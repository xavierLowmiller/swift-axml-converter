struct Namespace {
    let code: Int
    let uri: String
    let prefix: String
    
    var urlAttribute: String {
        "xmlns:\(prefix)=\"\(uri)\""
    }
}
