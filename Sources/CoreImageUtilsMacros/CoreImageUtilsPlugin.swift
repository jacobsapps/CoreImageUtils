//
//  CoreImageUtilsPlugin.swift
//  
//
//  Created by Jacob Bartlett on 25/03/2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct CoreImageUtilsPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ColorKernelMacro.self,
        SamplerKernelMacro.self
    ]
}
