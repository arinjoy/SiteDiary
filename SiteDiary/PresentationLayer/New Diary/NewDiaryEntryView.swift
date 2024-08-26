//
//  NewDiaryEntryView.swift
//  SiteDiary
//
//  Created by Arinjoy Biswas on 26/8/2024.
//

import SwiftUI
import PhotosUI

struct NewDiaryEntryView: View {

    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {

                    HStack {
                        Text("Add to site diary")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Spacer()

                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .foregroundColor(.primary.opacity(0.6))

                    GroupBox {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Add photos to site diary")
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            Divider()

                            ScrollView(.horizontal) {
                                LazyHStack(spacing: 20) {
                                    ForEach(0..<selectedImages.count, id: \.self) { index in
                                        selectedImages[index]
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)

                            PhotosPicker(
                                selection: $selectedItems,
                                matching: .images,
                                preferredItemEncoding: .compatible
                            ) {
                                Text("Add a photo")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(.green)
                                    .cornerRadius(8)
                                    .shadow(radius: 6)
                            }
                        }
                    }
                }
            }
            .padding(16)
            .toolbar { toolBarContent }
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.gray.opacity(0.3))
        }
        .onChange(of: selectedItems) {
            Task {
                selectedImages.removeAll()

                for item in selectedItems {
                    if let image = try? await item.loadTransferable(type: Image.self) {
                        selectedImages.append(image)
                    }
                }
            }
        }
    }

    @ToolbarContentBuilder
    var toolBarContent: some ToolbarContent {

        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                // TODO: Connect later
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                    .accessibilityAddTraits(.isButton)
            }
        }

        ToolbarItem(placement: .principal) {
            HStack {
                
                Spacer().frame(width: 20)
                
                Text("New Diary")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                    .accessibilityAddTraits(.isHeader)

                Spacer()
            }

        }

    }
}

#Preview {
    NewDiaryEntryView()
}
