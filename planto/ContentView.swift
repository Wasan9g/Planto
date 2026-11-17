import SwiftUI

struct ContentView: View {
    @State private var showReminder = false
    @StateObject private var viewModel = PlantViewModel()
    @State private var selectedPlant: Plant? = nil
    var body: some View {
        ZStack{
        Color.black
        .ignoresSafeArea()
            
        VStack(spacing:0){
                
        HStack{
            Text("My Plants 🌱")
            .font(.system(size:28,weight: .bold))
            .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.top,20)
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height:1)
                    .padding(.top,18)
                
      if !viewModel.plants.isEmpty {
                                            
     if viewModel.wateredCount == viewModel.plants.count {
    Spacer()
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
            Spacer()
                            
            } else {
                            
            Text(viewModel.progressMessage)
                .font(.system(size: 13))
                .foregroundStyle(.gray)
                .padding(.top, 20)
                            
            ProgressView(value: viewModel.progress)
            .progressViewStyle(.linear)
            .tint(.mint)
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 15)
                        
            List {
            ForEach(viewModel.plants) { plant in
            HStack(spacing: 12) {
            Button {
        
            viewModel.toggleWatered(plant)
                                    
            } label: {
                                            
           Image(systemName: plant.isWatered ?"checkmark.circle.fill"
            : "circle")
                                            
           .font(.system(size: 22))
           .foregroundStyle(
           plant.isWatered ? Color.green : Color.gray)
            }
                                        
            .buttonStyle(.plain)
                                        
            VStack(alignment: .leading, spacing: 5) {
                                            
            Text("in \(plant.room)")
            .font(.system(size: 12))
            .foregroundStyle(.gray)

                Button {

                selectedPlant = plant
                showReminder = true
             } label: {

               Text(plant.name)
             .font(.system(size: 22))
             .foregroundStyle(.white)
                        }
                 .buttonStyle(.plain)

                 HStack(spacing: 8) {
                                                
                Label(plant.light, systemImage: "sun.max")
               .foregroundStyle(.yellow)
                                                
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                                                    .background(Color.gray.opacity(0.2))
                                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                                
                                                
                                                Label(plant.water, systemImage: "drop")
                                                    .foregroundStyle(.cyan)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(Color.gray.opacity(0.2))
                                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                                
                                            }
                                            .font(.system(size: 12))
                                            .padding(.top, 5)
                                            
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 14)
                                    
                                    .listRowBackground(Color.black)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        
                                        Button(role: .destructive) {
                                            viewModel.deletePlant(plant)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.black)
                    
                        }
                        
                    }
                    
                    
                    Spacer()
                    
                    //contant
                    if viewModel.plants.isEmpty {        VStack(spacing:20){
                        Image(.image1)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 170,height: 170)
                        Text("Start your plant journey")
                            .font(.system(size: 28,weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 290)
                    }
                    }
                    
                    Spacer()
                    
                    
                  
            
            Button {
                showReminder = true
            } label: {

                if viewModel.plants.isEmpty {

                    Text("Set Plant Reminder")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 210, height: 44)
                        .background(Color.primarygreen)
                        .clipShape(Capsule())
                        .overlay {
                            Capsule()
                                .stroke(
                                    Color.white.opacity(0.1),
                                    lineWidth: 1
                                )
                        }
                        .shadow(
                            color: .black.opacity(0.25),
                            radius: 8,
                            x: 0,
                            y: 4
                        )

                } else {

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
            .padding(.bottom, viewModel.plants.isEmpty ? 180 : 30)

                    
                }
            .sheet(isPresented: $showReminder) {
                p1(viewModel: viewModel, editingPlant: selectedPlant)
            
                    }
            }
            
        }
    }

    #Preview {
        ContentView()
    }
    


