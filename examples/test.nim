
import opencl

# OpenCL kernel to perform an element-wise addition 
const 
  programSource = """__kernel
void vecadd(__global int *A,
            __global int *B,
            __global int *C)
{
   int idx = get_global_id(0);
   C[idx] = A[idx] + B[idx];
}
"""

const elements = 2048
type PArr = ptr array[elements, int32]

proc main() =
  var A, B, C: PArr
  let datasize = sizeof(int32)*elements

  A = cast[PArr](alloc(datasize))
  B = cast[PArr](alloc(datasize))
  C = cast[PArr](alloc(datasize))

  for i in 0'i32 .. < elements.int32:
    A[i] = i
    B[i] = i

  var numPlatforms: uint32
  check getPlatformIDs(0, nil, addr numPlatforms)

  # Allocate enough space for each platform
  var platforms: array[64, PPlatformId]
  
  check getPlatformIDs(numPlatforms, cast[ptr Pplatform_id](addr platforms[0]), nil)

  var numDevices: uint32
  check getDeviceIDs(platforms[0], DEVICE_TYPE_ALL, 0, nil, addr numDevices)

  # Allocate enough space for each device
  var devices: array[64, PDeviceId]

  # Fill in the devices
  check getDeviceIDs(platforms[0], DEVICE_TYPE_ALL,        
                     numDevices, cast[ptr PDeviceId](addr devices[0]), nil)

  # Create a context and associate it with the devices
  var status: TClResult
  var context = createContext(nil, numDevices,
                     cast[ptr PDeviceId](addr devices[0]), nil, nil, addr status)
  check status

  # Create a command queue and associate it with the device 
  var cmdQueue = createCommandQueue(context, devices[0], 0, addr status)
  check status

  # Create a buffer object that will contain the data from the host array A
  var bufA = createBuffer(context, MEM_READ_ONLY, datasize, nil, addr status)
  check status

  # Create a buffer object that will contain the data 
  # from the host array B
  var bufB = createBuffer(context, MEM_READ_ONLY, datasize, nil, addr status)
  check status

  # Create a buffer object that will hold the output data
  var bufC = createBuffer(context, MEM_WRITE_ONLY, datasize, nil, addr status) 
  check status
  
  # Write input array A to the device buffer bufferA
  check enqueueWriteBuffer(cmdQueue, bufA, CL_FALSE, 0, datasize, A, 0, nil, nil)
  
  # Write input array B to the device buffer bufferB
  check enqueueWriteBuffer(cmdQueue, bufB, CL_FALSE, 0, datasize, B, 0, nil, nil)

  # Create a program with source code
  var lines = [cstring(programSource)]
  var program = createProgramWithSource(context, 1, 
      cast[cstringArray](addr lines), nil, addr status)
  check status

  # Build (compile) the program for the device
  check buildProgram(program, numDevices, cast[ptr PDeviceId](addr devices),
                     nil, nil, nil)

  # Create the vector addition kernel
  var kernel = createKernel(program, "vecadd", addr status)
  check status

  # Associate the input and output buffers with the kernel 
  check setKernelArg(kernel, 0, sizeof(Pmem), addr bufA)
  check setKernelArg(kernel, 1, sizeof(Pmem), addr bufB)
  check setKernelArg(kernel, 2, sizeof(Pmem), addr bufC)

  # Define an index space (global work size) of work items for execution. A
  # workgroup size (local work size) is not required, but can be used.
  var globalWorkSize: array[1, int]

  # There are 'elements' work-items 
  globalWorkSize[0] = elements

  # Execute the kernel for execution
  check enqueueNDRangeKernel(cmdQueue, kernel, 1, nil, 
                             cast[ptr int](addr globalWorkSize), nil, 0, nil, nil)

  # Read the device output buffer to the host output array
  check enqueueReadBuffer(cmdQueue, bufC, CL_TRUE, 0, datasize, C, 0, nil, nil)

  # Verify the output
  var result = true
  for i in 0.. < elements:
    if C[i] != i+i:
      result = false
      break
  echo "output is ", result

  check releaseKernel(kernel)
  check releaseProgram(program)
  check releaseCommandQueue(cmdQueue)
  check releaseMemObject(bufA)
  check releaseMemObject(bufB)
  check releaseMemObject(bufC)
  check releaseContext(context)

  dealloc(A)
  dealloc(B)
  dealloc(C)

main()
