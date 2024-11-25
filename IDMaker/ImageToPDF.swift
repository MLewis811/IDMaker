//
//  ImageToPDF.swift
//  IDMaker
//
//  Created by Mike Lewis on 1/26/22.
//

import UniformTypeIdentifiers
import SwiftUI
import PDFKit

extension UIView {
    func makePDFFromView() -> PDFFile {
        let pdfDocument = PDFDocument()
            
        let image = self.asImage()
        let pdfPage = PDFPage(image: image)
        pdfDocument.insert(pdfPage!, at: 0)
        return PDFFile(pdf: pdfDocument)
    }
}


struct PDFFile: FileDocument {
    static var readableContentTypes: [UTType] = [.pdf]
    
    var pdfData: PDFDocument
    
    init(pdf: PDFDocument) {
        pdfData = pdf
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            pdfData = PDFDocument(data: data)!
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: pdfData.dataRepresentation()!)
    }
}
