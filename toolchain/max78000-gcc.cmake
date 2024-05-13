set(TOOLCHAIN "arm-none-eabi" CACHE INTERNAL "Target triplet")
set(TOOLCHAIN_PREFIX "/usr" CACHE INTERNAL "Toolchain root directory")

# MCU specific options
set(MCU_OPTIONS "-mthumb -mcpu=cortex-m4 -Wa,-mimplicit-it=thumb -MD" CACHE INTERNAL "Platform specific compiler options")

# Float ABI options
set(MFLOAT_ABI "-mfloat-abi=softfp -mfpu=fpv4-sp-d16" CACHE INTERNAL "Platform specific float abi compiler options")

include(${CMAKE_CURRENT_LIST_DIR}/arm-none-eabi-gcc.cmake)
