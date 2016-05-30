#******************************************************************************
#  Copyright (c) 2008 - 2012 The Khronos Group Inc.
# 
#  Permission is hereby granted, free of charge, to any person obtaining a
#  copy of this software and/or associated documentation files (the
#  "Materials"), to deal in the Materials without restriction, including
#  without limitation the rights to use, copy, modify, merge, publish,
#  distribute, sublicense, and/or sell copies of the Materials, and to
#  permit persons to whom the Materials are furnished to do so, subject to
#  the following conditions:
# 
#  The above copyright notice and this permission notice shall be included
#  in all copies or substantial portions of the Materials.
# 
#  THE MATERIALS ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
#  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#  MATERIALS OR THE USE OR OTHER DEALINGS IN THE MATERIALS.
# ****************************************************************************

## OpenCL wrapper for Nimrod. For more convenient error checking you can
## use the 'check' template that turns ``TClResult`` into an exception. 


{.deadCodeElim: on.}
when defined(windows):
  {.pragma: climport, stdcall, dynlib: "opencl.dll".}
elif defined(macosx):
  {.pragma: climport, stdcall.}
  {.passL: "-framework OpenCL".}
else:
  {.pragma: climport, stdcall, dynlib: "libOpenCL.so".}
type 
  T_cl_platform_id = object
  T_cl_device_id = object
  T_cl_context = object
  T_cl_command_queue = object
  T_cl_mem = object
  T_cl_program = object
  T_cl_kernel = object
  T_cl_event = object
  T_cl_sampler = object

  Pplatform_id* = ptr T_cl_platform_id
  Pdevice_id* = ptr T_cl_device_id
  Pcontext* = ptr T_cl_context
  Pcommand_queue* = ptr T_cl_command_queue
  Pmem* = ptr T_cl_mem
  Pprogram* = ptr T_cl_program
  Pkernel* = ptr T_cl_kernel
  Pevent* = ptr T_cl_event
  Psampler* = ptr T_cl_sampler
  Tbool* = uint32

# WARNING!  Unlike cl_ types in cl_platform.h, cl_bool is not guaranteed
#  to be the same size as the bool in kernels.  

type 
  Tbitfield* = uint64
  #Tdevice_type* = Tbitfield
  Tplatform_info* = uint32
  Tdevice_info* = uint32
  Tdevice_fp_config* = Tbitfield
  Tdevice_mem_cache_type* = uint32
  Tdevice_local_mem_type* = uint32
  Tdevice_exec_capabilities* = Tbitfield
  Tcommand_queue_properties* = Tbitfield
  Tdevice_partition_property* = int
  Tdevice_affinity_domain* = Tbitfield
  Tcontext_properties* = int
  Tcontext_info* = uint32
  Tcommand_queue_info* = uint32
  Tchannel_order* = uint32
  Tchannel_type* = uint32
  Tmem_flags* = Tbitfield
  Tmem_object_type* = uint32
  Tmem_info* = uint32
  Tmem_migration_flags* = Tbitfield
  Timage_info* = uint32
  Tbuffer_create_type* = uint32
  Taddressing_mode* = uint32
  Tfilter_mode* = uint32
  Tsampler_info* = uint32
  Tmap_flags* = Tbitfield
  Tprogram_info* = uint32
  Tprogram_build_info* = uint32
  Tprogram_binary_type* = uint32
  Tbuild_status* = int32
  Tkernel_info* = uint32
  Tkernel_arg_info* = uint32
  Tkernel_arg_address_qualifier* = uint32
  Tkernel_arg_access_qualifier* = uint32
  Tkernel_arg_type_qualifier* = Tbitfield
  Tkernel_work_group_info* = uint32
  Tevent_info* = uint32
  Tcommand_type* = uint32
  Timage_format* = object 
    image_channel_order*: Tchannel_order
    image_channel_data_type*: Tchannel_type

  Timage_desc* = object 
    image_type*: Tmem_object_type
    image_width*: int
    image_height*: int
    image_depth*: int
    image_array_size*: int
    image_row_pitch*: int
    image_slice_pitch*: int
    num_mip_levels*: uint32
    num_samples*: uint32
    buffer*: Pmem

  Tbuffer_region* = object 
    origin*: int
    size*: int


#  Error Codes 

type
  TClResult* {.size: 4.} = enum
    INVALID_DEVICE_PARTITION_COUNT = -68
    INVALID_LINKER_OPTIONS = -67
    INVALID_COMPILER_OPTIONS = -66
    INVALID_IMAGE_DESCRIPTOR = -65
    INVALID_PROPERTY = -64
    INVALID_GLOBAL_WORK_SIZE = -63
    INVALID_MIP_LEVEL = -62
    INVALID_BUFFER_SIZE = -61
    INVALID_GL_OBJECT = -60
    INVALID_OPERATION = -59
    INVALID_EVENT = -58
    INVALID_EVENT_WAIT_LIST = -57
    INVALID_GLOBAL_OFFSET = -56
    INVALID_WORK_ITEM_SIZE = -55
    INVALID_WORK_GROUP_SIZE = -54
    INVALID_WORK_DIMENSION = -53
    INVALID_KERNEL_ARGS = -52
    INVALID_ARG_SIZE = -51
    INVALID_ARG_VALUE = -50
    INVALID_ARG_INDEX = -49
    INVALID_KERNEL = -48
    INVALID_KERNEL_DEFINITION = -47
    INVALID_KERNEL_NAME = -46
    INVALID_PROGRAM_EXECUTABLE = -45
    INVALID_PROGRAM = -44
    INVALID_BUILD_OPTIONS = -43
    INVALID_BINARY = -42
    INVALID_SAMPLER = -41
    INVALID_IMAGE_SIZE = -40
    INVALID_IMAGE_FORMAT_DESCRIPTOR = -39
    INVALID_MEM_OBJECT = -38
    INVALID_HOST_PTR = -37
    INVALID_COMMAND_QUEUE = -36
    INVALID_QUEUE_PROPERTIES = -35
    INVALID_CONTEXT = -34
    INVALID_DEVICE = -33
    INVALID_PLATFORM = -32
    INVALID_DEVICE_TYPE = -31
    INVALID_VALUE = -30

    KERNEL_ARG_INFO_NOT_AVAILABLE = -19
    DEVICE_PARTITION_FAILED = -18
    LINK_PROGRAM_FAILURE = -17
    LINKER_NOT_AVAILABLE = -16
    COMPILE_PROGRAM_FAILURE = -15
    EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST = -14
    MISALIGNED_SUB_BUFFER_OFFSET = -13
    MAP_FAILURE = -12
    BUILD_PROGRAM_FAILURE = -11
    IMAGE_FORMAT_NOT_SUPPORTED = -10
    IMAGE_FORMAT_MISMATCH = -9
    MEM_COPY_OVERLAP = -8
    PROFILING_INFO_NOT_AVAILABLE = -7
    OUT_OF_HOST_MEMORY = -6
    OUT_OF_RESOURCES = -5
    MEM_OBJECT_ALLOCATION_FAILURE = -4
    COMPILER_NOT_AVAILABLE = -3
    DEVICE_NOT_AVAILABLE = -2
    DEVICE_NOT_FOUND = -1
    SUCCESS = 0
    
  EOpenCL* = object of EIO ## exception raised by 'check'

