//
//  NewDiaryEntryView.swift
//  SiteDiary
//
//  Created by Arinjoy Biswas on 26/8/2024.
//

import SwiftUI
import PhotosUI

struct NewDiaryEntryView: View {

    @State private var selectedPhotoItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()

    @State private var commentsInput: String = ""
    @State private var tagsInput: String = ""

    var listOfAreas: [String]  = ["Area #1", "Area #2", "Area #3"]
    @State var selectedArea = ""

    var listOfTaskCategory: [String]  = ["Task A", "Task B", "Task C"]
    @State var selectedTaskCategory = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {

                    mainHeader

                    photosSection

                    commentsSection

                    detailsSection
                }
            }
            .padding(16)
            .toolbar { navBarContent }
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.gray.opacity(0.3))
        }
        .onChange(of: selectedPhotoItems) {
            Task {
                selectedImages.removeAll()

                for item in selectedPhotoItems {
                    if let image = try? await item.loadTransferable(type: Image.self) {
                        selectedImages.append(image)
                    }
                }
            }
        }
    }
}

// MARK: - Private sub views

// MARK: - Nav Bar

private extension NewDiaryEntryView {

    @ToolbarContentBuilder
    var navBarContent: some ToolbarContent {

        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                // TODO: Connect later for routing / dismiss
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
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

// MARK: - Section Groups

private extension NewDiaryEntryView {

    var mainHeader: some View {
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
    }

    var photosSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 20) {

                groupHeader(title: "Add photos to site diary")

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
                    selection: $selectedPhotoItems,
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

    var commentsSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 20) {

                groupHeader(title: "Comments")

                Divider()

                TextField("Comments", text: $commentsInput)
                    .underlined()
            }
        }
    }

    var detailsSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 20) {

                groupHeader(title: "Details")

                Divider()

                DropdownTextField(
                    title: "Select Area",
                    dropdownInputs: listOfAreas,
                    inputText: $selectedArea)


                DropdownTextField(
                    title: "Task Category",
                    dropdownInputs: listOfTaskCategory,
                    inputText: $selectedTaskCategory)

                TextField("Tags", text: $tagsInput)
                    .underlined()
            }
        }
    }

}

// MARK: - Private Helpers

private extension NewDiaryEntryView {

    func groupHeader(title: String) -> some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)
    }
}


#Preview {
    NewDiaryEntryView()
}
