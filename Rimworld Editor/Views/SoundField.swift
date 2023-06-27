//
//  SoundField.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-15.
//

import SwiftUI
import SwiftData

struct SoundField<Label: View>: View {
	@Binding private var sound: Sound?
	@State private var isImportPresented = false

	private let label: Label

	init(_ sound: Binding<Sound?>, @ViewBuilder label: () -> Label) {
		_sound = sound
		self.label = label()
	}

	init(_ sound: Binding<Sound?>) where Label == EmptyView {
		self.init(sound) { EmptyView() }
	}

	init(_ title: LocalizedStringKey, sound: Binding<Sound?>) where Label == Text {
		self.init(sound) { Text(title) }
	}

	init(_ title: String, sound: Binding<Sound?>) where Label == Text {
		self.init(sound) { Text(title) }
	}

	var body: some View {
		LabeledContent {
			Button("Select Sound...") {
				isImportPresented = true
			}
			.buttonStyle(.link)
		} label: {
			label
		}
		.sheet(isPresented: $isImportPresented) {
			List {

			}
			.navigationTitle("Select a Sound")
		}
	}

}

struct SoundContentsField: View {
	@Bindable private var sound: Sound
	@State private var isImportPresented = false

	init(_ sound: Sound) {
		self.sound = sound
	}

	var body: some View {
		if sound.contents != nil {
			Image(systemName: "speaker.wave.3")
				.overlay(alignment: .topTrailing) {
					Button(role: .destructive) {
						sound.contents = nil
					} label: {
						SwiftUI.Label("Clear", systemImage: "x.circle.fill")
					}
					.foregroundStyle(.red)
				}
		} else {
			Button("Import Sound") {
				isImportPresented = true
			}
			.buttonStyle(.link)
			.fileImporter(isPresented: $isImportPresented, allowedContentTypes: [.audio]) { result in
				if case let .success(url) = result, let data = try? Data(contentsOf: url) {
					sound.contents = data
				}
			}
		}
	}

}