proc raiseEOpenCL*(x: TClResult) {.noinline.} =
  raise newException(EOpenCL, $x & " " & $int(x))

template check*(a: expr) =
  let y = a
  if y != TClResult.Success: raiseEOpenCL(y)

#  OpenCL Version 

const 
  VERSION_1_0* = 1
  VERSION_1_1* = 1
  VERSION_1_2* = 1

#  cl_bool 

const 
  CL_FALSE* = 0
  CL_TRUE* = 1
  BLOCKING* = CL_TRUE
  NON_BLOCKING* = CL_FALSE

#  cl_platform_info 

const 
  PLATFORM_PROFILE* = 0x00000900
  PLATFORM_VERSION* = 0x00000901
  PLATFORM_NAME* = 0x00000902
  PLATFORM_VENDOR* = 0x00000903
  PLATFORM_EXTENSIONS* = 0x00000904

#  cl_device_type - bitfield 

type
  TDeviceType* = distinct int64

const
  DEVICE_TYPE_DEFAULT* = TDeviceType(1 shl 0)
  DEVICE_TYPE_CPU* = TDeviceType(1 shl 1)
  DEVICE_TYPE_GPU* = TDeviceType(1 shl 2)
  DEVICE_TYPE_ACCELERATOR* = TDeviceType(1 shl 3)
  DEVICE_TYPE_CUSTOM* = TDeviceType(1 shl 4)
  DEVICE_TYPE_ALL* = TDeviceType(0xFFFFFFFF)

#  cl_device_info 

const 
  DEVICE_TYPE* = 0x00001000
  DEVICE_VENDOR_ID* = 0x00001001
  DEVICE_MAX_COMPUTE_UNITS* = 0x00001002
  DEVICE_MAX_WORK_ITEM_DIMENSIONS* = 0x00001003
  DEVICE_MAX_WORK_GROUP_SIZE* = 0x00001004
  DEVICE_MAX_WORK_ITEM_SIZES* = 0x00001005
  DEVICE_PREFERRED_VECTOR_WIDTH_CHAR* = 0x00001006
  DEVICE_PREFERRED_VECTOR_WIDTH_SHORT* = 0x00001007
  DEVICE_PREFERRED_VECTOR_WIDTH_INT* = 0x00001008
  DEVICE_PREFERRED_VECTOR_WIDTH_LONG* = 0x00001009
  DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT* = 0x0000100A
  DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE* = 0x0000100B
  DEVICE_MAX_CLOCK_FREQUENCY* = 0x0000100C
  DEVICE_ADDRESS_BITS* = 0x0000100D
  DEVICE_MAX_READ_IMAGE_ARGS* = 0x0000100E
  DEVICE_MAX_WRITE_IMAGE_ARGS* = 0x0000100F
  DEVICE_MAX_MEM_ALLOC_SIZE* = 0x00001010
  DEVICE_IMAGE2D_MAX_WIDTH* = 0x00001011
  DEVICE_IMAGE2D_MAX_HEIGHT* = 0x00001012
  DEVICE_IMAGE3D_MAX_WIDTH* = 0x00001013
  DEVICE_IMAGE3D_MAX_HEIGHT* = 0x00001014
  DEVICE_IMAGE3D_MAX_DEPTH* = 0x00001015
  DEVICE_IMAGE_SUPPORT* = 0x00001016
  DEVICE_MAX_PARAMETER_SIZE* = 0x00001017
  DEVICE_MAX_SAMPLERS* = 0x00001018
  DEVICE_MEM_BASE_ADDR_ALIGN* = 0x00001019
  DEVICE_MIN_DATA_TYPE_ALIGN_SIZE* = 0x0000101A
  DEVICE_SINGLE_FP_CONFIG* = 0x0000101B
  DEVICE_GLOBAL_MEM_CACHE_TYPE* = 0x0000101C
  DEVICE_GLOBAL_MEM_CACHELINE_SIZE* = 0x0000101D
  DEVICE_GLOBAL_MEM_CACHE_SIZE* = 0x0000101E
  DEVICE_GLOBAL_MEM_SIZE* = 0x0000101F
  DEVICE_MAX_CONSTANT_BUFFER_SIZE* = 0x00001020
  DEVICE_MAX_CONSTANT_ARGS* = 0x00001021
  DEVICE_LOCAL_MEM_TYPE* = 0x00001022
  DEVICE_LOCAL_MEM_SIZE* = 0x00001023
  DEVICE_ERROR_CORRECTION_SUPPORT* = 0x00001024
  DEVICE_PROFILING_TIMER_RESOLUTION* = 0x00001025
  DEVICE_ENDIAN_LITTLE* = 0x00001026
  DEVICE_AVAILABLE* = 0x00001027
  DEVICE_COMPILER_AVAILABLE* = 0x00001028
  DEVICE_EXECUTION_CAPABILITIES* = 0x00001029
  DEVICE_QUEUE_PROPERTIES* = 0x0000102A
  DEVICE_NAME* = 0x0000102B
  DEVICE_VENDOR* = 0x0000102C
  DRIVER_VERSION* = 0x0000102D
  DEVICE_PROFILE* = 0x0000102E
  DEVICE_VERSION* = 0x0000102F
  DEVICE_EXTENSIONS* = 0x00001030
  DEVICE_PLATFORM* = 0x00001031
  DEVICE_DOUBLE_FP_CONFIG* = 0x00001032

#  0x1033 reserved for CL_DEVICE_HALF_FP_CONFIG 

