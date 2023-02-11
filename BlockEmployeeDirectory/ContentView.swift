//
//  ContentView.swift
//  BlockEmployeeDirectory
//
//  Created by Danny on 2/2/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            DirectoryView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
