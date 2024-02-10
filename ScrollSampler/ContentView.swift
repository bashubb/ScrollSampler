//
//  ContentView.swift
//  ScrollSampler
//
//  Created by HubertMac on 30/10/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var dataModel = DataModel()
    @State private var vertical = true
    
    @State private var showPopup = false
    @State private var modifierName = ""
    @State private var buttonText = "Copy modifer to clipboard"
    private let pasteboard = UIPasteboard.general
    
    let formatter: NumberFormatter
    
    var body: some View {
        ZStack {
            NavigationSplitView {
                VStack(spacing:0) {
                    VStack(spacing: 3) {
                        
                        Button {
                            dataModel = DataModel()
                        } label: {
                            Text("Reset")
                                .foregroundStyle(Color.white)
                                .padding(6)
                                .frame(width: 200, height: 40)
                                .background(Color.red.opacity(0.7), in: RoundedRectangle(cornerRadius: 8))
                        }
                        
                        Button {
                            vertical.toggle()
                        } label: {
                            Text("Change Orientation")
                                .foregroundStyle(Color.white)
                                .padding(6)
                                .frame(width: 200, height: 40)
                                .background(Color.green.opacity(0.8), in: RoundedRectangle(cornerRadius: 8))
                        }
                        
                        Button {
                            showPopup = true
                        } label: {
                            Text("Generate modifier")
                                .foregroundStyle(Color.white)
                                .padding(6)
                                .frame(width: 200, height: 40)
                                .background(Color.blue.opacity(0.8), in: RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                    
                    Form {
                        Section("Presets") {
                            Button ("Edge opacity") {
                                dataModel.variants[0].opacity = 0.0
                                dataModel.variants[2].opacity = 0.0
                            }
                        }
                        ForEach(dataModel.variants) { variant in
                            @Bindable var variant = variant
                            Section(variant.id) {
                                
                                
                                HStack {
                                    Text("Opacity")
                                    Text(formatter.string(for:variant.opacity) ?? "")
                                        .font(.caption)
                                    Slider(value: $variant.opacity, in: 0...1)
                                }
                                HStack {
                                    Text("Scale")
                                    Text(formatter.string(for:variant.scale) ?? "")
                                        .font(.caption)
                                    Slider(value: $variant.scale, in: 0...3)
                                }
                                HStack {
                                    Text("xOffset")
                                    Text(formatter.string(for:variant.xOffset) ?? "")
                                        .font(.caption)
                                    Slider(value: $variant.xOffset, in: -1000...1000)
                                }
                                HStack {
                                    Text("yOffset")
                                    Text(formatter.string(for:variant.yOffset) ?? "")
                                        .font(.caption)
                                    Slider(value: $variant.yOffset, in: 0...1000)
                                }
                                HStack {
                                    Text("blur")
                                    Text(formatter.string(for:variant.blur) ?? "")
                                        .font(.caption)
                                    Slider(value: $variant.blur, in: 0...50)
                                }
                                HStack {
                                    Text("saturation")
                                    Text(formatter.string(for:variant.saturation) ?? "")
                                        .font(.caption)
                                    Slider(value: $variant.saturation, in: 0...1)
                                }
                                HStack {
                                    Text("Rotation degrees")
                                    Text(formatter.string(for:variant.degrees) ?? "")
                                        .font(.caption)
                                    Slider(value: $variant.degrees, in: -180...180)
                                }
                                HStack {
                                    Text ("Rotation x axis")
                                    Text(formatter.string(for:variant.rotationX) ?? "")
                                        .font(.caption)
                                    Slider(value: $variant.rotationX, in: 0...1)
                                }
                                HStack {
                                    Text("Rotation y axis")
                                    Text(formatter.string(for:variant.rotationY) ?? "")
                                        .font(.caption)
                                    Slider(value: $variant.rotationY, in: 0...1)
                                }
                                HStack {
                                    Text("Rotation z axis")
                                    Text(formatter.string(for:variant.rotationZ) ?? "")
                                        .font(.caption)
                                    Slider(value: $variant.rotationZ, in: 0...1)
                                }
                                
                            }
                        }
                    }
                    .toolbar (.hidden)
                }
            } detail: {
                if vertical {
                    ScrollView {
                        VStack {
                            ForEach(0..<100) { i in
                                ScrollingRectangle(dataModel: dataModel)
                                    .frame(height:100)
                            }
                        }
                        .padding()
                    }
                    .toolbar(.hidden)
                    .ignoresSafeArea()
                }
                else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<100) { i in
                                ScrollingRectangle(dataModel: dataModel)
                                    .frame(width:100)
                            }
                        }
                        .padding()
                        
                    }
                    .toolbar(.hidden)
                    .ignoresSafeArea()
                    
                }
            }
           
            if $showPopup.wrappedValue {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    //Popup
                    VStack(spacing: 15) {
                        HStack {
                            Spacer()
                            Text("Generate custom modifier")
                                .bold()
                                .foregroundStyle(Color.white)
                            Button {
                                self.showPopup = false
                                modifierName = ""
                            } label: {
                                Image(systemName: "xmark.circle")
                            }
                            .font(.title)
                            .foregroundStyle(Color.white)
                            .padding()
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(Color.blue.opacity(0.8))
                        
                        Spacer()
                        Text("Enter name for your modifier")
                            
                        TextField("Modifier name", text: $modifierName)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .padding()
                        
                        Button(buttonText) {
                            pasteboard.string = createModifier(modifierName)
                            withAnimation {
                                buttonText = "Copied!"
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    buttonText = "Copy modifer to clipboard"
                                }
                            }
                           
                        }
                        .disabled(modifierName == "")
                        .buttonStyle(.bordered)
                        .padding(.bottom, 30)
                    }
                    .frame(width: 350 , height: 300)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(radius: 20)
                    
                
                }
            }
        }
        .statusBarHidden()
    }
    
    init() {
        formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
    }
    
    func createModifier(_ name: String) -> String {
        // Creates string with custom modifier and View extension
        
        let modifier = """
        struct Scroller: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .scrollTransition { element, phase in
                        element
                            .opacity(phase == .topLeading ? \(dataModel.variants[0].opacity) : phase == .identity ? \(dataModel.variants[1].opacity) : \(dataModel.variants[2].opacity))
                            .offset(x: phase == .topLeading ? \(dataModel.variants[0].xOffset) : phase == .identity ? \(dataModel.variants[1].xOffset) : \(dataModel.variants[2].xOffset))
                            .offset(y: phase == .topLeading ? \(dataModel.variants[0].yOffset) : phase == .identity ? \(dataModel.variants[1].yOffset) : \(dataModel.variants[2].yOffset))
                            .scaleEffect(phase == .topLeading ? \(dataModel.variants[0].scale) : phase == .identity ? \(dataModel.variants[1].scale) : \(dataModel.variants[2].scale))
                            .blur(radius: phase == .topLeading ? \(dataModel.variants[0].blur) : phase == .identity ? \(dataModel.variants[1].blur) : \(dataModel.variants[2].blur))
                            .saturation(phase == .topLeading ? \(dataModel.variants[0].saturation) : phase == .identity ? \(dataModel.variants[1].saturation) : \(dataModel.variants[2].saturation))
                            .rotation3DEffect(
                                Angle(degrees: phase == .topLeading ? \(dataModel.variants[0].degrees) : phase == .identity ? \(dataModel.variants[1].degrees) : \(dataModel.variants[2].degrees)),
                                axis: (
                                    x: CGFloat(phase == .topLeading ? \(dataModel.variants[0].rotationX) : phase == .identity ? \(dataModel.variants[1].rotationX) : \(dataModel.variants[2].rotationX)),
                                    y: CGFloat(phase == .topLeading ? \(dataModel.variants[0].rotationY) : phase == .identity ? \(dataModel.variants[1].rotationY) : \(dataModel.variants[2].rotationY)),
                                    z: CGFloat(phase == .topLeading ? \(dataModel.variants[0].rotationZ) : phase == .identity ? \(dataModel.variants[1].rotationZ) : \(dataModel.variants[2].rotationZ))
                                ))
                    }
            }
        }
        
        extension View {
            func \(name)() -> some View {
                modifier(Scroller())
            }
        }
        """
        
        return  modifier
    }
}

struct ScrollingRectangle: View {
    var dataModel: DataModel
    
    var body: some View {
        Rectangle()
            .fill(.blue)
            .scrollTransition { content, phase in
                content
                    .opacity(dataModel(\.opacity, for: phase))
                    .offset(x: dataModel(\.xOffset, for: phase))
                    .offset(y: dataModel(\.yOffset, for: phase))
                    .scaleEffect(dataModel(\.scale, for: phase))
                    .blur(radius: (dataModel(\.blur, for: phase)))
                    .saturation(dataModel(\.saturation, for: phase))
                    .rotation3DEffect(
                        Angle(degrees: dataModel(\.degrees, for: phase)),
                        axis: (
                            x: CGFloat(dataModel(\.rotationX, for: phase)),
                            y: CGFloat(dataModel(\.rotationY, for: phase)),
                            z: CGFloat(dataModel(\.rotationZ, for: phase))
                        ))
            }
    }
}

#Preview{
    ContentView()
}