const 
  DEVICE_PREFERRED_VECTOR_WIDTH_HALF* = 0x00001034
  DEVICE_HOST_UNIFIED_MEMORY* = 0x00001035
  DEVICE_NATIVE_VECTOR_WIDTH_CHAR* = 0x00001036
  DEVICE_NATIVE_VECTOR_WIDTH_SHORT* = 0x00001037
  DEVICE_NATIVE_VECTOR_WIDTH_INT* = 0x00001038
  DEVICE_NATIVE_VECTOR_WIDTH_LONG* = 0x00001039
  DEVICE_NATIVE_VECTOR_WIDTH_FLOAT* = 0x0000103A
  DEVICE_NATIVE_VECTOR_WIDTH_DOUBLE* = 0x0000103B
  DEVICE_NATIVE_VECTOR_WIDTH_HALF* = 0x0000103C
  DEVICE_OPENCL_C_VERSION* = 0x0000103D
  DEVICE_LINKER_AVAILABLE* = 0x0000103E
  DEVICE_BUILT_IN_KERNELS* = 0x0000103F
  DEVICE_IMAGE_MAX_BUFFER_SIZE* = 0x00001040
  DEVICE_IMAGE_MAX_ARRAY_SIZE* = 0x00001041
  DEVICE_PARENT_DEVICE* = 0x00001042
  DEVICE_PARTITION_MAX_SUB_DEVICES* = 0x00001043
  DEVICE_PARTITION_PROPERTIES* = 0x00001044
  DEVICE_PARTITION_AFFINITY_DOMAIN* = 0x00001045
  DEVICE_PARTITION_TYPE* = 0x00001046
  DEVICE_REFERENCE_COUNT* = 0x00001047
  DEVICE_PREFERRED_INTEROP_USER_SYNC* = 0x00001048
  DEVICE_PRINTF_BUFFER_SIZE* = 0x00001049
  DEVICE_IMAGE_PITCH_ALIGNMENT* = 0x0000104A
  DEVICE_IMAGE_BASE_ADDRESS_ALIGNMENT* = 0x0000104B

#  cl_device_fp_config - bitfield 

const 
  FP_DENORM* = (1 shl 0)
  FP_INF_NAN* = (1 shl 1)
  FP_ROUND_TO_NEAREST* = (1 shl 2)
  FP_ROUND_TO_ZERO* = (1 shl 3)
  FP_ROUND_TO_INF* = (1 shl 4)
  FP_FMA* = (1 shl 5)
  FP_SOFT_FLOAT* = (1 shl 6)
  FP_CORRECTLY_ROUNDED_DIVIDE_SQRT* = (1 shl 7)

#  cl_device_mem_cache_type 

const 
  NONE* = 0x00000000
  READ_ONLY_CACHE* = 0x00000001
  READ_WRITE_CACHE* = 0x00000002

#  cl_device_local_mem_type 

const 
  LOCAL* = 0x00000001
  GLOBAL* = 0x00000002

#  cl_device_exec_capabilities - bitfield 

const 
  EXEC_KERNEL* = (1 shl 0)
  EXEC_NATIVE_KERNEL* = (1 shl 1)

#  cl_command_queue_properties - bitfield 

const 
  QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE* = (1 shl 0)
  QUEUE_PROFILING_ENABLE* = (1 shl 1)

#  cl_context_info  

const 
  CONTEXT_REFERENCE_COUNT* = 0x00001080
  CONTEXT_DEVICES* = 0x00001081
  CONTEXT_PROPERTIES* = 0x00001082
  CONTEXT_NUM_DEVICES* = 0x00001083

#  cl_context_properties 

const 
  CONTEXT_PLATFORM* = 0x00001084
  CONTEXT_INTEROP_USER_SYNC* = 0x00001085

#  cl_device_partition_property 

const 
  DEVICE_PARTITION_EQUALLY* = 0x00001086
  DEVICE_PARTITION_BY_COUNTS* = 0x00001087
  DEVICE_PARTITION_BY_COUNTS_LIST_END* = 0x00000000
  DEVICE_PARTITION_BY_AFFINITY_DOMAIN* = 0x00001088

# cl_device_affinity_domain 

const 
  DEVICE_AFFINITY_DOMAIN_NUMA* = (1 shl 0)
  DEVICE_AFFINITY_DOMAIN_L4_CACHE* = (1 shl 1)
  DEVICE_AFFINITY_DOMAIN_L3_CACHE* = (1 shl 2)
  DEVICE_AFFINITY_DOMAIN_L2_CACHE* = (1 shl 3)
  DEVICE_AFFINITY_DOMAIN_L1_CACHE* = (1 shl 4)
  DEVICE_AFFINITY_DOMAIN_NEXT_PARTITIONABLE* = (1 shl 5)

# cl_command_queue_info 

const 
  QUEUE_CONTEXT* = 0x00001090
  QUEUE_DEVICE* = 0x00001091
  QUEUE_REFERENCE_COUNT* = 0x00001092
  QUEUE_PROPERTIES* = 0x00001093

# cl_mem_flags - bitfield 

const 
  MEM_READ_WRITE* = (1 shl 0)
  MEM_WRITE_ONLY* = (1 shl 1)
  MEM_READ_ONLY* = (1 shl 2)
  MEM_USE_HOST_PTR* = (1 shl 3)
  MEM_ALLOC_HOST_PTR* = (1 shl 4)
  MEM_COPY_HOST_PTR* = (1 shl 5)

# reserved                                         (1 << 6)    

const 
  MEM_HOST_WRITE_ONLY* = (1 shl 7)
  MEM_HOST_READ_ONLY* = (1 shl 8)
  MEM_HOST_NO_ACCESS* = (1 shl 9)

# cl_mem_migration_flags - bitfield 

const 
  MIGRATE_MEM_OBJECT_HOST* = (1 shl 0)
  MIGRATE_MEM_OBJECT_CONTENT_UNDEFINED* = (1 shl 1)

# cl_channel_order 

const 
  CL_R* = 0x000010B0
  CL_A* = 0x000010B1
  CL_RG* = 0x000010B2
  CL_RA* = 0x000010B3
  CL_RGB* = 0x000010B4
  CL_RGBA* = 0x000010B5
  CL_BGRA* = 0x000010B6
  CL_ARGB* = 0x000010B7
  INTENSITY* = 0x000010B8
  LUMINANCE* = 0x000010B9
  CL_Rx* = 0x000010BA
  CL_RGx* = 0x000010BB
  CL_RGBx* = 0x000010BC
  DEPTH* = 0x000010BD
  DEPTH_STENCIL* = 0x000010BE

# cl_channel_type 

