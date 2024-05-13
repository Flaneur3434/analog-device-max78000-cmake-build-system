cmake_minimum_required(VERSION 3.28.3)
project(demo-project)
enable_language(C CXX ASM)

set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/toolchain/max78000-gcc.cmake)

set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

#
# ---- Demo project
#

set(EXECUTABLE ${PROJECT_NAME}.elf)
file(GLOB PROJ_SRC_FILES CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/src/*.c ${CMAKE_SOURCE_DIR}/src/*.cpp)
set(EXECUTABLE_OUTPUT_PATH ${BUILD_DIR}/${CMAKE_BUILD_TYPE})
set(LINKER_FILE "${CMAKE_SOURCE_DIR}/MAX78000/Libraries/CMSIS/Device/Maxim/MAX78000/Source/GCC/max78000.ld")

add_executable(${EXECUTABLE} ${PROJ_SRC_FILES})

#
# ---- MSDK Stuff
#

# Add TARGET, TARGET_REV definition to CFlags as they are used by the
# preprocessor to select code
set(TARGET MAX78000)
set(TARGET_REV 0x4131)
set(MSDK_C_FLAGS ${CMAKE_C_FLAGS})
set(MSDK_COMPILE_DEFINITIONS  "-DTARGET=${TARGET};-DTARGET_REV=${TARGET_REV}")

# -- CMSIS Library

# link to CMSIS-DSP static library
# Over engineered, but its funny ...
# basically just links to arm_cortexM4l_math.a because MAX78000 doesnt have a
# hardware fpu
set(CMSIS_ROOT "${CMAKE_SOURCE_DIR}/MAX78000/Libraries/CMSIS")
find_library(CMSIS_DSP_LIB "libarm_cortexM4l_math.a" HINTS "${CMSIS_ROOT}/5.9.0/DSP/Lib/")
set(CMSIS_INCLUDES "${CMSIS_ROOT}/Include;${CMSIS_ROOT}/5.9.0/Core/Include;${CMSIS_ROOT}/5.9.0/DSP/Include")

# -- Add object/static libraries

set(MCU_LIBS_ROOT ${CMAKE_SOURCE_DIR}/MAX78000/Libraries)
add_subdirectory(${MCU_LIBS_ROOT}/Boards/MAX78000/FTHR_RevA board)
add_subdirectory(${MCU_LIBS_ROOT}/PeriphDrivers peripherals)
add_subdirectory(${CMSIS_ROOT}/Device/Maxim/MAX78000 startup)

# -- Get Include directories

# Get the include directories for the target.
get_target_property(BOARD_INCLUDES BoardLib INCLUDE_DIRECTORIES)
get_target_property(PERIPHERALS_INCLUDES PeripheralLib INCLUDE_DIRECTORIES)
get_target_property(STARTUP_INCLUDES StartUpLib INCLUDE_DIRECTORIES)
# Construct the compiler string for the include directories.
string(APPEND MSDK_INCLUDE_DIRS "${BOARD_INCLUDES} ${PERIPHERALS_INCLUDES} ${CMSIS_INCLUDES} ${STARTUP_INCLUDES}")

# Need to include the headers to the main executable
target_include_directories(${EXECUTABLE} PUBLIC ${MSDK_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}/include)

#-- Linking rules

target_link_options(${EXECUTABLE} PUBLIC -T "${LINKER_FILE}" --entry "Reset_Handler")
target_link_libraries(
  ${EXECUTABLE}
  PRIVATE StartUpLib
  PRIVATE BoardLib
  PRIVATE PeripheralLib
  PRIVATE ${CMSIS_DSP_LIB}
)

target_compile_definitions(${EXECUTABLE} PUBLIC ${MSDK_COMPILE_DEFINITIONS})
#
# --- C++ stuff
#

Include(FetchContent)
FetchContent_Declare(
  etl
  GIT_REPOSITORY https://github.com/ETLCPP/etl
  GIT_TAG        4b0f9a54fc5b5fd68fcf54a6bdb66da22367173c #tag 20.38.13
)

FetchContent_MakeAvailable(etl)

target_link_libraries(${EXECUTABLE} PRIVATE etl::etl)

#
# ---- Middleware
#

# Create a custom command to use the Cmake toolchain and shit
# Building, Flashing, Strip symbols, ect.
# Each of these should print diagnostic info too

# Optional: Print executable size as part of the post build process
add_custom_command(TARGET ${EXECUTABLE}
  POST_BUILD
  COMMAND ${CMAKE_SIZE_UTIL} "${BUILD_DIR}/${CMAKE_BUILD_TYPE}/${PROJECT_NAME}.elf"
)

# Optional: Create hex, bin and S-Record files after the build
add_custom_command(TARGET ${EXECUTABLE}
  POST_BUILD
  COMMAND ${CMAKE_OBJCOPY} -O binary "${BUILD_DIR}/${CMAKE_BUILD_TYPE}/${PROJECT_NAME}.elf" "${BUILD_DIR}/${CMAKE_BUILD_TYPE}/${PROJECT_NAME}.bin"
)

find_program(CMAKE_OPENOCD "openocd" HINTS "/opt/MaximSDK/Tools/OpenOCD" "Openocd")

# Optional: Create hex, bin and S-Record files after the build
# set(SERIAL_PORT "04440001dcacca9e00000000000000000000000097969906")
# add_custom_command(TARGET ${EXECUTABLE}
#   POST_BUILD
#   COMMAND ${CMAKE_OPENOCD} -s /opt/MaximSDK/Tools/OpenOCD/scripts -f interface/cmsis-dap.cfg -f target/max78000.cfg -c "adapter serial ${SERIAL_PORT}; program ${BUILD_DIR}/${CMAKE_BUILD_TYPE}/${PROJECT_NAME}.bin verify; reset; init; exit"
# )

# add_custom_command(TARGET ${EXECUTABLE}
#   POST_BUILD
#   COMMAND "${CMAKE_C_DEBUGGER} -x .runner_gdb --exec=${BUILD_DIR}/${CMAKE_BUILD_TYPE}/${PROJECT_NAME}.elf"
# )
