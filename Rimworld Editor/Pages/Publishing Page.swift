//
//  Publishing Page.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-02-24.
//

import SwiftUI
import SwiftData

struct PublishingPage: View {

	@Environment(\.modelContext) private var context
	@Query private var manifests: [RimworldManifest]

	var body: some View {
		if let manifest = manifests.first {
			PublishingEditor(manifest)
		} else {
			Text("Initializing manifest...")
				.onAppear {
					context.insert(RimworldManifest("Author.Mod", named: "My Mod"))
				}
		}
	}

}

struct PublishingEditor: View {

	@Environment(\.modelContext) private var context

	@State private var name = "MyPublishedMod"

	private let manifest: RimworldManifest

	init(_ manifest: RimworldManifest) {
		self.manifest = manifest
	}

	var body: some View {
		Form {
			Section("Configuration") {
				TextField("Name", text: $name)
			}
			Button(action: publish) {
				Label("Publish", systemImage: "globe")
					.frame(maxWidth: .infinity)
			}
			.buttonStyle(.borderless)
		}
		.formStyle(.grouped)
	}

	private func publish() {
		let url = URL.applicationSupportDirectory
			.appending(components: "Steam", "steamapps", "common", "Rimworld", "RimworldMac.app", "Mods", name, directoryHint: .isDirectory)
		do {
			try export(to: url)
		} catch {
			print("Failed to export: \(error)")
		}
	}

	private func export(to url: URL) throws {
		try context.save()

		// Fetch the manifest and prepare the project

		let manifest = try context.fetch(FetchDescriptor<RimworldManifest>())[0]

		let aboutURL = url.appending(component: "About", directoryHint: .isDirectory)
		try FileManager.default.createDirectory(at: aboutURL, withIntermediateDirectories: true)

		// Write the mod's About.xml

		let dependencies = try context.fetch(FetchDescriptor<ManifestPackageDependency>())

		let _metadata = XMLElement(name: "ModMetaData")
		manifest.write(to: _metadata)

		if !dependencies.isEmpty {
			let _dependencies = XMLElement(name: "modDependencies")
			for dependency in dependencies {
				dependency.write(to: _dependencies)
			}
			_metadata.addChild(_dependencies)
		}

		try XMLDocument(rootElement: _metadata).xmlData
			.write(to: aboutURL.appending(component: "About.xml", directoryHint: .notDirectory))

		// Prepare to write textures

		let texturesURL = url.appending(component: "Textures", directoryHint: .isDirectory)
		try FileManager.default.createDirectory(at: texturesURL, withIntermediateDirectories: true)

		// Prepare to write defs

		let defsURL = url.appending(component: "Defs", directoryHint: .isDirectory)
		try FileManager.default.createDirectory(at: defsURL, withIntermediateDirectories: true)

		let _defs = XMLElement(name: "Defs")

		// Write ResearchProject defs

		let projects = try context.fetch(FetchDescriptor<ResearchProject>())
		for project in projects {
			_defs.addChild(project.xml)
			// TODO: Allow graphic classes to write textures
			// project.graphics.write(textures: project.textures, at: texturesURL.appending(component: project.computedIdentifier))
		}

		// Write defs if applicable

		if _defs.childCount > 0 {
			try XMLDocument(rootElement: _defs).xmlData
				.write(to: defsURL.appending(component: "Definitions.xml", directoryHint: .notDirectory))
		}
	}

}

#Preview {
	PublishingPage()
}