const 
  CL_SNORM_INT8* = 0x000010D0
  CL_SNORM_INT16* = 0x000010D1
  CL_UNORM_INT8* = 0x000010D2
  CL_UNORM_INT16* = 0x000010D3
  CL_UNORM_SHORT_565* = 0x000010D4
  CL_UNORM_SHORT_555* = 0x000010D5
  CL_UNORM_INT_101010* = 0x000010D6
  CL_SIGNED_INT8* = 0x000010D7
  CL_SIGNED_INT16* = 0x000010D8
  CL_SIGNED_INT32* = 0x000010D9
  CL_UNSIGNED_INT8* = 0x000010DA
  CL_UNSIGNED_INT16* = 0x000010DB
  CL_UNSIGNED_INT32* = 0x000010DC
  CL_HALF_FLOAT* = 0x000010DD
  CL_FLOAT* = 0x000010DE
  CL_UNORM_INT24* = 0x000010DF

# cl_mem_object_type 

const 
  MEM_OBJECT_BUFFER* = 0x000010F0
  MEM_OBJECT_IMAGE2D* = 0x000010F1
  MEM_OBJECT_IMAGE3D* = 0x000010F2
  MEM_OBJECT_IMAGE2D_ARRAY* = 0x000010F3
  MEM_OBJECT_IMAGE1D* = 0x000010F4
  MEM_OBJECT_IMAGE1D_ARRAY* = 0x000010F5
  MEM_OBJECT_IMAGE1D_BUFFER* = 0x000010F6

# cl_mem_info 

const 
  MEM_TYPE* = 0x00001100
  MEM_FLAGS* = 0x00001101
  MEM_SIZE* = 0x00001102
  MEM_HOST_PTR* = 0x00001103
  MEM_MAP_COUNT* = 0x00001104
  MEM_REFERENCE_COUNT* = 0x00001105
  MEM_CONTEXT* = 0x00001106
  MEM_ASSOCIATED_MEMOBJECT* = 0x00001107
  MEM_OFFSET* = 0x00001108

# cl_image_info 

const 
  IMAGE_FORMAT* = 0x00001110
  IMAGE_ELEMENT_SIZE* = 0x00001111
  IMAGE_ROW_PITCH* = 0x00001112
  IMAGE_SLICE_PITCH* = 0x00001113
  IMAGE_WIDTH* = 0x00001114
  IMAGE_HEIGHT* = 0x00001115
  IMAGE_DEPTH* = 0x00001116
  IMAGE_ARRAY_SIZE* = 0x00001117
  IMAGE_BUFFER* = 0x00001118
  IMAGE_NUM_MIP_LEVELS* = 0x00001119
  IMAGE_NUM_SAMPLES* = 0x0000111A

# cl_addressing_mode 

const 
  ADDRESS_NONE* = 0x00001130
  ADDRESS_CLAMP_TO_EDGE* = 0x00001131
  ADDRESS_CLAMP* = 0x00001132
  ADDRESS_REPEAT* = 0x00001133
  ADDRESS_MIRRORED_REPEAT* = 0x00001134

# cl_filter_mode 

const 
  FILTER_NEAREST* = 0x00001140
  FILTER_LINEAR* = 0x00001141

# cl_sampler_info 

const 
  SAMPLER_REFERENCE_COUNT* = 0x00001150
  SAMPLER_CONTEXT* = 0x00001151
  SAMPLER_NORMALIZED_COORDS* = 0x00001152
  SAMPLER_ADDRESSING_MODE* = 0x00001153
  SAMPLER_FILTER_MODE* = 0x00001154

# cl_map_flags - bitfield 

const 
  MAP_READ* = (1 shl 0)
  MAP_WRITE* = (1 shl 1)
  MAP_WRITE_INVALIDATE_REGION* = (1 shl 2)

# cl_program_info 

const 
  PROGRAM_REFERENCE_COUNT* = 0x00001160
  PROGRAM_CONTEXT* = 0x00001161
  PROGRAM_NUM_DEVICES* = 0x00001162
  PROGRAM_DEVICES* = 0x00001163
  PROGRAM_SOURCE* = 0x00001164
  PROGRAM_BINARY_SIZES* = 0x00001165
  PROGRAM_BINARIES* = 0x00001166
  PROGRAM_NUM_KERNELS* = 0x00001167
  PROGRAM_KERNEL_NAMES* = 0x00001168

# cl_program_build_info 

const 
  PROGRAM_BUILD_STATUS* = 0x00001181
  PROGRAM_BUILD_OPTIONS* = 0x00001182
  PROGRAM_BUILD_LOG* = 0x00001183
  PROGRAM_BINARY_TYPE* = 0x00001184

# cl_program_binary_type 

const 
  PROGRAM_BINARY_TYPE_NONE* = 0x00000000
  PROGRAM_BINARY_TYPE_COMPILED_OBJECT* = 0x00000001
  PROGRAM_BINARY_TYPE_LIBRARY* = 0x00000002
  PROGRAM_BINARY_TYPE_EXECUTABLE* = 0x00000004

# cl_build_status 

const 
  BUILD_SUCCESS* = 0
  BUILD_NONE* = - 1
  BUILD_ERROR* = - 2
  BUILD_IN_PROGRESS* = - 3

# cl_kernel_info 

const 
  KERNEL_FUNCTION_NAME* = 0x00001190
  KERNEL_NUM_ARGS* = 0x00001191
  KERNEL_REFERENCE_COUNT* = 0x00001192
  KERNEL_CONTEXT* = 0x00001193
  KERNEL_PROGRAM* = 0x00001194
  KERNEL_ATTRIBUTES* = 0x00001195

# cl_kernel_arg_info 

const 
  KERNEL_ARG_ADDRESS_QUALIFIER* = 0x00001196
  KERNEL_ARG_ACCESS_QUALIFIER* = 0x00001197
  KERNEL_ARG_TYPE_NAME* = 0x00001198
  KERNEL_ARG_TYPE_QUALIFIER* = 0x00001199
  KERNEL_ARG_NAME* = 0x0000119A

# cl_kernel_arg_address_qualifier 

const 
  KERNEL_ARG_ADDRESS_GLOBAL* = 0x0000119B
  KERNEL_ARG_ADDRESS_LOCAL* = 0x0000119C
  KERNEL_ARG_ADDRESS_CONSTANT* = 0x0000119D
  KERNEL_ARG_ADDRESS_PRIVATE* = 0x0000119E

# cl_kernel_arg_access_qualifier 

