//
//  Rimworld_EditorApp.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-02-24.
//

import SwiftUI
import SwiftData

@main struct RimworldEditor: App {
    var body: some Scene {
		DocumentGroup(editing: RimworldEditor.project, contentType: .rimworldProject) {
			ContentView()
		}
    }
}
