//
//  AppRouter.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-07.
//

import SwiftUI

struct AppRouter: View {
	private let navigation: Navigation<AppRoutes>

	init(_ navigation: Navigation<AppRoutes>) {
		self.navigation = navigation
	}

	var body: some View {
		Group {
			if let route = navigation.route {
				route.destination
			} else {
				ContentUnavailableView("Select a page", systemImage: "questionmark", description: Text("Pick something from the list."))
			}
		}
#if os(macOS)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background()
#endif
	}

}