const 
  KERNEL_ARG_ACCESS_READ_ONLY* = 0x000011A0
  KERNEL_ARG_ACCESS_WRITE_ONLY* = 0x000011A1
  KERNEL_ARG_ACCESS_READ_WRITE* = 0x000011A2
  KERNEL_ARG_ACCESS_NONE* = 0x000011A3

# cl_kernel_arg_type_qualifer 

const 
  KERNEL_ARG_TYPE_NONE* = 0
  KERNEL_ARG_TYPE_CONST* = (1 shl 0)
  KERNEL_ARG_TYPE_RESTRICT* = (1 shl 1)
  KERNEL_ARG_TYPE_VOLATILE* = (1 shl 2)

# cl_kernel_work_group_info 

const 
  KERNEL_WORK_GROUP_SIZE* = 0x000011B0
  KERNEL_COMPILE_WORK_GROUP_SIZE* = 0x000011B1
  KERNEL_LOCAL_MEM_SIZE* = 0x000011B2
  KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE* = 0x000011B3
  KERNEL_PRIVATE_MEM_SIZE* = 0x000011B4
  KERNEL_GLOBAL_WORK_SIZE* = 0x000011B5

# cl_event_info  

const 
  EVENT_COMMAND_QUEUE* = 0x000011D0
  EVENT_COMMAND_TYPE* = 0x000011D1
  EVENT_REFERENCE_COUNT* = 0x000011D2
  EVENT_COMMAND_EXECUTION_STATUS* = 0x000011D3
  EVENT_CONTEXT* = 0x000011D4

# cl_command_type 

const 
  COMMAND_NDRANGE_KERNEL* = 0x000011F0
  COMMAND_TASK* = 0x000011F1
  COMMAND_NATIVE_KERNEL* = 0x000011F2
  COMMAND_READ_BUFFER* = 0x000011F3
  COMMAND_WRITE_BUFFER* = 0x000011F4
  COMMAND_COPY_BUFFER* = 0x000011F5
  COMMAND_READ_IMAGE* = 0x000011F6
  COMMAND_WRITE_IMAGE* = 0x000011F7
  COMMAND_COPY_IMAGE* = 0x000011F8
  COMMAND_COPY_IMAGE_TO_BUFFER* = 0x000011F9
  COMMAND_COPY_BUFFER_TO_IMAGE* = 0x000011FA
  COMMAND_MAP_BUFFER* = 0x000011FB
  COMMAND_MAP_IMAGE* = 0x000011FC
  COMMAND_UNMAP_MEM_OBJECT* = 0x000011FD
  COMMAND_MARKER* = 0x000011FE
  COMMAND_ACQUIRE_GL_OBJECTS* = 0x000011FF
  COMMAND_RELEASE_GL_OBJECTS* = 0x00001200
  COMMAND_READ_BUFFER_RECT* = 0x00001201
  COMMAND_WRITE_BUFFER_RECT* = 0x00001202
  COMMAND_COPY_BUFFER_RECT* = 0x00001203
  COMMAND_USER* = 0x00001204
  COMMAND_BARRIER* = 0x00001205
  COMMAND_MIGRATE_MEM_OBJECTS* = 0x00001206
  COMMAND_FILL_BUFFER* = 0x00001207
  COMMAND_FILL_IMAGE* = 0x00001208

# command execution status 

const 
  COMPLETE* = 0x00000000
  RUNNING* = 0x00000001
  SUBMITTED* = 0x00000002
  QUEUED* = 0x00000003

# cl_buffer_create_type  

const 
  BUFFER_CREATE_TYPE_REGION* = 0x00001220

type
  Tprofiling_info* {.size: 4.} = enum
    PROFILING_COMMAND_QUEUED = 0x00001280
    PROFILING_COMMAND_SUBMIT = 0x00001281
    PROFILING_COMMAND_START = 0x00001282
    PROFILING_COMMAND_END = 0x00001283

# Platform API 

proc getPlatformIDs*(num_entries: uint32; platforms: ptr Pplatform_id; 
                     num_platforms: ptr uint32): TClResult {.
    importc: "clGetPlatformIDs", climport.}
proc getPlatformInfo*(platform: Pplatform_id; param_name: Tplatform_info; 
                      param_value_size: int; param_value: pointer; 
                      param_value_size_ret: ptr int): TClResult {.
    importc: "clGetPlatformInfo", climport.}
# Device APIs 

proc getDeviceIDs*(platform: Pplatform_id; device_type: Tdevice_type; 
                   num_entries: uint32; devices: ptr Pdevice_id; 
                   num_devices: ptr uint32): TClResult {.
    importc: "clGetDeviceIDs", climport.}
proc getDeviceInfo*(device: Pdevice_id; param_name: Tdevice_info; 
                    param_value_size: int; param_value: pointer; 
                    param_value_size_ret: ptr int): TClResult {.
    importc: "clGetDeviceInfo", climport.}
proc createSubDevices*(in_device: Pdevice_id; 
                       properties: ptr Tdevice_partition_property; 
                       num_devices: uint32; out_devices: ptr Pdevice_id; 
                       num_devices_ret: ptr uint32): TClResult {.
    importc: "clCreateSubDevices", climport.}
proc retainDevice*(device: Pdevice_id): TClResult {.
    importc: "clRetainDevice", climport.}
proc releaseDevice*(device: Pdevice_id): TClResult {.
    importc: "clReleaseDevice", climport.}
# Context APIs  

type 
  TCreateContextCb* = proc (a2: cstring; a3: pointer; a4: int; a5: pointer) {.
      stdcall.}

proc createContext*(properties: ptr Tcontext_properties; num_devices: uint32; 
                    devices: ptr Pdevice_id; pfn_notify: TCreateContextCb; 
                    user_data: pointer; errcode_ret: ptr TClResult): Pcontext {.
    importc: "clCreateContext", climport.}
proc createContextFromType*(properties: ptr Tcontext_properties; 
                            device_type: Tdevice_type; 
                            pfn_notify: TCreateContextCb; user_data: pointer; 
                            errcode_ret: ptr TClResult): Pcontext {.
    importc: "clCreateContextFromType", climport.}
proc retainContext*(context: Pcontext): TClResult {.
    importc: "clRetainContext", climport.}
proc releaseContext*(context: Pcontext): TClResult {.
    importc: "clReleaseContext", climport.}
proc getContextInfo*(context: Pcontext; param_name: Tcontext_info; 
                     param_value_size: int; param_value: pointer; 
                     param_value_size_ret: ptr int): TClResult {.
    importc: "clGetContextInfo", climport.}
# Command Queue APIs 

