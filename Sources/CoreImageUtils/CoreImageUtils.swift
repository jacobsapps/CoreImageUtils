@attached(member, names: named(inputImage), named(outputImage), named(kernel), named(getKernel(function:)), named(shaderName()))
public macro ColorKernel() = #externalMacro(module: "CoreImageUtilsMacros", type: "ColorKernelMacro")

@attached(member, names: named(inputImage), named(outputImage), named(kernel), named(getKernel(function:)), named(shaderName()))
public macro SamplerKernel() = #externalMacro(module: "CoreImageUtilsMacros", type: "SamplerKernelMacro")
