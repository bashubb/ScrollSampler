//
//  ContentView.swift
//  ScrollSampler
//
//  Created by HubertMac on 30/10/2023.
//



import SwiftUI

struct ContentView: View {
    @State private var dataModel = DataModel()
    
    var body: some View {
        NavigationSplitView {
            Form {
                ForEach(dataModel.variants) {variant in
                    @Bindable var variant = variant
                    Section(variant.id){
                        LabeledContent("Opacity"){
                            Slider(value: $variant.opacity, in: 0...1)
                        }
                        LabeledContent("Sclae"){
                            Slider(value: $variant.scale, in: 0...3)
                        }
                        LabeledContent("xOffset"){
                            Slider(value: $variant.xOffset, in: -1000...1000)
                        }
                        LabeledContent("yOffset"){
                            Slider(value: $variant.yOffset, in: 0...1000)
                        }
                        LabeledContent("blur"){
                            Slider(value: $variant.blur, in: 0...50)
                        }
                        LabeledContent("saturation"){
                            Slider(value: $variant.saturation, in: 0...1)
                        }
                        LabeledContent("Rotation degrees"){
                            Slider(value: $variant.degrees, in: -180...180)
                        }
                        LabeledContent("Rotation x axis"){
                            Slider(value: $variant.rotationX, in: 0...1)
                        }
                        LabeledContent("Rotation y axis"){
                            Slider(value: $variant.rotationY, in: 0...1)
                        }
                        LabeledContent("Rotation z axis"){
                            Slider(value: $variant.rotationZ, in: 0...1)
                        }
                        
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dataModel = DataModel()
                    } label: {
                        Text("Reset")
                            .foregroundStyle(Color.white)
                            .padding(6)
                            .background(Color.red.opacity(0.7), in: RoundedRectangle(cornerRadius: 8))
                    }

                    
                }
            }
        } detail: {
            ScrollView {
                VStack {
                    ForEach(0..<100) {  i in
                        Rectangle()
                            .fill(.blue)
                            .frame(height: 100)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(dataModel(\.opacity, for: phase))
                                    .offset(x: dataModel(\.xOffset, for: phase))
                                    .offset(y: dataModel(\.yOffset, for: phase))
                                    .scaleEffect(dataModel(\.scale, for: phase))
                                    .blur(radius:(dataModel(\.blur, for: phase)))
                                    .saturation(dataModel(\.saturation, for: phase))
                                    .rotation3DEffect(Angle(degrees: dataModel(\.degrees, for: phase)),
                                                      axis: (x: CGFloat(dataModel(\.rotationX, for: phase)),
                                                             y: CGFloat(dataModel(\.rotationY, for: phase)),
                                                             z: CGFloat(dataModel(\.rotationZ, for: phase))))
                                                            
                                    
                            }
                    }
                }
                .padding()
            }
            .toolbar(.hidden)
            .ignoresSafeArea()
            
        }
        
    }
}

#Preview {
    ContentView()
}