proc createCommandQueue*(context: Pcontext; device: Pdevice_id; 
                         properties: Tcommand_queue_properties; 
                         errcode_ret: ptr TClResult): Pcommand_queue {.
    importc: "clCreateCommandQueue", climport.}
proc retainCommandQueue*(command_queue: Pcommand_queue): TClResult {.
    importc: "clRetainCommandQueue", climport.}
proc releaseCommandQueue*(command_queue: Pcommand_queue): TClResult {.
    importc: "clReleaseCommandQueue", climport.}
proc getCommandQueueInfo*(command_queue: Pcommand_queue; 
                          param_name: Tcommand_queue_info; 
                          param_value_size: int; param_value: pointer; 
                          param_value_size_ret: ptr int): TClResult {.
    importc: "clGetCommandQueueInfo", climport.}
# Memory Object APIs 

proc createBuffer*(context: Pcontext; flags: Tmem_flags; size: int; 
                   host_ptr: pointer; errcode_ret: ptr TClResult): Pmem {.
    importc: "clCreateBuffer", climport.}
proc createSubBuffer*(buffer: Pmem; flags: Tmem_flags; 
                      buffer_create_type: Tbuffer_create_type; 
                      buffer_create_info: pointer; errcode_ret: ptr TClResult): Pmem {.
    importc: "clCreateSubBuffer", climport.}
proc createImage*(context: Pcontext; flags: Tmem_flags; 
                  image_format: ptr Timage_format; image_desc: ptr Timage_desc; 
                  host_ptr: pointer; errcode_ret: ptr TClResult): Pmem {.
    importc: "clCreateImage", climport.}
proc retainMemObject*(memobj: Pmem): TClResult {.
    importc: "clRetainMemObject", climport.}
proc releaseMemObject*(memobj: Pmem): TClResult {.
    importc: "clReleaseMemObject", climport.}
proc getSupportedImageFormats*(context: Pcontext; flags: Tmem_flags; 
                               image_type: Tmem_object_type; 
                               num_entries: uint32; 
                               image_formats: ptr Timage_format; 
                               num_image_formats: ptr uint32): TClResult {.
    importc: "clGetSupportedImageFormats", climport.}
proc getMemObjectInfo*(memobj: Pmem; param_name: Tmem_info; 
                       param_value_size: int; param_value: pointer; 
                       param_value_size_ret: ptr int): TClResult {.
    importc: "clGetMemObjectInfo", climport.}
proc getImageInfo*(image: Pmem; param_name: Timage_info; param_value_size: int; 
                   param_value: pointer; param_value_size_ret: ptr int): TClResult {.
    importc: "clGetImageInfo", climport.}
type 
  TMemObjectDestructorCb* = proc (memobj: Pmem; user_data: pointer) {.stdcall.}

proc setMemObjectDestructorCallback*(memobj: Pmem; 
                                     pfn_notify: TMemObjectDestructorCb; 
                                     user_data: pointer): TClResult {.
    importc: "clSetMemObjectDestructorCallback", climport.}
# Sampler APIs 

proc createSampler*(context: Pcontext; normalized_coords: Tbool; 
                    addressing_mode: Taddressing_mode; 
                    filter_mode: Tfilter_mode; errcode_ret: ptr TClResult): Psampler {.
    importc: "clCreateSampler", climport.}
proc retainSampler*(sampler: Psampler): TClResult {.
    importc: "clRetainSampler", climport.}
proc releaseSampler*(sampler: Psampler): TClResult {.
    importc: "clReleaseSampler", climport.}
proc getSamplerInfo*(sampler: Psampler; param_name: Tsampler_info; 
                     param_value_size: int; param_value: pointer; 
                     param_value_size_ret: ptr int): TClResult {.
    importc: "clGetSamplerInfo", climport.}
# Program Object APIs  

proc createProgramWithSource*(context: Pcontext; count: uint32; 
                              strings: cstringArray; lengths: ptr int; 
                              errcode_ret: ptr TClResult): Pprogram {.
    importc: "clCreateProgramWithSource", climport.}
proc createProgramWithBinary*(context: Pcontext; num_devices: uint32; 
                              device_list: ptr Pdevice_id; lengths: ptr int; 
                              binaries: ptr ptr cuchar; 
                              binary_status: ptr int32; errcode_ret: ptr TClResult): Pprogram {.
    importc: "clCreateProgramWithBinary", climport.}
proc createProgramWithBuiltInKernels*(context: Pcontext; num_devices: uint32; 
                                      device_list: ptr Pdevice_id; 
                                      kernel_names: cstring; 
                                      errcode_ret: ptr TClResult): Pprogram {.
    importc: "clCreateProgramWithBuiltInKernels", climport.}
proc retainProgram*(program: Pprogram): TClResult {.
    importc: "clRetainProgram", climport.}
proc releaseProgram*(program: Pprogram): TClResult {.
    importc: "clReleaseProgram", climport.}

type 
  TProgramCb* = proc (program: Pprogram; user_data: pointer) {.stdcall.}

proc buildProgram*(program: Pprogram; num_devices: uint32; 
                   device_list: ptr Pdevice_id; options: cstring; 
                   pfn_notify: TProgramCb; user_data: pointer): TClResult {.
    importc: "clBuildProgram", climport.}
proc compileProgram*(program: Pprogram; num_devices: uint32; 
                     device_list: ptr Pdevice_id; options: cstring; 
                     num_input_headers: uint32; input_headers: ptr Pprogram; 
                     header_include_names: cstringArray; pfn_notify: TProgramCb; 
                     user_data: pointer): TClResult {.
    importc: "clCompileProgram", climport.}
proc linkProgram*(context: Pcontext; num_devices: uint32; 
                  device_list: ptr Pdevice_id; options: cstring; 
                  num_input_programs: uint32; input_programs: ptr Pprogram; 
                  pfn_notify: TProgramCb; user_data: pointer; 
                  errcode_ret: ptr TClResult): Pprogram {.
    importc: "clLinkProgram", climport.}
proc unloadPlatformCompiler*(platform: Pplatform_id): TClResult {.
    importc: "clUnloadPlatformCompiler", climport.}
proc getProgramInfo*(program: Pprogram; param_name: Tprogram_info; 
                     param_value_size: int; param_value: pointer; 
                     param_value_size_ret: ptr int): TClResult {.
    importc: "clGetProgramInfo", climport.}
proc getProgramBuildInfo*(program: Pprogram; device: Pdevice_id; 
                          param_name: Tprogram_build_info; 
                          param_value_size: int; param_value: pointer; 
                          param_value_size_ret: ptr int): TClResult {.
    importc: "clGetProgramBuildInfo", climport.}
