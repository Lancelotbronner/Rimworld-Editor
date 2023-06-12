//
//  PackageDependency.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-08.
//

import Foundation
import SwiftData

@Model public final class ManifestPackageDependency {

	public init(_ identifier: String, for version: String? = nil) {
		self.package = identifier
		self.version = version
	}

	public var version: String?

	public var package: String
	// packageId

	public var name = ""
	// displayName

	public var steamURL: String?
	// steamWorkshopUrl

	public var downloadURL: String?
	// downloadUrl

	public func write(to collection: XMLElement) {
		let element = XMLElement(name: "li")
		element.addChild(XMLElement(name: "packageId", stringValue: package))
		element.addChild(XMLElement(name: "displayName", stringValue: name))
		element.addChild(XMLElement(name: "steamWorkshopURL", stringValue: steamURL))
		element.addChild(XMLElement(name: "downloadURL", stringValue: downloadURL))
		collection.addChild(element)
	}

}
