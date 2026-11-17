
import SwiftUI

struct p1: View {

    @ObservedObject var viewModel: PlantViewModel

    var editingPlant: Plant? = nil

    @Environment(\.dismiss) private var dismiss

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

                    // MARK: - Header

                    HStack {

                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(
                                    Color.gray.opacity(0.3)
                                )
                                .clipShape(Circle())
                        }

                        Spacer()

                        Text("Set Reminder")
                            .font(.headline)
                            .foregroundStyle(.white)

                        Spacer()

                        // MARK: - Save Button

                        Button {

                            let name = plantName.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )

                            guard !name.isEmpty else {
                                return
                            }

                            let plantID: String

                            if let plant = editingPlant {

                                viewModel.updatePlant(
                                    plant,
                                    name: name,
                                    room: room,
                                    light: light,
                                    wateringDays: wateringDays,
                                    water: water
                                )

                                plantID = String(describing: plant.id)

                            } else {

                                let newPlant = Plant(
                                    name: name,
                                    room: room,
                                    light: light,
                                    wateringDays: wateringDays,
                                    water: water
                                )

                                viewModel.addPlant(newPlant)

                                plantID = String(
                                    describing: newPlant.id
                                )
                            }

                            // Schedule notification

                            NotificationManager.shared.scheduleReminder(
                                id: plantID,
                                plantName: name,
                                wateringDays: wateringDays
                            )

                            dismiss()

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

                    // MARK: - Plant Name

                    HStack(spacing: 8) {

                        Text("Plant Name")
                            .foregroundStyle(.white)

                        TextField("Pothos", text: $plantName)
                            .foregroundStyle(.white)
                    }
                    .padding(16)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 25)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 40)

                    // MARK: - Room & Light

                    VStack(spacing: 0) {

                        HStack {

                            Label(
                                "Room",
                                systemImage: "location"
                            )
                            .foregroundStyle(.white)

                            Spacer()

                            Picker("Room", selection: $room) {

                                Text("Bedroom")
                                    .tag("Bedroom")

                                Text("Living Room")
                                    .tag("Living Room")

                                Text("Kitchen")
                                    .tag("Kitchen")

                                Text("Balcony")
                                    .tag("Balcony")

                                Text("Bathroom")
                                    .tag("Bathroom")
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .tint(.gray)
                        }
                        .padding(16)

                        Divider()
                            .padding(.horizontal, 16)

                        HStack {

                            Label(
                                "Light",
                                systemImage: "sun.max"
                            )
                            .foregroundStyle(.white)

                            Spacer()

                            Picker("Light", selection: $light) {

                                Text("Full Sun")
                                    .tag("Full Sun")

                                Text("Partial Sun")
                                    .tag("Partial Sun")

                                Text("Low Light")
                                    .tag("Low Light")
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .tint(.gray)

                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)

                    }
                    .background(Color.gray.opacity(0.2))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 25)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 30)

                    // MARK: - Watering

                    VStack(spacing: 0) {

                        HStack {

                            Label(
                                "Watering Days",
                                systemImage: "drop"
                            )
                            .foregroundStyle(.white)

                            Spacer()

                            Picker(
                                "Watering Days",
                                selection: $wateringDays
                            ) {

                                Text("Every day")
                                    .tag("Every day")

                                Text("Every 2 days")
                                    .tag("Every 2 days")

                                Text("Every 3 days")
                                    .tag("Every 3 days")

                                Text("Once a week")
                                    .tag("Once a week")

                                Text("Every 10 days")
                                    .tag("Every 10 days")

                                Text("Every 2 weeks")
                                    .tag("Every 2 weeks")
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .tint(.gray)

                        }
                        .padding(16)

                        Divider()
                            .padding(.horizontal, 16)

                        HStack {

                            Label(
                                "Water",
                                systemImage: "drop"
                            )
                            .foregroundStyle(.white)

                            Spacer()

                            Picker("Water", selection: $water) {

                                Text("20-50 ml")
                                    .tag("20-50 ml")

                                Text("50-100 ml")
                                    .tag("50-100 ml")

                                Text("100-200 ml")
                                    .tag("100-200 ml")

                                Text("200-300 ml")
                                    .tag("200-300 ml")
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .tint(.gray)

                        }
                        .padding(16)

                    }
                    .background(Color.gray.opacity(0.2))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 25)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // MARK: - Delete Reminder

                    if let plant = editingPlant {

                        Button {

                            // Cancel plant notification

                            NotificationManager.shared.cancelReminder(
                                id: String(describing: plant.id)
                            )

                            // Delete plant

                            viewModel.deletePlant(plant)

                            dismiss()

                        } label: {

                            Text("Delete Reminder")
                                .font(.system(size: 14))
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(
                                    Color.gray.opacity(0.2)
                                )
                                .clipShape(Capsule())
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 50)
                    }

                    Spacer(minLength: 30)

                } // End of VStack

            } // End of ScrollView

        } // End of ZStack
        .preferredColorScheme(.dark)

        // MARK: - Load Existing Plant

        .onAppear {

            if let plant = editingPlant {

                plantName = plant.name
                room = plant.room
                water = plant.water

                switch plant.light {

                case "Full sun":
                    light = "Full Sun"

                case "Partial sun":
                    light = "Partial Sun"

                case "Shade":
                    light = "Low Light"

                default:
                    light = plant.light
                }

                if plant.wateringDays == "Every week" {

                    wateringDays = "Once a week"

                } else {

                    wateringDays = plant.wateringDays
                }
            }
        }

    } // End of body

} // End of p1

#Preview {
    p1(
        viewModel: PlantViewModel(),
        editingPlant: nil
    )
}