# Kernel Object APIs 

proc createKernel*(program: Pprogram; kernel_name: cstring; 
                   errcode_ret: ptr TClResult): Pkernel {.
    importc: "clCreateKernel", climport.}
proc createKernelsInProgram*(program: Pprogram; num_kernels: uint32; 
                             kernels: ptr Pkernel; num_kernels_ret: ptr uint32): TClResult {.
    importc: "clCreateKernelsInProgram", climport.}
proc retainKernel*(kernel: Pkernel): TClResult {.importc: "clRetainKernel", 
    climport.}
proc releaseKernel*(kernel: Pkernel): TClResult {.
    importc: "clReleaseKernel", climport.}
proc setKernelArg*(kernel: Pkernel; arg_index: uint32; arg_size: int; 
                   arg_value: pointer): TClResult {.
    importc: "clSetKernelArg", climport.}
proc getKernelInfo*(kernel: Pkernel; param_name: Tkernel_info; 
                    param_value_size: int; param_value: pointer; 
                    param_value_size_ret: ptr int): TClResult {.
    importc: "clGetKernelInfo", climport.}
proc getKernelArgInfo*(kernel: Pkernel; arg_indx: uint32; 
                       param_name: Tkernel_arg_info; param_value_size: int; 
                       param_value: pointer; param_value_size_ret: ptr int): TClResult {.
    importc: "clGetKernelArgInfo", climport.}
proc getKernelWorkGroupInfo*(kernel: Pkernel; device: Pdevice_id; 
                             param_name: Tkernel_work_group_info; 
                             param_value_size: int; param_value: pointer; 
                             param_value_size_ret: ptr int): TClResult {.
    importc: "clGetKernelWorkGroupInfo", climport.}
# Event Object APIs 

proc waitForEvents*(num_events: uint32; event_list: ptr Pevent): TClResult {.
    importc: "clWaitForEvents", climport.}
proc getEventInfo*(event: Pevent; param_name: Tevent_info; 
                   param_value_size: int; param_value: pointer; 
                   param_value_size_ret: ptr int): TClResult {.
    importc: "clGetEventInfo", climport.}
proc createUserEvent*(context: Pcontext; errcode_ret: ptr TClResult): Pevent {.
    importc: "clCreateUserEvent", climport.}
proc retainEvent*(event: Pevent): TClResult {.importc: "clRetainEvent", 
    climport.}
proc releaseEvent*(event: Pevent): TClResult {.importc: "clReleaseEvent", 
    climport.}
proc setUserEventStatus*(event: Pevent; execution_status: int32): TClResult {.
    importc: "clSetUserEventStatus", climport.}

type 
  TEventCb* = proc (a2: Pevent; a3: int32; a4: pointer) {.stdcall.}

proc setEventCallback*(event: Pevent; command_exec_callback_type: int32; 
                       pfn_notify: TEventCb; user_data: pointer): TClResult {.
    importc: "clSetEventCallback", climport.}
# Profiling APIs 

proc getEventProfilingInfo*(event: Pevent; param_name: Tprofiling_info; 
                            param_value_size: int; param_value: pointer; 
                            param_value_size_ret: ptr int): TClResult {.
    importc: "clGetEventProfilingInfo", climport.}
# Flush and Finish APIs 

proc flush*(command_queue: Pcommand_queue): TClResult {.importc: "clFlush", 
    climport.}
proc finish*(command_queue: Pcommand_queue): TClResult {.
    importc: "clFinish", climport.}
# Enqueued Commands APIs 

