# file: Build system to create a static library for bootstrapping
set(THIS_LIBRARY_NAME StartUpLib)

get_filename_component(MISC_DRIVER_DIR ../../../../MiscDrivers ABSOLUTE)
get_filename_component(BOARD_INCLUDE_DIR ../../../../Boards/MAX78000/FTHR_RevA/Include ABSOLUTE)

message(${BOARD_INCLUDE_DIR})

set(SRC_FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/Source/heap.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Source/system_max78000.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Source/GCC/startup_max78000.S
  ${MISC_DRIVER_DIR}/stdio.c
)

add_library(${THIS_LIBRARY_NAME} OBJECT ${SRC_FILES})
target_compile_definitions(${THIS_LIBRARY_NAME} PUBLIC ${MSDK_COMPILE_DEFINITIONS})
target_include_directories(
  ${THIS_LIBRARY_NAME}
  PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}/Include
  ${BOARD_INCLUDE_DIR}
  ${MISC_DRIVER_DIR}/Display
  ${MISC_DRIVER_DIR}/Display/fonts
  ${MISC_DRIVER_DIR}/Touchscreen/
  ${MISC_DRIVER_DIR}/LED
  ${MISC_DRIVER_DIR}/PushButton
  ${CMAKE_SOURCE_DIR}/MAX78000/Libraries/PeriphDrivers/Include/MAX78000/
  ${CMSIS_INCLUDES}
)
