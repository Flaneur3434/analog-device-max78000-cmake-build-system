# Append current directory to CMAKE_MODULE_PATH for making device specific cmake modules visible
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

#---------------------------------------------------------------------------------------
# Set toolchain paths
#---------------------------------------------------------------------------------------
# TOOLCHAIN_INSTALL_DIR is the directory prefix of the location of the toolchain binaries
set(TOOLCHAIN_INSTALL_DIR ${TOOLCHAIN_PREFIX}/${TOOLCHAIN})
set(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_INSTALL_DIR}/bin)
set(TOOLCHAIN_INC_DIR ${TOOLCHAIN_INSTALL_DIR}/${TOOLCHAIN}/include)
set(TOOLCHAIN_LIB_DIR ${TOOLCHAIN_INSTALL_DIR}/${TOOLCHAIN}/lib)

# Perform compiler test with static library
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

#---------------------------------------------------------------------------------------
# Set arm binutil paths
#---------------------------------------------------------------------------------------

find_program(CMAKE_C_COMPILER "${TOOLCHAIN}-gcc" HINTS "${TOOLCHAIN_PREFIX}/bin" "Toolchain c compiler")
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER} CACHE INTERNAL "Toolchain assembler")
find_program(CMAKE_C_COMPILER "${TOOLCHAIN}-g++" HINTS "${TOOLCHAIN_PREFIX}/bin" "Toolchain g++ compiler")
find_program(CMAKE_OBJCOPY "${TOOLCHAIN}-objcopy" HINTS "${TOOLCHAIN_BIN_DIR}" "Toolchain objcopy tool")
find_program(CMAKE_SIZE_UTIL "${TOOLCHAIN}-size" HINTS "${TOOLCHAIN_BIN_DIR}" "Toolchain size tool")
find_program(CMAKE_C_DEBUGGER "${TOOLCHAIN}-gdb" HINTS "${TOOLCHAIN_BIN_DIR}" "C gdb")


#---------------------------------------------------------------------------------------
# Compiler options
#---------------------------------------------------------------------------------------

set(OBJECT_GEN_FLAGS "${OBJECT_OPTIMIZATION_FLAGS} ${OBJECT_WARNING_FLAGS} ${MFLOAT_ABI} ${MCU_OPTIONS}")
set(CMAKE_C_FLAGS   "${OBJECT_GEN_FLAGS} -Wstrict-prototypes -Werror=${C_WARNINGS_AS_ERRORS}" CACHE INTERNAL "C Compiler options")
set(CMAKE_CXX_FLAGS "${OBJECT_GEN_FLAGS} -fno-rtti -fno-exceptions" CACHE INTERNAL "C++ Compiler options")
set(CMAKE_ASM_FLAGS "${OBJECT_GEN_FLAGS} -x assembler-with-cpp " CACHE INTERNAL "ASM Compiler options")
set(CMAKE_EXE_LINKER_FLAGS "-mthumb -mcpu=cortex-m4 ${MFLOAT_ABI} -Wl,--gc-sections,--cref,--print-memory-usage,--sort-section=alignment,--no-warn-rwx-segments --specs=nano.specs --specs=nosys.specs -Wl,-Map=${BUILD_DIR}/${PROJECT_NAME}.map" CACHE INTERNAL "Linker options")

#---------------------------------------------------------------------------------------
# find_package() compatibility
#---------------------------------------------------------------------------------------
set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_INSTALL_DIR}/${TOOLCHAIN} ${CMAKE_PREFIX_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
