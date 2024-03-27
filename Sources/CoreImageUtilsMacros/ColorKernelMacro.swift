//
//  ColorKernelMacro.swift
//
//
//  Created by Jacob Bartlett on 25/03/2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ColorKernelMacro: MemberMacro {
        
    static func inputImageProperty() -> DeclSyntax {
        """
        @objc dynamic public var inputImage: CIImage?
        """
    }
    
    static func outputImageProperty() -> DeclSyntax {
        """
        override public var outputImage: CIImage? {
            guard let input = inputImage else { return nil }
            return Self.kernel.apply(extent: input.extent, arguments: [input])
        }
        """
    }
    
    static func kernelProperty() -> DeclSyntax {
        """
        static private var kernel: CIColorKernel = { () -> CIColorKernel in
            getKernel(function: shaderName())
        }()
        """
    }
    
    static func getKernelFunction() -> DeclSyntax {
        return """
        static private func getKernel(function: String) -> CIColorKernel {
            let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
            let data = try! Data(contentsOf: url)
            return try! CIColorKernel(functionName: function, fromMetalLibraryData: data)
        }
        """
    }
    
    static func shaderNameFunction() -> DeclSyntax {
        """
        static private func shaderName() -> String {
            let classString = String(NSStringFromClass(self).split(separator: ".").last ?? "")
            return classString.prefix(1).lowercased() + classString.dropFirst()
        }
        """
    }
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        var declarations = [DeclSyntax]()
        declarations.append(Self.inputImageProperty())
        declarations.append(Self.outputImageProperty())
        declarations.append(Self.kernelProperty())
        declarations.append(Self.getKernelFunction())
        declarations.append(Self.shaderNameFunction())
        return declarations
    }
}
