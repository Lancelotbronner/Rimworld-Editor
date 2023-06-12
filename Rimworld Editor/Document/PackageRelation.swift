//
//  PackageRelation.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-09.
//

import SwiftData

@Model public final class ManifestPackageRelation {

	public init(_ identifier: String, for version: String? = nil) {
		self.package = identifier
		self.version = version
	}

	public var version: String?

	public var package: String
	// packageId

	public var rawRelation: UInt8 = 0

	public var relation: PackageRelation {
		get { PackageRelation(rawValue: rawRelation) }
		set { rawRelation = newValue.rawValue }
	}

}

public struct PackageRelation: OptionSet {

	public var rawValue: UInt8

	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}

	public static let loadBefore = PackageRelation(rawValue: 0x1)
	public static let forceLoadBefore = PackageRelation(rawValue: 0x2)
	public static let loadAfter = PackageRelation(rawValue: 0x4)
	public static let forceLoadAfter = PackageRelation(rawValue: 0x8)
	public static let incompatibleWith = PackageRelation(rawValue: 0x16)

}
