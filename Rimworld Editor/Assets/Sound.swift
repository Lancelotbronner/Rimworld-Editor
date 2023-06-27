//
//  Sound.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-12.
//

import SwiftUI
import SwiftData

import AVFAudio

@Model public final class Sound: EditableModel {

	public var title: String

	public var path: String

	@Attribute(.externalStorage) public var contents: Data?

	public init(_ title: String, at path: String) {
		self.title = title
		self.path = path
	}

	public convenience init(_ title: String) {
		self.init(title, at: title)
	}

	public static var label: some View {
		Label("Sound", systemImage: "speaker.wave.3")
	}

	public var label: some View {
		Label {
			Text(title)
		} icon: {
			Label("Sound", systemImage: "speaker.wave.3")
		}
	}

	public var editor: some View {
		SoundEditor(sound: self)
	}

}

struct SoundEditor: View {
	@Bindable var sound: Sound

	var body: some View {
		Form {
			TextField("Title", text: $sound.title)
			SoundContentsField(sound)
		}
		.formStyle(.grouped)
	}
}

