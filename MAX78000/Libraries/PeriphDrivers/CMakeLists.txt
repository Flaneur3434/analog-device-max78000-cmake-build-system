# file: Build system to create a static library for board peripherals

set(PERIPH_DRIVER_DIR ${CMAKE_CURRENT_SOURCE_DIR})

set(PD_LIBRARY_VARIANT "spi-v2_softfp")
set(PERIPH_DRIVER_BUILD_DIR ${BUILD_DIR}/Peripherals-${PD_LIBRARY_VARIANT})

set(THIS_LIBRARY_NAME PeripheralLib)

set(SRC_DIR ${PERIPH_DRIVER_DIR}/Source)
set(INC_DIR ${PERIPH_DRIVER_DIR}/Include/MAX78000)
file(GLOB SRC_FILES
  ${SRC_DIR}/SYS/mxc_assert.c
  ${SRC_DIR}/SYS/mxc_delay.c
  ${SRC_DIR}/SYS/mxc_lock.c
  ${SRC_DIR}/SYS/nvic_table.c
  ${SRC_DIR}/SYS/pins_ai85.c
  ${SRC_DIR}/SYS/sys_ai85.c
  ${SRC_DIR}/ADC/adc_me17.c
  ${SRC_DIR}/ADC/adc_reva.c
  ${SRC_DIR}/AES/aes_me17.c
  ${SRC_DIR}/AES/aes_revb.c
  ${SRC_DIR}/CAMERAIF/cameraif_ai85.c
  ${SRC_DIR}/CAMERAIF/cameraif_reva.c
  ${SRC_DIR}/CRC/crc_me17.c
  ${SRC_DIR}/CRC/crc_reva.c
  ${SRC_DIR}/DMA/dma_me17.c
  ${SRC_DIR}/DMA/dma_reva.c
  ${SRC_DIR}/FLC/flc_common.c
  ${SRC_DIR}/FLC/flc_me17.c
  ${SRC_DIR}/FLC/flc_reva.c
  ${SRC_DIR}/GPIO/gpio_common.c
  ${SRC_DIR}/GPIO/gpio_ai85.c
  ${SRC_DIR}/GPIO/gpio_reva.c
  ${SRC_DIR}/I2C/i2c_me17.c
  ${SRC_DIR}/I2C/i2c_reva.c
  ${SRC_DIR}/I2S/i2s_ai85.c
  ${SRC_DIR}/I2S/i2s_reva.c
  ${SRC_DIR}/ICC/icc_me17.c
  ${SRC_DIR}/ICC/icc_reva.c
  ${SRC_DIR}/LP/lp_ai85.c
  ${SRC_DIR}/LPCMP/lpcmp_ai85.c
  ${SRC_DIR}/LPCMP/lpcmp_reva.c
  ${SRC_DIR}/OWM/owm_me17.c
  ${SRC_DIR}/OWM/owm_reva.c
  ${SRC_DIR}/PT/pt_ai85.c
  ${SRC_DIR}/PT/pt_reva.c
  ${SRC_DIR}/RTC/rtc_me17.c
  ${SRC_DIR}/RTC/rtc_reva.c
  ${SRC_DIR}/SEMA/sema_me17.c
  ${SRC_DIR}/SEMA/sema_reva.c
  ${SRC_DIR}/SPI/spi_me17.c
  ${SRC_DIR}/SPI/spi_reva1.c
  ${SRC_DIR}/TRNG/trng_ai85.c
  ${SRC_DIR}/TRNG/trng_revb.c
  ${SRC_DIR}/TMR/tmr_common.c
  ${SRC_DIR}/TMR/tmr_ai85.c
  ${SRC_DIR}/TMR/tmr_revb.c
  ${SRC_DIR}/UART/uart_ai85.c
  ${SRC_DIR}/UART/uart_common.c
  ${SRC_DIR}/UART/uart_revb.c
  ${SRC_DIR}/WDT/wdt_common.c
  ${SRC_DIR}/WDT/wdt_me17.c
  ${SRC_DIR}/WDT/wdt_revb.c
  ${SRC_DIR}/WUT/wut_ai85.c
  ${SRC_DIR}/WUT/wut_reva.c
)

add_library(${THIS_LIBRARY_NAME} STATIC ${SRC_FILES})
target_compile_definitions(${THIS_LIBRARY_NAME} PUBLIC ${MSDK_COMPILE_DEFINITIONS})
target_include_directories(
  ${THIS_LIBRARY_NAME}
  PUBLIC
  ${INC_DIR}
  ${SRC_DIR}/ADC
  ${SRC_DIR}/AES
  ${SRC_DIR}/CAMERAIF
  ${SRC_DIR}/CRC
  ${SRC_DIR}/DMA
  ${SRC_DIR}/FLC
  ${SRC_DIR}/GPIO
  ${SRC_DIR}/I2C
  ${SRC_DIR}/I2S
  ${SRC_DIR}/ICC
  ${SRC_DIR}/LP
  ${SRC_DIR}/LPCMP
  ${SRC_DIR}/OWM
  ${SRC_DIR}/PT
  ${SRC_DIR}/RTC
  ${SRC_DIR}/SEMA
  ${SRC_DIR}/SPI
  ${SRC_DIR}/TRNG
  ${SRC_DIR}/TMR
  ${SRC_DIR}/UART
  ${SRC_DIR}/WDT
  ${SRC_DIR}/WUT
  ${CMSIS_ROOT}/Device/Maxim/MAX78000/Include
  ${CMSIS_INCLUDES}
)
