//
//  Rimworld Manifest.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-02-27.
//

import Foundation
import SwiftData

@Model public final class RimworldManifest {

	init(_ package: String, named name: String) {
		self.package = package
		self.name = name
	}

	/// The name of the mod
	var name: String

	/// The mod author names, usually set to your Steam/Forum name. Can be a list separated by " and " or by commas.
	var author = ""

	/// Unique package identifier, used to reference dependencies
	var package: String

	/// A URL to be displayed on your mod info page (if available). Can be set to link to anything. Most link it to their Github/Workshop page/forum post.
	var website: String?

	var summary = ""

	public func write(to root: XMLElement) {
		root.addChild(XMLElement(name: "packageId", stringValue: package))
		root.addChild(XMLElement(name: "name", stringValue: name))
		root.addChild(XMLElement(name: "description", stringValue: summary))

		if let website {
			root.addChild(XMLElement(name: "url", stringValue: website))
		}

		let authors = author.split(separator: ",")
		if authors.count > 1 {
			let _authors = XMLElement(name: "authors")
			for author in authors {
				_authors.addChild(XMLElement(name: "li", stringValue: String(author)))
			}
			root.addChild(_authors)
		} else {
			root.addChild(XMLElement(name: "author", stringValue: author))
		}
	}

}

@Model public final class VersionedManifest {

	init(for version: String) {
		self.version = version
	}

	/// Version of this manifest, fields default to the versionless one
	///
	/// Note that versionned fields are as follows:
	/// - ``summary`` (description)
	/// - (modDependencies)
	/// - (loadBefore)
	/// - (forceLoadBefore)
	/// - (loadAfter)
	/// - (forceLoadAfter)
	/// - (incompatibleWith)
	var version: String
	// supportedVersions

	/// Describes your mod, can be multiple lines long. Whitespace sensitive.
	var summary: String?
	// description

}
