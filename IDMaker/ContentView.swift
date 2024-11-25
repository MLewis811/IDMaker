//
//  ContentView.swift
//  IDMaker
//
//  Created by Mike Lewis on 1/12/22.
//

import SwiftUI

struct ContentView: View {
    @State private var studentID: String = "12345"
    @State private var name: String = "Johnny Sample"
    @State private var grade: Int = 9
    @State private var year: String = "2021-2022"
    
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State var magAndTrans = MagnificationAndTranslation()
    
    @State private var showingSavePicAlert = false
    
    @State private var showingExporter = false
    
    @State private var pdfDoc: PDFFile? = nil
    
    var imgView: some View {
        StudentIDView(year: year, name: name, studentID: studentID, grade: grade, stuImage: inputImage, mag: magAndTrans)
        //                    .scaleEffect(0.5)
    }
    
    var scaledDownImgView: some View {
        StudentIDView(year: year, name: name, studentID: studentID, grade: grade, stuImage: inputImage, mag: magAndTrans)
            .scaleEffect(3.63 * 72.0 / 1284.0)
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack (alignment: .leading, spacing: 8) {
                Form {
                    //                    TextField("School Year", text: $year)
                    TextField("Name", text: $name)
                    TextField("Student ID", text: $studentID)
                        .keyboardType(.decimalPad)
                    Picker("Grade", selection: $grade) {
                        ForEach(9...12, id: \.self) { gr in
                            Text(String(gr))
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .disableAutocorrection(true)
                .border(.secondary)
                .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.3)
                .padding()
                
                
                imgView
                    .scaleEffect(0.5)
                    .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.6)
                //                .clipped()
                //                .scaleEffect(3.611 * 72.0 / 1281.0)
                
                
                HStack {
                    Button("Pick pic") {
                        showingImagePicker = true
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: $inputImage)
                    }
                    
                    Spacer()
                    Button("Hide pic") {
                        inputImage = nil
                    }
                    Spacer()
                    Button("Save Image") {
                        let image = imgView.snapshot()
                        
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        showingSavePicAlert = true
                        showingExporter = true
//                        let pdfDoc = imgView.makePDFFromView()
                    }
                    .alert("Image was saved to the Photos Library", isPresented: $showingSavePicAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                .padding(.horizontal)
                
            }
//            .fileExporter(isPresented: $showingExporter, document: pdfDoc, contentType: .pdf) { result in
//                switch result {
//                case .success(let url):
//                    print("Saved to \(url)")
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//                
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
