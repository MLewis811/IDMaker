//
//  StudentIDView.swift
//  IDMaker
//
//  Created by Mike Lewis on 1/12/22.
//

import SwiftUI

struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ViewGeometry: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ViewSizeKey.self, value: geometry.size)
        }
    }
}

class MagnificationAndTranslation: ObservableObject {
    @Published var currentMag = 0.0
    @Published var finalMag = 0.7
    @Published var currentOffset = CGSize.zero
    @Published var finalOffset = CGSize.zero
}

struct StudentIDView: View {
    var year: String
    var name: String
    var studentID: String
    var grade: Int
    var stuImage: UIImage?
    
    @ObservedObject var mag: MagnificationAndTranslation
    
    let width = 1284.0
    let height = 841.0
    let scaleFactor = 0.5
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("blankIDTemplate_22")
            
            if let pic = stuImage {
                Image(uiImage: pic)
                    .scaleEffect(mag.finalMag + mag.currentMag)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { amt in
                                mag.currentMag = amt - 1
                            }
                            .onEnded { amt in
                                mag.finalMag += mag.currentMag
                                mag.currentMag = 0
                            }
                    )
                    .offset(mag.currentOffset)
                    .offset(mag.finalOffset)
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { value in mag.currentOffset = value.translation }
                            .onEnded { value in
                                mag.finalOffset.width += mag.currentOffset.width
                                mag.finalOffset.height += mag.currentOffset.height
                                mag.currentOffset = .zero
                            }
                    )
                    .frame(width: 314, height: 425)
                    .clipped()
                    .offset(x: width * 0.12, y: height * 0.115)

            }
            
            VStack(alignment: .center) {
                generateBarcode(from: studentID)
                Text(name)
                    .font(.system(size: 56, weight: .heavy, design: .default))
                    .foregroundColor(.black)
            }
            .offset(x: width * 0.06, y: height * 0.72)
            
            
            Text("Gr \(grade, format: .number)")
                .font(.system(size: 56, weight: .heavy, design: .default))
                .foregroundColor(.black)
                .padding(.horizontal)
                .offset(x: width * 0.82, y: height * 0.82)
            
        }
//        .frame(width: width * scaleFactor, height: height * scaleFactor, alignment: .center)
//        .clipped()
//        .scaleEffect(3.611 * 72.0 / 1281.0)
    }
    
    
    func generateBarcode(from string: String) -> Image? {
        
        guard !string.isEmpty else { return nil }
        
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 2)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                let context = CIContext()
                
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let uiImage = UIImage(cgImage: cgimg)
                    
                    return Image(uiImage: cropImage(uiImage: uiImage))
                }
            }
        }
        
        return nil
    }
    
    func cropImage(uiImage sourceImage: UIImage) -> UIImage {
        // Determines the x,y coordinate of a centered
        // sideLength by sideLength square
        let sourceSize = sourceImage.size
        let xOffset = sourceSize.width * 0.1
        let yOffset = sourceSize.height * 0.2
        
        // The cropRect is the rect of the image to keep,
        // in this case centered
        let cropRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: sourceSize.width - (2.0 * xOffset),
            height: sourceSize.height - (2.0 * yOffset)
        ).integral
        
        // Center crop the image
        let sourceCGImage = sourceImage.cgImage!
        let croppedCGImage = sourceCGImage.cropping(
            to: cropRect
        )!
        
        // Use the cropped cgImage to initialize a cropped
        // UIImage with the same image scale and orientation
        let croppedImage = UIImage(
            cgImage: croppedCGImage,
            scale: sourceImage.imageRendererFormat.scale,
            orientation: sourceImage.imageOrientation
        )
        
        return croppedImage
    }
}

struct StudentIDView_Previews: PreviewProvider {
    static var previews: some View {
        StudentIDView(year: "2021-2022",
                      name: "Johnny Example",
                      studentID: "22124", grade: 12, mag: MagnificationAndTranslation())
            .previewInterfaceOrientation(.portrait)
            .preferredColorScheme(.dark)
    }
}