proc enqueueReadBuffer*(command_queue: Pcommand_queue; buffer: Pmem; 
                        blocking_read: Tbool; offset: int; size: int; 
                        theptr: pointer; num_events_in_wait_list: uint32; 
                        event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueReadBuffer", climport.}
proc enqueueReadBufferRect*(command_queue: Pcommand_queue; buffer: Pmem; 
                            blocking_read: Tbool; buffer_offset: ptr int; 
                            host_offset: ptr int; region: ptr int; 
                            buffer_row_pitch: int; buffer_slice_pitch: int; 
                            host_row_pitch: int; host_slice_pitch: int; 
                            theptr: pointer; num_events_in_wait_list: uint32; 
                            event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueReadBufferRect", climport.}
proc enqueueWriteBuffer*(command_queue: Pcommand_queue; buffer: Pmem; 
                         blocking_write: Tbool; offset: int; size: int; 
                         theptr: pointer; num_events_in_wait_list: uint32; 
                         event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueWriteBuffer", climport.}
proc enqueueWriteBufferRect*(command_queue: Pcommand_queue; buffer: Pmem; 
                             blocking_write: Tbool; buffer_offset: ptr int; 
                             host_offset: ptr int; region: ptr int; 
                             buffer_row_pitch: int; buffer_slice_pitch: int; 
                             host_row_pitch: int; host_slice_pitch: int; 
                             theptr: pointer; num_events_in_wait_list: uint32; 
                             event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueWriteBufferRect", climport.}
proc enqueueFillBuffer*(command_queue: Pcommand_queue; buffer: Pmem; 
                        pattern: pointer; pattern_size: int; offset: int; 
                        size: int; num_events_in_wait_list: uint32; 
                        event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueFillBuffer", climport.}
proc enqueueCopyBuffer*(command_queue: Pcommand_queue; src_buffer: Pmem; 
                        dst_buffer: Pmem; src_offset: int; dst_offset: int; 
                        size: int; num_events_in_wait_list: uint32; 
                        event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueCopyBuffer", climport.}
proc enqueueCopyBufferRect*(command_queue: Pcommand_queue; src_buffer: Pmem; 
                            dst_buffer: Pmem; src_origin: ptr int; 
                            dst_origin: ptr int; region: ptr int; 
                            src_row_pitch: int; src_slice_pitch: int; 
                            dst_row_pitch: int; dst_slice_pitch: int; 
                            num_events_in_wait_list: uint32; 
                            event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueCopyBufferRect", climport.}
proc enqueueReadImage*(command_queue: Pcommand_queue; image: Pmem; 
                       blocking_read: Tbool; origin: array[3, ptr int]; 
                       region: array[3, ptr int]; row_pitch: int; 
                       slice_pitch: int; theptr: pointer; 
                       num_events_in_wait_list: uint32; 
                       event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueReadImage", climport.}
proc enqueueWriteImage*(command_queue: Pcommand_queue; image: Pmem; 
                        blocking_write: Tbool; origin: array[3, ptr int]; 
                        region: array[3, ptr int]; input_row_pitch: int; 
                        input_slice_pitch: int; theptr: pointer; 
                        num_events_in_wait_list: uint32; 
                        event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueWriteImage", climport.}
proc enqueueFillImage*(command_queue: Pcommand_queue; image: Pmem; 
                       fill_color: pointer; origin: array[3, ptr int]; 
                       region: array[3, ptr int]; 
                       num_events_in_wait_list: uint32; 
                       event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueFillImage", climport.}
proc enqueueCopyImage*(command_queue: Pcommand_queue; src_image: Pmem; 
                       dst_image: Pmem; src_origin: array[3, ptr int]; 
                       dst_origin: array[3, ptr int]; region: array[3, ptr int]; 
                       num_events_in_wait_list: uint32; 
                       event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueCopyImage", climport.}
proc enqueueCopyImageToBuffer*(command_queue: Pcommand_queue; src_image: Pmem; 
                               dst_buffer: Pmem; src_origin: array[3, ptr int]; 
                               region: array[3, ptr int]; dst_offset: int; 
                               num_events_in_wait_list: uint32; 
                               event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueCopyImageToBuffer", climport.}
proc enqueueCopyBufferToImage*(command_queue: Pcommand_queue; src_buffer: Pmem; 
                               dst_image: Pmem; src_offset: int; 
                               dst_origin: array[3, ptr int]; 
                               region: array[3, ptr int]; 
                               num_events_in_wait_list: uint32; 
                               event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueCopyBufferToImage", climport.}
proc enqueueMapBuffer*(command_queue: Pcommand_queue; buffer: Pmem; 
                       blocking_map: Tbool; map_flags: Tmap_flags; offset: int; 
                       size: int; num_events_in_wait_list: uint32; 
                       event_wait_list: ptr Pevent; event: ptr Pevent; 
                       errcode_ret: ptr TClResult): pointer {.
    importc: "clEnqueueMapBuffer", climport.}
proc enqueueMapImage*(command_queue: Pcommand_queue; image: Pmem; 
                      blocking_map: Tbool; map_flags: Tmap_flags; 
                      origin: array[3, ptr int]; region: array[3, ptr int]; 
                      image_row_pitch: ptr int; image_slice_pitch: ptr int; 
                      num_events_in_wait_list: uint32; 
                      event_wait_list: ptr Pevent; event: ptr Pevent; 
                      errcode_ret: ptr TClResult): pointer {.
    importc: "clEnqueueMapImage", climport.}
proc enqueueUnmapMemObject*(command_queue: Pcommand_queue; memobj: Pmem; 
                            mapped_ptr: pointer; 
                            num_events_in_wait_list: uint32; 
                            event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueUnmapMemObject", climport.}
proc enqueueMigrateMemObjects*(command_queue: Pcommand_queue; 
                               num_mem_objects: uint32; mem_objects: ptr Pmem; 
                               flags: Tmem_migration_flags; 
                               num_events_in_wait_list: uint32; 
                               event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueMigrateMemObjects", climport.}
proc enqueueNDRangeKernel*(command_queue: Pcommand_queue; kernel: Pkernel; 
                           work_dim: uint32; global_work_offset: ptr int; 
                           global_work_size: ptr int; local_work_size: ptr int; 
                           num_events_in_wait_list: uint32; 
                           event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueNDRangeKernel", climport.}
proc enqueueTask*(command_queue: Pcommand_queue; kernel: Pkernel; 
                  num_events_in_wait_list: uint32; event_wait_list: ptr Pevent; 
                  event: ptr Pevent): TClResult {.importc: "clEnqueueTask", 
    climport.}

type 
  TUserCb* = proc (a2: pointer) {.stdcall.}

proc enqueueNativeKernel*(command_queue: Pcommand_queue; user_func: TUserCb; 
                          args: pointer; cb_args: int; num_mem_objects: uint32; 
                          mem_list: ptr Pmem; args_mem_loc: ptr pointer; 
                          num_events_in_wait_list: uint32; 
                          event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueNativeKernel", climport.}
proc enqueueMarkerWithWaitList*(command_queue: Pcommand_queue; 
                                num_events_in_wait_list: uint32; 
                                event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueMarkerWithWaitList", climport.}
proc enqueueBarrierWithWaitList*(command_queue: Pcommand_queue; 
                                 num_events_in_wait_list: uint32; 
                                 event_wait_list: ptr Pevent; event: ptr Pevent): TClResult {.
    importc: "clEnqueueBarrierWithWaitList", climport.}
# Extension function access
# 
#  Returns the extension function address for the given function name,
#  or NULL if a valid function can not be found.  The client must
#  check to make sure the address is not NULL, before using or 
#  calling the returned function address.
# 

proc getExtensionFunctionAddressForPlatform*(platform: Pplatform_id; 
    func_name: cstring): pointer {.importc: "clGetExtensionFunctionAddressForPlatform", 
                                   climport.}
# Deprecated OpenCL 1.1 APIs

proc createImage2D*(context: Pcontext; flags: Tmem_flags; 
                    image_format: ptr Timage_format; image_width: int; 
                    image_height: int; image_row_pitch: int; host_ptr: pointer; 
                    errcode_ret: ptr TClResult): Pmem {.
    importc: "clCreateImage2D", climport.}
proc createImage3D*(context: Pcontext; flags: Tmem_flags; 
                    image_format: ptr Timage_format; image_width: int; 
                    image_height: int; image_depth: int; image_row_pitch: int; 
                    image_slice_pitch: int; host_ptr: pointer; 
                    errcode_ret: ptr TClResult): Pmem {.
    importc: "clCreateImage3D", climport.}
proc enqueueMarker*(command_queue: Pcommand_queue; event: ptr Pevent): TClResult {.
    importc: "clEnqueueMarker", climport.}
proc enqueueWaitForEvents*(command_queue: Pcommand_queue; num_events: uint32; 
                           event_list: ptr Pevent): TClResult {.
    importc: "clEnqueueWaitForEvents", climport.}
proc enqueueBarrier*(command_queue: Pcommand_queue): TClResult {.
    importc: "clEnqueueBarrier", climport.}
proc unloadCompiler*(): TClResult {.importc: "clUnloadCompiler", 
                                climport.}
proc getExtensionFunctionAddress*(func_name: cstring): pointer {.
    importc: "clGetExtensionFunctionAddress", climport.}
