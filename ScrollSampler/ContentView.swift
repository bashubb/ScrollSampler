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
    @State private var modifierName = ""
    @State private var customModifier = ""
    
    let formatter: NumberFormatter
    
    var body: some View {
        NavigationSplitView {
            VStack(spacing:0) {
                HStack {
                    
                    Button {
                        dataModel = DataModel()
                    } label: {
                        Text("Reset")
                            .foregroundStyle(Color.white)
                            .padding(6)
                            .background(Color.red.opacity(0.7), in: RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Button {
                        vertical.toggle()
                    } label: {
                        Text("Change Orientation")
                            .foregroundStyle(Color.white)
                            .padding(6)
                            .background(Color.green.opacity(0.8), in: RoundedRectangle(cornerRadius: 8))
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                
                Form {
                    Button ("Edge opacity") {
                        dataModel.variants[0].opacity = 0.0
                        dataModel.variants[2].opacity = 0.0
                    }
                    ForEach(dataModel.variants) { variant in
                        @Bindable var variant = variant
                        Section(variant.id) {
                            
                            Text(formatter.string(for:variant.opacity) ?? "")
                            LabeledContent("Opacity") {
                                Slider(value: $variant.opacity, in: 0...1)
                            }
                            LabeledContent("Scale") {
                                Slider(value: $variant.scale, in: 0...3)
                            }
                            LabeledContent("xOffset") {
                                Slider(value: $variant.xOffset, in: -1000...1000)
                            }
                            LabeledContent("yOffset") {
                                Slider(value: $variant.yOffset, in: 0...1000)
                            }
                            LabeledContent("blur") {
                                Slider(value: $variant.blur, in: 0...50)
                            }
                            LabeledContent("saturation") {
                                Slider(value: $variant.saturation, in: 0...1)
                            }
                            LabeledContent("Rotation degrees") {
                                Slider(value: $variant.degrees, in: -180...180)
                            }
                            LabeledContent("Rotation x axis") {
                                Slider(value: $variant.rotationX, in: 0...1)
                            }
                            LabeledContent("Rotation y axis") {
                                Slider(value: $variant.rotationY, in: 0...1)
                            }
                            LabeledContent("Rotation z axis") {
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
                            .opacity(\(dataModel.variants[0].opacity))
                            .opacity(\(dataModel.variants[1].opacity))
                            .opacity(\(dataModel.variants[2].opacity))
                            .offset(x: \(dataModel.variants[0].xOffset))
                            .offset(x: \(dataModel.variants[1].xOffset))
                            .offset(x: \(dataModel.variants[2].xOffset))
                            .offset(y: \(dataModel.variants[0].yOffset))
                            .offset(y: \(dataModel.variants[1].yOffset))
                            .offset(y: \(dataModel.variants[2].yOffset))
                            .scaleEffectoffset(\(dataModel.variants[0].scale))
                            .scaleEffectoffset(\(dataModel.variants[1].scale))
                            .scaleEffectoffset(\(dataModel.variants[2].scale))
                            .blur(radius: \(dataModel.variants[0].blur))
                            .blur(radius: \(dataModel.variants[1].blur))
                            .blur(radius: \(dataModel.variants[2].blur))
                            .saturation(\(dataModel.variants[0].saturation))
                            .saturation(\(dataModel.variants[1].saturation))
                            .saturation(\(dataModel.variants[2].saturation))
                            .rotation3DEffect(
                                Angle(degrees: dataModel(\(dataModel.variants[0].degrees)),
                                axis: (
                                    x: CGFloat(dataModel(\(dataModel.variants[0].rotationX)),
                                    y: CGFloat(dataModel(\(dataModel.variants[0].rotationY)),
                                    z: CGFloat(dataModel(\(dataModel.variants[0].rotationZ))
                                ))
                            .rotation3DEffect(
                                Angle(degrees: dataModel(\(dataModel.variants[1].degrees)),
                                axis: (
                                    x: CGFloat(dataModel(\(dataModel.variants[1].rotationX)),
                                    y: CGFloat(dataModel(\(dataModel.variants[1].rotationY)),
                                    z: CGFloat(dataModel(\(dataModel.variants[1].rotationZ))
                                ))
                            .rotation3DEffect(
                                Angle(degrees: dataModel(\(dataModel.variants[2].degrees)),
                                axis: (
                                    x: CGFloat(dataModel(\(dataModel.variants[2].rotationX)),
                                    y: CGFloat(dataModel(\(dataModel.variants[2].rotationY)),
                                    z: CGFloat(dataModel(\(dataModel.variants[2].rotationZ))
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
