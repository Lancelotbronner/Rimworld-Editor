//
//  Manifest Page.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-02-24.
//

import SwiftUI
import SwiftData

struct ManifestPage: View {

	@Environment(\.modelContext) private var context

	@Query private var manifests: [RimworldManifest]
	@Query private var versioned: [VersionedManifest]

	@State private var currentVersion: VersionedManifest?? = .some(.none)
	@State private var isVersionCreatorPresented = false

	var body: some View {
		Form {
			if let manifest = manifests.first {
				if let version = currentVersion.unsafelyUnwrapped {
					VersionedManifestEditor(manifest, version)
				} else {
					ManifestEditor(manifest)
				}
			} else {
				Text("Initializing manifest...")
					.onAppear {
						context.insert(RimworldManifest("Author.Mod", named: "My Mod"))
					}
			}
		}
		.formStyle(.grouped)
		.toolbar {
//			Picker("Version", selection: $currentVersion) {
//				Text("Common")
//					.tag(VersionedManifest??.some(.none))
//				ForEach(versioned) { versioned in
//					Text(versioned.version)
//						.tag(VersionedManifest??.some(versioned))
//				}
//			}
//			Button {
//				isVersionCreatorPresented = true
//			} label: {
//				Label("Add Version", systemImage: "plus")
//			}
//			.sheet(isPresented: $isVersionCreatorPresented) {
//				NewManifestVersionDialog()
//			}
		}
	}

}

struct ManifestEditor: View {
	@Bindable var manifest: RimworldManifest

	init(_ manifest: RimworldManifest) {
		self.manifest = manifest
	}

	var body: some View {
		Section("About") {
			TextField("Package Identifier", text: $manifest.package)
			TextField("Name", text: $manifest.name)
			TextField("Description", text: $manifest.summary)
				.frame(minHeight: 80)
		}
	}
}

struct VersionedManifestEditor: View {
	@Bindable var manifest: RimworldManifest
	@Bindable var version: VersionedManifest

	init(_ manifest: RimworldManifest, _ version: VersionedManifest) {
		self.manifest = manifest
		self.version = version
	}

	var body: some View {
		Section("About") {
			TextField("Package Identifier", text: $manifest.package)
			TextField("Name", text: $manifest.name)
			TextField("Description", text: $version.summary ?? "", prompt: Text(manifest.summary))
				.frame(minHeight: 80)
		}
	}
}

struct NewManifestVersionDialog: View {
	@Environment(\.modelContext) private var context
	@Environment(\.dismiss) private var dismiss

	@Query private var versions: [VersionedManifest]
	@State private var version = ""

	private var error: LocalizedStringKey? {
		if versions.contains(where: { $0.version == version }) {
			return "Version \(version) already exists."
		}
		if version.isEmpty {
			return "Version cannot be empty"
		}
		return nil
	}

	var body: some View {
		Form {
			TextField("Version", text: $version)
		}
		.padding()
		.toolbar {
			if let error {
				ToolbarItem(placement: .automatic) {
					Text(error)
						.foregroundStyle(.red)
				}
			}
			ToolbarItem(placement: .cancellationAction) {
				Button("Cancel", role: .cancel, action: dismiss.callAsFunction)
			}
			ToolbarItem(placement: .confirmationAction) {
				Button("Create") {
					if error != nil {
						return
					}
					context.insert(VersionedManifest(for: version))
					dismiss()
				}
				.disabled(error != nil)
			}
		}
	}
}
