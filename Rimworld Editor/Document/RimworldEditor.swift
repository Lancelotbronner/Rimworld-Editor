//
//  Rimworld Document.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-02-27.
//

import UniformTypeIdentifiers
import SwiftData

extension RimworldEditor {

	static let project: [any PersistentModel.Type] = [
		RimworldManifest.self,
		VersionedManifest.self,
		ManifestPackageDependency.self,
		ManifestPackageRelation.self,

		Texture.self,

		Projectile.self,
		ResearchProject.self,
	]

}

extension UTType {

	public static var rimworldProject: UTType {
		UTType(exportedAs: "com.lancelotbronner.rimworld.project", conformingTo: .package)
	}

	public static var rimworldMod: UTType {
		UTType(exportedAs: "com.ludeon-studios.rimworld.mod", conformingTo: .folder)
	}

}
