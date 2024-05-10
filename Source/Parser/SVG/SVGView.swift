//
//  SVGView.swift
//  SVGView
//
//  Created by Alisa Mylnikova on 20/08/2020.
//

import SwiftUI

public struct SVGView: View {

    private let url: URL?
    @State private var svg: SVGNode?

    public init(contentsOf url: URL) {
        self.url = url
    }

    @available(*, deprecated, message: "Use (contentsOf:) initializer instead")
    public init(fileURL: URL) {
        self.url = fileURL
    }

    public init(data: Data) {
        self.url = nil
        self.svg = SVGParser.parse(data: data)
    }

    public init(string: String) {
        self.url = nil
        self.svg = SVGParser.parse(string: string)
    }

    public init(stream: InputStream) {
        self.url = nil
        self.svg = SVGParser.parse(stream: stream)
    }

    public init(xml: XMLElement) {
        self.url = nil
        self.svg = SVGParser.parse(xml: xml)
    }

    public init(svg: SVGNode) {
        self.url = nil
        self.svg = svg
    }

    public func getNode(byId id: String) -> SVGNode? {
        return svg?.getNode(byId: id)
    }

    public var body: some View {
        if let svg {
            svg.toSwiftUI()
        } else if let url {
            Color.clear
                .onAppear {
                    Task { await load(url: url) }
                }
        }
    }

}

extension SVGView {
    
    func load(url: URL) async {
        let svg = SVGParser.parse(contentsOf: url)
        await MainActor.run {
            self.svg = svg
        }
    }
}
