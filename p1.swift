
import SwiftUI

struct p1: View {

    @ObservedObject var viewModel: PlantViewModel
    var editingPlant: Plant? = nil
    @Environment(\.dismiss) private var dismiss

    // Plant information
    @State private var plantName = ""
    @State private var room = "Bedroom"
    @State private var light = "Full Sun"
    @State private var wateringDays = "Every day"
    @State private var water = "20-50 ml"

    var body: some View {
        ZStack {
            Color(red: 0.11, green: 0.11, blue: 0.12)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {

                    // Header
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        }

                        Spacer()

                        Text("Set Reminder")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Spacer()

                        Button {
                            savePlant()
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.primarygreen)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 25)

                    // Plant name
                    HStack(spacing: 8) {
                        Text("Plant Name")
                            .foregroundStyle(.white)

                        TextField("Pothos", text: $plantName)
                            .foregroundStyle(.white)
                    }
                    .padding(16)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(.horizontal, 20)
                    .padding(.top, 40)

                    // Room and light
                    VStack(spacing: 0) {
                        optionRow("Room", icon: "location",
                                  selection: $room,
                                  options: ["Bedroom", "Living Room",
                                            "Kitchen", "Balcony", "Bathroom"])
                            .padding(16)

                        Divider().padding(.horizontal, 16)

                        optionRow("Light", icon: "sun.max",
                                  selection: $light,
                                  options: ["Full Sun", "Partial Sun", "Low Light"])
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                    }
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(.horizontal, 20)
                    .padding(.top, 30)

                    // Watering settings
                    VStack(spacing: 0) {
                        optionRow("Watering Days", icon: "drop",
                                  selection: $wateringDays,
                                  options: ["Every day", "Every 2 days",
                                            "Every 3 days", "Once a week",
                                            "Every 10 days", "Every 2 weeks"])
                            .padding(16)

                        Divider().padding(.horizontal, 16)

                        optionRow("Water", icon: "drop",
                                  selection: $water,
                                  options: ["20-50 ml", "50-100 ml",
                                            "100-200 ml", "200-300 ml"])
                            .padding(16)
                    }
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // Delete an existing plant
                    if let plant = editingPlant {
                        Button {
                            NotificationManager.shared.cancelReminder(
                                id: String(describing: plant.id)
                            )
                            viewModel.deletePlant(plant)
                            dismiss()
                        } label: {
                            Text("Delete Reminder")
                                .font(.system(size: 14))
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Capsule())
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 50)
                    }

                    Spacer(minLength: 30)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            loadPlant()
        }
    }

    // Reusable row for all Pickers
    private func optionRow(
        _ title: String,
        icon: String,
        selection: Binding<String>,
        options: [String]
    ) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundStyle(.white)

            Spacer()

            Picker(title, selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .tint(.gray)
        }
    }

    // Add or update a plant
    private func savePlant() {
        let name = plantName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard !name.isEmpty else { return }

        let id: String

        if let plant = editingPlant {
            viewModel.updatePlant(
                plant, name: name, room: room,
                light: light, wateringDays: wateringDays,
                water: water
            )
            id = String(describing: plant.id)
        } else {
            let plant = Plant(
                name: name, room: room, light: light,
                wateringDays: wateringDays, water: water
            )
            viewModel.addPlant(plant)
            id = String(describing: plant.id)
        }

        // Schedule watering notification
        NotificationManager.shared.scheduleReminder(
            id: id,
            plantName: name,
            wateringDays: wateringDays
        )
        dismiss()
    }

    // Load plant data when editing
    private func loadPlant() {
        guard let plant = editingPlant else { return }

        plantName = plant.name
        room = plant.room
        water = plant.water

        switch plant.light {
        case "Full sun": light = "Full Sun"
        case "Partial sun": light = "Partial Sun"
        case "Shade": light = "Low Light"
        default: light = plant.light
        }

        wateringDays = plant.wateringDays == "Every week"
            ? "Once a week" : plant.wateringDays
    }
}

#Preview {
    p1(viewModel: PlantViewModel())
}
