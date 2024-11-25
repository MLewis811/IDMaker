//
//  GeneratePDF.swift
//  IDMaker
//
//  Created by Mike Lewis on 1/27/22.
//

import Foundation
import SwiftUI
//import PDFGenerator

func generatePDF() {
    let v1 = UIScrollView(frame: CGRect(x: 0.0,y: 0, width: 100.0, height: 100.0))
    let v2 = UIView(frame: CGRect(x: 0.0,y: 0, width: 100.0, height: 200.0))
    let v3 = UIView(frame: CGRect(x: 0.0,y: 0, width: 100.0, height: 200.0))
    v1.backgroundColor = .red
    v1.contentSize = CGSize(width: 100.0, height: 200.0)
    v2.backgroundColor = .green
    v3.backgroundColor = .blue

//    let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("sample1.pdf"))
    // outputs as Data
//    do {
//        let data = try PDFGenerator.generated(by: [v1, v2, v3])
//        try data.write(to: dst, options: .atomic)
//    } catch (let error) {
//        print(error)
//    }

    // writes to Disk directly.
//    do {
//        try PDFGenerator.generate([v1, v2, v3], to: dst)
//    } catch (let error) {
//        print(error)
//    }
}
