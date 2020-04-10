import ArgumentParser
import AXML
import Foundation

struct AxmlToXml: ParsableCommand {

    @Argument()
    var path: String

    func run() throws {
        let url = URL(fileURLWithPath: (path as NSString).expandingTildeInPath)
        let axml = try Data(contentsOf: url)

        let xml = try axmlToXml(axml)

        print(String(decoding: xml, as: UTF8.self))
    }
}
