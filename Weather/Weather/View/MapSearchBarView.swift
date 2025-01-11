import SwiftUI

struct MapSearchBarView: View {
    @Binding var searchText: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search for places...", text: $searchText, onCommit: onSearch)
                .padding(.leading, 5)
                .textFieldStyle(PlainTextFieldStyle())
                .onChange(of: searchText) { _ in
                    onSearch()
                }
        }
        .padding(.horizontal, 10)
        .frame(height: 40)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}
