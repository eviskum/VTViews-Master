//
//  SideMenuViewModifier.swift
//  VTViews-Master
//
//  Created by Esben Viskum on 14/06/2021.
//

import SwiftUI

public struct VTSideMenu<MenuContent: View>: ViewModifier {
    public enum SideMenuWidth {
        case relative(CGFloat)
        case absolute(CGFloat)
    }
    
    @Binding var isShowing: Bool
    var contentOpacityLevel: Double
    var contentOpacityColor: Color
    var moveContent = true
    var sideMenuWidthSetting: SideMenuWidth
    private let menuContent: () -> MenuContent
    
    public init(
        isShowing: Binding<Bool>,
        contentOpacityLevel: Double = 0.5,
        contentOpacityColor: Color = .gray,
        moveContent: Bool = true,
        sideMenuWidthSetting: SideMenuWidth = .relative(0.7),
        @ViewBuilder menuContent: @escaping () -> MenuContent)
    {
        self._isShowing = isShowing
        self.contentOpacityLevel = contentOpacityLevel
        self.contentOpacityColor = contentOpacityColor
        self.moveContent = moveContent
        self.sideMenuWidthSetting = sideMenuWidthSetting
        self.menuContent = menuContent
    }

    public func body(content: Content) -> some View {
        let drag = DragGesture().onEnded { event in
            if event.location.x < 200 && abs(event.translation.height) < 50 && abs(event.translation.width) > 50 {
                withAnimation {
                    self.isShowing = event.translation.width > 0
                }
            }
        }
        
        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                content
                    .disabled(isShowing)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: (self.isShowing && self.moveContent) ? sideMenuWidth(setting: sideMenuWidthSetting, screenWidth: geometry.size.width) : 0)

                if self.isShowing {
                    contentOpacityColor
                        .opacity(!self.moveContent ? contentOpacityLevel : 0.0)
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }
                }

                menuContent()
                    .frame(width: sideMenuWidth(setting: sideMenuWidthSetting, screenWidth: geometry.size.width))
                    .transition(.move(edge: .leading))
                    .offset(x: self.isShowing ? 0 : -sideMenuWidth(setting: sideMenuWidthSetting, screenWidth: geometry.size.width))
            }.gesture(drag)
        }
    }
    
    func sideMenuWidth(setting: SideMenuWidth, screenWidth: CGFloat) -> CGFloat {
        switch setting {
        case .absolute(let absoluteSize):
            return absoluteSize
        case .relative(let relativeSize):
            return screenWidth * relativeSize
        }
    }
    
}

extension View {
    func vtSideMenu<MenuContent: View>(isShowing: Binding<Bool>, @ViewBuilder menuContent: @escaping () -> MenuContent) -> some View {
        self.modifier(VTSideMenu(isShowing: isShowing, menuContent: menuContent))
    }
}
