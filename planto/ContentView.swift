

import SwiftUI
import AVFoundation

struct ContentView: View {

    // MARK: - Variables

    // Controls the Set Reminder sheet
    @State private var showReminder = false

    // Manages plants and watering progress
    @StateObject private var viewModel = PlantViewModel()

    // Stores the plant selected for editing
    // nil means adding a new plant
    @State private var selectedPlant: Plant? = nil

    // Speaks the celebration message
    @State private var speaker = AVSpeechSynthesizer()


    // MARK: - Main View

    var body: some View {

        ZStack {

            // Dark background
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // Page title and divider
                header

                // Show plant information if plants exist
                if !viewModel.plants.isEmpty {

                    // Check if all plants are watered
                    if viewModel.wateredCount == viewModel.plants.count {

                        Spacer()

                        allDoneView

                        Spacer()

                    } else {

                        // Watering progress
                        progressSection

                        // Plant list
                        plantsList
                    }
                }

                Spacer()

                // Welcome screen when no plants exist
                if viewModel.plants.isEmpty {
                    emptyState
                }

                Spacer()

                // Add Plant button
                addPlantButton
            }
        }

        // MARK: - Set Reminder Sheet

        // Open the page for adding or editing plants
        .sheet(isPresented: $showReminder) {

            p1(
                viewModel: viewModel,
                editingPlant: selectedPlant
            )
        }

        // MARK: - Celebration Voice

        // Detect when the number of watered plants changes
        .onChange(of: viewModel.wateredCount) { oldCount, newCount in

            // Speak only when the last plant is marked as watered
            if !viewModel.plants.isEmpty &&
                oldCount < newCount &&
                newCount == viewModel.plants.count {

                playThankYouVoice()
            }
        }

        // Keep the app in dark mode
        .preferredColorScheme(.dark)
    }


    // MARK: - 1. Header

    // Displays the page title and divider
    private var header: some View {

        VStack(spacing: 0) {

            HStack {

                Text("My Plants 🌱")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding(.top, 20)

            // Divider below the title
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.top, 18)
        }
    }


    // MARK: - 2. Empty State

    // Displayed when no plants have been added
    private var emptyState: some View {

        VStack(spacing: 20) {

            Image(.image1)
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)

            Text("Start your plant journey")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)

            Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                .font(.system(size: 13))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 290)
        }
    }


    // MARK: - 3. Progress Section

    // Displays the watering message and progress bar
    private var progressSection: some View {

        VStack(spacing: 0) {

            // Progress message from the ViewModel
            Text(viewModel.progressMessage)
                .font(.system(size: 13))
                .foregroundStyle(.gray)
                .padding(.top, 20)

            // Watering progress bar
            ProgressView(value: viewModel.progress)
                .progressViewStyle(.linear)
                .tint(.mint)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 15)
        }
    }


    // MARK: - 4. Plants List

    // Displays all plants in a scrollable list
    private var plantsList: some View {

        List {

            ForEach(viewModel.plants) { plant in

                plantRow(plant)

                    // Draw a divider between plants
                    .overlay(alignment: .bottom) {

                        if plant.id != viewModel.plants.last?.id {

                            Rectangle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(height: 1)
                                .padding(.horizontal, 4)
                        }
                    }

                    // Make rows fill the list width
                    .listRowInsets(EdgeInsets())

                    // Hide the default short separator
                    .listRowSeparator(.hidden)

                    // Swipe left to delete a plant
                    .swipeActions(
                        edge: .trailing,
                        allowsFullSwipe: false
                    ) {

                        Button(role: .destructive) {

                            // Cancel the plant notification
                            NotificationManager.shared.cancelReminder(
                                id: String(describing: plant.id)
                            )

                            // Delete the plant
                            viewModel.deletePlant(plant)

                        } label: {

                            Label(
                                "Delete",
                                systemImage: "trash"
                            )
                        }
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.black)
    }


    // MARK: - 5. Plant Row

    // Creates the layout for one plant
    private func plantRow(_ plant: Plant) -> some View {

        HStack(spacing: 12) {

            // MARK: Watering Button

            // Mark a plant as watered or not watered
            Button {

                viewModel.toggleWatered(plant)

            } label: {

                Image(
                    systemName: plant.isWatered
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(.system(size: 22))

                // Green for watered, gray for not watered
                .foregroundStyle(
                    plant.isWatered
                        ? Color.green
                        : Color.gray
                )
            }
            .buttonStyle(.plain)


            // MARK: Plant Information

            VStack(alignment: .leading, spacing: 5) {

                // Plant location
                Text("in \(plant.room)")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)

                // Tap the name to edit the plant
                Button {

                    selectedPlant = plant
                    showReminder = true

                } label: {

                    Text(plant.name)
                        .font(.system(size: 22))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)


                // Light and water information
                HStack(spacing: 8) {

                    infoLabel(
                        plant.light,
                        icon: "sun.max",
                        color: .yellow
                    )

                    infoLabel(
                        plant.water,
                        icon: "drop",
                        color: .cyan
                    )
                }
                .font(.system(size: 12))
                .padding(.top, 5)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .listRowBackground(Color.black)
    }


    // MARK: - 6. Information Label

    // Reusable style for light and water labels
    private func infoLabel(
        _ title: String,
        icon: String,
        color: Color
    ) -> some View {

        Label(title, systemImage: icon)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.2))
            .clipShape(
                RoundedRectangle(cornerRadius: 6)
            )
    }


    // MARK: - 7. All Done View

    // Displayed when all plants are watered
    private var allDoneView: some View {

        VStack(spacing: 15) {

            Image(.image1)
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 170)

            Text("All Done! 🎉")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)

            Text("All Reminders Completed")
                .font(.system(size: 13))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
    }


    // MARK: - 8. Add Plant Button

    // Opens the Set Reminder page
    private var addPlantButton: some View {

        Button {

            // Clear the previously selected plant
            selectedPlant = nil

            // Open the Add Plant page
            showReminder = true

        } label: {

            if viewModel.plants.isEmpty {

                // Main button for the empty screen
                Text("Set Plant Reminder")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 210, height: 44)
                    .background(Color.primarygreen)
                    .clipShape(Capsule())

                    // Subtle border
                    .overlay {

                        Capsule()
                            .stroke(
                                Color.white.opacity(0.1),
                                lineWidth: 1
                            )
                    }

                    // Soft button shadow
                    .shadow(
                        color: .black.opacity(0.25),
                        radius: 8,
                        x: 0,
                        y: 4
                    )

            } else {

                // Circular + button when plants exist
                HStack {

                    Spacer()

                    Image(systemName: "plus")
                        .font(.system(size: 22))
                        .foregroundStyle(.white)
                        .frame(width: 45, height: 45)
                        .background(Color.primarygreen)
                        .clipShape(Circle())
                }
                .padding(.horizontal, 20)
            }
        }
        .buttonStyle(.plain)

        // Keep the original button position
        .padding(
            .bottom,
            viewModel.plants.isEmpty ? 180 : 30
        )
    }


    // MARK: - 9. Thank You Voice

    // Speaks a message when all plants are watered
    private func playThankYouVoice() {

        // Create the spoken sentence
        let message = AVSpeechUtterance(
            string: "Thank you for taking care of me!"
        )

        // Use an English voice
        message.voice = AVSpeechSynthesisVoice(
            language: "en-US"
        )

        // Set the speaking speed
        message.rate = 0.45

        // Stop any previous speech
        speaker.stopSpeaking(at: .immediate)

        // Play the message
        speaker.speak(message)
    }
}


// MARK: - Preview

#Preview {
    ContentView()
}
