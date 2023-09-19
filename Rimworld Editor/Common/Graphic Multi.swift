//
//  Graphic Multi.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-07-13.
//

import SwiftData
import SwiftUI

@Model public final class GraphicMulti: GraphicClass {

	public var north: Texture?
	public var south: Texture?
	public var west: Texture?
	public var east: Texture?

	public init() {

	}

	public static var label: some View {
		Label("Cardinal", systemImage: "photo.on.rectangle")
	}

	public var editor: some View {
		CardinalGraphicEditor(self)
	}

	public func populate(xml: XMLElement, at path: String) {
		xml.addChild(XMLElement(name: "texPath", stringValue: path))
	}

	public func write(to url: URL, at path: String) throws {
		try north?.contents?.write(to: url.appending(path: path + "_north").appendingPathExtension("png"))
		try south?.contents?.write(to: url.appending(path: path + "_south").appendingPathExtension("png"))
		try west?.contents?.write(to: url.appending(path: path + "_west").appendingPathExtension("png"))
		try east?.contents?.write(to: url.appending(path: path + "_east").appendingPathExtension("png"))
	}

}

struct CardinalGraphicEditor: View {
	@Bindable private var graphic: GraphicMulti

	init(_ graphic: GraphicMulti) {
		self.graphic = graphic
	}

	var body: some View {
		ModelField(selection: $graphic.north, content: TextureLabel.init) {
			LabeledContent("North") {
				if let north = graphic.north {
					TextureLabel(north)
				} else if let south = graphic.south {
					TextureLabel(south)
						.transformEffect(CGAffineTransform(scaleX: 1, y: -1))
				} else {
					TextureLabel(nil)
				}
			}
		}
		ModelField(selection: $graphic.south, content: TextureLabel.init) {
			LabeledContent("South") {
				if let south = graphic.south {
					TextureLabel(south)
				} else if let north = graphic.north {
					TextureLabel(north)
						.transformEffect(CGAffineTransform(scaleX: 1, y: -1))
				} else {
					TextureLabel(nil)
				}
			}
		}
		ModelField(selection: $graphic.west, content: TextureLabel.init) {
			LabeledContent("West") {
				if let west = graphic.west {
					TextureLabel(west)
				} else if let east = graphic.east {
					TextureLabel(east)
						.transformEffect(CGAffineTransform(scaleX: -1, y: 1))
				} else {
					TextureLabel(nil)
				}
			}
		}
		ModelField(selection: $graphic.east, content: TextureLabel.init) {
			LabeledContent("East") {
				if let east = graphic.east {
					TextureLabel(east)
				} else if let west = graphic.west {
					TextureLabel(west)
						.transformEffect(CGAffineTransform(scaleX: -1, y: 1))
				} else {
					TextureLabel(nil)
				}
			}
		}
	}
}
