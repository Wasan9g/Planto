
import Foundation
import Combine

class PlantViewModel: ObservableObject {

    @Published var plants: [Plant] = []

    func addPlant(_ plant: Plant) {
        plants.append(plant)
    }
    
    func deletePlant(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
    }


    func toggleWatered(_ plant: Plant) {

        for index in plants.indices {

            if plants[index].id == plant.id {
                plants[index].isWatered.toggle()
                break
            }
        }
    }

    var wateredCount: Int {
        plants.filter { $0.isWatered }.count
    }

    var progress: Double {

        if plants.isEmpty {
            return 0
        }

        return Double(wateredCount) / Double(plants.count)
    }

    var progressMessage: String {

        if plants.isEmpty {
            return "No plants yet 🌱"
        }

        if wateredCount == 0 {
            return "Your plants are waiting for a sip 💦"
        }

        if wateredCount == plants.count {
            return "All your plants are watered! 🌿"
        }

        return "\(wateredCount) of \(plants.count) plants watered 💧"
    }
    
  
    func updatePlant(
        _ plant: Plant,
        name: String,
        room: String,
        light: String,
        wateringDays: String,
        water: String
    ) {

        for index in plants.indices {

            if plants[index].id == plant.id {

                plants[index].name = name
                plants[index].room = room
                plants[index].light = light
                plants[index].wateringDays = wateringDays
                plants[index].water = water

                break
            }
        }
    }

    
    
}

