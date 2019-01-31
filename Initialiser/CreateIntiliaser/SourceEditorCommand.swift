//
//  SourceEditorCommand.swift
//  CreateIntiliaser
//
//  Created by Kunal Kumar on 04/11/18.
//  Copyright © 2018 Kunal Kumar. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        var lastSelectedLine = XCSourceTextPosition()
        if let endSelectedLine = (invocation.buffer.selections.lastObject) as? XCSourceTextPosition {
            lastSelectedLine = XCSourceTextPosition(line: endSelectedLine.line + 1, column: endSelectedLine.column)
        }
        var initialiserDictionary = [String: String]()
        for selection in invocation.buffer.selections {
            guard let selection = selection as? XCSourceTextRange else {
                continue
            }
            for lineIndex in selection.start.line ... selection.end.line {
                guard let line = invocation.buffer.lines[lineIndex] as? String else { continue }
                let newLine = line.replacingOccurrences(of: "\n", with: "")
                if newLine.hasPrefix("let") {
                    continue
                }
                let variable = newLine.replacingOccurrences(of: "var", with: "").replacingOccurrences(of: ":", with: "").split(separator: " ")
                initialiserDictionary[String(describing: variable.first)] = String(describing: variable.last)
                
            }
        }
        
        var initCode = "init("
        _ = initialiserDictionary.map({ (variableName, dataType) in
            initCode += "\(variableName): \(dataType), "
        })
        
        let endIndex = initCode.index(initCode.endIndex, offsetBy: -2)
        initCode = String(initCode [ ..<endIndex ])
        initCode += ") {"
        
        _ = initialiserDictionary.map({ (variableName, _) in
            initCode += "\n\t"
            initCode += "self.\(variableName) = \(variableName.replacingOccurrences(of: ")", with: "")))"
        })
        initCode += "\n}"
        initCode = initCode.replacingOccurrences(of: "Optional(\"", with: "").replacingOccurrences(of: "\")", with: "")
        invocation.buffer.lines.add("\n")
        invocation.buffer.lines.add(initCode)
        
        completionHandler(nil)
    }
    
}
