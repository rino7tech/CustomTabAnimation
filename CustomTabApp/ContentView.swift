//
//  ContentView.swift
//  CustomTabApp
//
//  Created by 伊藤璃乃 on 2024/12/31.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct Home: View {
    @State var selectedtab = "house"

    init() {
        UITabBar.appearance().isHidden = true
    }

    @State var xAxis: CGFloat = 0
    @Namespace var animation

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $selectedtab){
                Color.blue
                    .ignoresSafeArea()
                    .tag("house.fill")
                Color.pink
                    .ignoresSafeArea()
                    .tag("gift.fill")
            }

            HStack(spacing: 0){
                ForEach(tabs,id: \.self){ image in
                    GeometryReader {reader in

                        Button(action:{
                            withAnimation(.spring()){
                                selectedtab = image
                                xAxis = reader.frame(in: .global).minX
                            }
                        },label: {
                            Image(systemName: image)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(selectedtab == image ?  getColor(image: image) : Color.gray)
                                .padding(selectedtab == image ? 15 : 0)
                                .background(Color.white.opacity(selectedtab == image ? 1 : 0)
                                    .clipShape(Circle()))
                                .matchedGeometryEffect(id: image, in: animation)
                                .offset(x: selectedtab == image ? (reader.frame(in: .global).minX - reader.frame(in: .global).midX) : 0, y: selectedtab == image ? -53 : 0)
                        })
                        .onAppear(perform: {
                            if image == tabs.first{
                                xAxis = reader.frame(in: .global).minX
                            }
                        })
                    }
                    .frame(width: 25, height: 30)
                    if image != tabs.last{Spacer(minLength: 0)}
                }
            }
            .padding(.horizontal,90)
            .padding(.vertical, 20)
            .background(Color.white.clipShape(CustomShape(xAxis: xAxis)).cornerRadius(12))
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }

    func getColor(image: String)->Color{
        switch image {
        case "house":
            return Color.blue
        case "gift.fill":
            return Color.pink

        default:
            return Color.blue
        }
    }
}

var tabs = ["house.fill","gift.fill"]

struct CustomShape: Shape {

    var xAxis: CGFloat
    var offset: CGFloat = 15

    var animatableData: CGFloat {
        get { return xAxis }
        set { xAxis = newValue }
    }

    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))

            let center = xAxis + offset
            path.move(to: CGPoint(x: center - 70, y: 0))

            let to1 = CGPoint(x: center, y: 40)
            let control1 = CGPoint(x: center - 35, y: 0)
            let control2 = CGPoint(x: center - 35, y: 40)

            let to2 = CGPoint(x: center + 70, y: 0)
            let control3 = CGPoint(x: center + 35, y: 40)
            let control4 = CGPoint(x: center + 35, y: 0)

            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}

#Preview {
    ContentView()
}
