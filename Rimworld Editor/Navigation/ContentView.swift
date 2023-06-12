//
//  ContentView.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-02-24.
//

import SwiftUI

struct ContentView: View {

	@Environment(Navigation<AppRoutes>.self) private var navigation

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
			AppRouter(navigation)
		}
		.navigationTitle("Rimworld Editor")
	}

}

#Preview {
	ContentView()
}
