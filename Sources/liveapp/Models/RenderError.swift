//
//  RenderError.swift
//  
//
//  Created by Joseph Hinkle on 4/6/21.
//

#if INCLUDE_DEVELOPER_TOOLS
enum RenderError: Error {
    case x
    
    var explanation: String {
        fatalError()
    }
}
#endif
