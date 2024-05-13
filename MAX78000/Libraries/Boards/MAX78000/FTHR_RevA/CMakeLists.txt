# file: Build system to create a static library for miscellaneous board peripherals

set(THIS_LIBRARY_NAME BoardLib)
get_filename_component(MISC_DRIVER_DIR ../../../MiscDrivers ABSOLUTE)
get_filename_component(PERIPHERAL_DIR ../../../PeriphDrivers/Include/MAX78000 ABSOLUTE)

file(GLOB FONT_SRC_FILES
  ${MISC_DRIVER_DIR}/Display/fonts/*.c
)

file(GLOB BOARD_SRC_FILES
  ${CMAKE_CURRENT_SOURCE_DIR}//Source/*.c
)

set(SRC_FILES
  ${BOARD_SRC_FILES}
  ${FONT_SRC_FILES}
  ${MISC_DRIVER_DIR}/LED/led.c
  ${MISC_DRIVER_DIR}/PushButton/pb.c
  ${MISC_DRIVER_DIR}/Display/tft_ili9341.c
  ${MISC_DRIVER_DIR}/Touchscreen/tsc2046.c
  ${MISC_DRIVER_DIR}/Camera/camera.c
  ${MISC_DRIVER_DIR}/Camera/ov7692.c
  ${MISC_DRIVER_DIR}/Camera/sccb.c
  ${MISC_DRIVER_DIR}/PMIC/max20303.c
  ${MISC_DRIVER_DIR}/CODEC/max9867.c
)

add_library(${THIS_LIBRARY_NAME} STATIC ${SRC_FILES})
target_compile_definitions(${THIS_LIBRARY_NAME} PUBLIC ${MSDK_COMPILE_DEFINITIONS})
target_include_directories(
  ${THIS_LIBRARY_NAME}
  PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}/Include
  ${PERIPHERAL_DIR}
  ${MISC_DRIVER_DIR}/LED
  ${MISC_DRIVER_DIR}/PushButton
  ${MISC_DRIVER_DIR}/Display
  ${MISC_DRIVER_DIR}/Display/fonts
  ${MISC_DRIVER_DIR}/Touchscreen/
  ${MISC_DRIVER_DIR}/Camera
  ${MISC_DRIVER_DIR}/PMIC
  ${MISC_DRIVER_DIR}/CODEC
  ${CMSIS_ROOT}/Device/Maxim/MAX78000/Include
  ${CMSIS_INCLUDES}
)
