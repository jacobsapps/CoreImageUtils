//
//  SamplerKernelMacro.swift
//  
//
//  Created by Jacob Bartlett on 25/03/2024.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SamplerKernelMacro: MemberMacro {
        
    static func inputImageProperty() -> DeclSyntax {
        """
        @objc dynamic public var inputImage: CIImage?
        """
    }
    
    static func outputImageProperty() -> DeclSyntax {
        """
        override public var outputImage: CIImage? {
            guard let input = inputImage else { return nil }
            let sampler = CISampler(image: input)
            return Self.kernel.apply(extent: input.extent,
                                     roiCallback: { $1 },
                                     arguments: [sampler])
        }
        """
    }
    
    static func kernelProperty() -> DeclSyntax {
        """
        static private var kernel: CIKernel = { () -> CIKernel in
            getKernel(function: shaderName())
        }()
        """
    }
    
    static func getKernelFunction() -> DeclSyntax {
        return """
        static private func getKernel(function: String) -> CIKernel {
            let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
            let data = try! Data(contentsOf: url)
            return try! CIKernel(functionName: function, fromMetalLibraryData: data)
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
