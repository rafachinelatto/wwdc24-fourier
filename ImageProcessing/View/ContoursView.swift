//
//  ContoursView.swift
//
//
//  Created by Rafael Antonio Chinelatto on 29/01/24.
//

import SwiftUI

struct ContoursView: View {
  let contours: [Contour]

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ForEach(contours) { contour in
          path(for: contour, in: geometry.frame(in: .local))
            .stroke(Color.gray, lineWidth: 1)
        }
      }
    }
  }

  func path(for contour: Contour, in frame: CGRect) -> Path {
    let scale = scale(for: contour, in: frame)
    let offset = offset(for: scale, in: frame)

    return Path(contour.normalizedPath)
      .applying(CGAffineTransform(translationX: 0, y: -1.0))
      .applying(CGAffineTransform(scaleX: scale, y: -scale))
      .applying(CGAffineTransform(translationX: offset.x, y: offset.y))
  }

  func scale(for contour: Contour, in frame: CGRect) -> CGFloat {
    let frameAspect = frame.width / frame.height
    if frameAspect > contour.aspectRatio {
      return frame.height
    } else {
      return frame.width
    }
  }

  func offset(for scale: CGFloat, in frame: CGRect) -> CGPoint {
    let offsetX = ((frame.width - scale) + frame.minX) / 2.0
    let offsetY = ((frame.height - scale) + frame.minY) / 2.0
    return CGPoint(x: offsetX, y: offsetY)
  }
}
