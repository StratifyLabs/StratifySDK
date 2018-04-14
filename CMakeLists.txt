cmake_minimum_required (VERSION 3.6)

if( ${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Darwin" )
set(SOS_TOOLCHAIN_CMAKE_PATH /Applications/StratifyLabs-SDK/Tools/gcc/arm-none-eabi/cmake)
endif()
if( ${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows" )
  set(SOS_TOOLCHAIN_CMAKE_PATH C:/StratifyLabs-SDK/Tools/gcc/arm-none-eabi/cmake)
endif()

include(${SOS_TOOLCHAIN_CMAKE_PATH}/sos-sdk.cmake)

set(LIB_INSTALL TRUE)
if(SKIP_INSTALL)
    set(LIB_INSTALL FALSE)
endif()

set(WORKSPACE_PATH ${CMAKE_SOURCE_DIR}/..)

set(LIB_WORKSPACE_PATH ${WORKSPACE_PATH})
set(PUBLIC_LIB_PROJECTS 
    StratifyOS
    StratifyOS-mcu-lpc
    son
    sgfx
    StratifyAPI
)

set(PRIVATE_LIB_PROJECTS 
    StratifyOS-mcu-stm32
    smac
    StratifyOS-dev
)

set(APP_WORKSPACE_PATH ${WORKSPACE_PATH}/StratifyApps)
set(APP_PROJECTS 
    HelloWorld
    gpio
    uartprobe
    i2cprobe
    Blinky
)

set(BSP_WORKSPACE_PATH ${WORKSPACE_PATH}/StratifyBSP)
set(BSP_PROJECTS 
    CoActionHero
    StratifyAlpha
    mbedLPC1768
)

if(NOT SKIP_PULL)
    message(STATUS "Pulling Public Libraries")
    foreach(PROJECT ${PUBLIC_LIB_PROJECTS})
        message(STATUS "Clone or Pull: " ${PROJECT})
        sos_clone_or_pull(${LIB_WORKSPACE_PATH}/${PROJECT} https://github.com/StratifyLabs/${PROJECT}.git ${LIB_WORKSPACE_PATH})
    endforeach()

    if(INCLUDE_PRIVATE)
        foreach(PROJECT ${PRIVATE_LIB_PROJECTS})
            message(STATUS "Clone or Pull: " ${PROJECT})
            sos_clone_or_pull(${LIB_WORKSPACE_PATH}/${PROJECT} https://github.com/StratifyLabs/${PROJECT}.git ${LIB_WORKSPACE_PATH})
        endforeach()
    endif()

    if(INCLUDE_APP)
        message(STATUS "Pulling Applications")
        foreach(PROJECT ${APP_PROJECTS})
            message(STATUS "Clone or Pull: " ${PROJECT})
            sos_clone_or_pull(${APP_WORKSPACE_PATH}/${PROJECT} https://github.com/StratifyLabs/${PROJECT}.git ${APP_WORKSPACE_PATH})
        endforeach()
    endif()

    if(INCLUDE_BSP)
        message(STATUS "Pulling BSPs")
        foreach(PROJECT ${BSP_PROJECTS})
            message(STATUS "Clone or Pull: " ${PROJECT})
            sos_clone_or_pull(${APP_WORKSPACE_PATH}/${PROJECT} https://github.com/StratifyLabs/${PROJECT}.git ${APP_WORKSPACE_PATH})
        endforeach()
    endif()
endif()

if(NOT SKIP_BUILD)
    message(STATUS "Building Public Libraries")
    foreach(PROJECT ${PUBLIC_LIB_PROJECTS})
        message(STATUS "Building: " ${PROJECT})
        sos_build_lib(${LIB_WORKSPACE_PATH}/${PROJECT} ${LIB_INSTALL} arm)
    endforeach()

    sos_build_lib(${LIB_WORKSPACE_PATH}/StratifyOS ${LIB_INSTALL} link)
    sos_build_lib(${LIB_WORKSPACE_PATH}/son ${LIB_INSTALL} link)
    sos_build_lib(${LIB_WORKSPACE_PATH}/StratifyAPI ${LIB_INSTALL} link)

    if(INCLUDE_APP)
        message(STATUS "Building Applications")
        foreach(PROJECT ${APP_PROJECTS})
            message(STATUS "Building: " ${PROJECT})
            sos_build_app(${APP_WORKSPACE_PATH}/${PROJECT})
        endforeach()
    endif()

    if(INCLUDE_BSP)
        message(STATUS "Building BSPs")
        foreach(PROJECT ${BSP_PROJECTS})
            message(STATUS "Building: " ${PROJECT})
            sos_build_app(${APP_WORKSPACE_PATH}/${PROJECT})
        endforeach()
    endif()

endif()