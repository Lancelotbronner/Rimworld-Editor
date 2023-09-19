//
//  ContentView.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-02-24.
//

import SwiftUI

struct ContentView: View {
	@State private var navigation = Navigation<AppRoutes>()

	var body: some View {
		NavigationSplitView {
			Sidebar(navigation)
			//TODO: Launch the game with the updated mod
//				.toolbar {
//					ToolbarItem(placement: .primaryAction) {
//						Button {
//							print("Build and run")
//						} label: {
//							Label("Run", systemImage: "play.fill")
//						}
//					}
//				}
		} detail: {
			NavigationStack(path: $navigation.path) {
				AppRouter(navigation)
					.navigationDestination(definition: ResearchProject.self)
			}
		}
		.environment(navigation)
		.navigationTitle("Rimworld Editor")
	}

}

#Preview {
	ContentView()
}
