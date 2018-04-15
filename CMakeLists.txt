cmake_minimum_required (VERSION 3.6)

#[[

Options

SKIP_LIB Don't pull or build any libraries
SKIP_INSTALL Don't Install libraries (just build - not installed by default)
CLEAN_ALL Clean all projects before building
SKIP_PULL Don't pull, just build
INCLUDE_LINK Build desktop interface libraries
INCLUDE_QT Build QT based interface libraries
INCLUDE_PRIVATE Build private libraries (only available for premium subsribers)
INCLUD_APP Pull and build application samples
INCLUDE_BSP Pull and build BSP sample projects

]]#

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

if(CLEAN_ALL)
    set(SOS_SDK_CLEAN_ALL TRUE)
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
set(PUBLIC_QT_LIB_PROJECTS
    StratifyQML
)

set(PRIVATE_QT_LIB_PROJECTS
    StratifyQt
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
    Nucleo-F767ZI
    Nucleo-F412ZG
    Nucleo-F746ZG
    Nucleo-F429ZI
    Nucleo-F446ZE
    Nucleo-F303ZE
    STM32F723E-DISCO
    STM32F411E-DISCO
)

if(NOT SKIP_PULL)
    if(NOT SKIP_LIB)
        message(STATUS "Pulling Public Libraries")
        foreach(PROJECT ${PUBLIC_LIB_PROJECTS})
            message(STATUS "Clone or Pull: " ${PROJECT})
            sos_sdk_clone_or_pull(${LIB_WORKSPACE_PATH}/${PROJECT} https://github.com/StratifyLabs/${PROJECT}.git ${LIB_WORKSPACE_PATH})
        endforeach()

        if(INCLUDE_LINK AND INCLUDE_QT)
            foreach(PROJECT ${PUBLIC_QT_LIB_PROJECTS})
                message(STATUS "Clone or Pull: " ${PROJECT})
                sos_sdk_clone_or_pull(${LIB_WORKSPACE_PATH}/${PROJECT} https://github.com/StratifyLabs/${PROJECT}.git ${LIB_WORKSPACE_PATH})
            endforeach()
        endif()

        if(INCLUDE_PRIVATE)
            foreach(PROJECT ${PRIVATE_LIB_PROJECTS})
                message(STATUS "Clone or Pull: " ${PROJECT})
                sos_sdk_clone_or_pull(${LIB_WORKSPACE_PATH}/${PROJECT} https://github.com/tyler-gilbert/${PROJECT}.git ${LIB_WORKSPACE_PATH})
            endforeach()

            foreach(PROJECT ${PRIVATE_QT_LIB_PROJECTS})
                message(STATUS "Clone or Pull: " ${PROJECT})
                sos_sdk_clone_or_pull(${LIB_WORKSPACE_PATH}/${PROJECT} https://github.com/tyler-gilbert/${PROJECT}.git ${LIB_WORKSPACE_PATH})
            endforeach()

        endif()

    endif()


    if(INCLUDE_APP)
        message(STATUS "Pulling Applications")
        foreach(PROJECT ${APP_PROJECTS})
            message(STATUS "Clone or Pull: " ${PROJECT})
            sos_sdk_clone_or_pull(${APP_WORKSPACE_PATH}/${PROJECT} https://github.com/StratifyLabs/${PROJECT}.git ${APP_WORKSPACE_PATH})
        endforeach()
    endif()

    if(INCLUDE_BSP)
        message(STATUS "Pulling BSPs")
        foreach(PROJECT ${BSP_PROJECTS})
            message(STATUS "Clone or Pull: " ${PROJECT})
            sos_sdk_clone_or_pull(${BSP_WORKSPACE_PATH}/${PROJECT} https://github.com/StratifyLabs/${PROJECT}.git ${BSP_WORKSPACE_PATH})
        endforeach()
    endif()
endif()

if(NOT SKIP_BUILD)
    if(NOT SKIP_LIB)
        message(STATUS "Building Public Libraries")
        foreach(PROJECT ${PUBLIC_LIB_PROJECTS})
            message(STATUS "Building: " ${PROJECT})
            sos_sdk_build_lib(${LIB_WORKSPACE_PATH}/${PROJECT} ${LIB_INSTALL} arm)
        endforeach()

        if(INCLUDE_LINK)
            message(STATUS "Building Link Libraries")
            sos_sdk_build_lib(${LIB_WORKSPACE_PATH}/StratifyOS ${LIB_INSTALL} link)
            sos_sdk_build_lib(${LIB_WORKSPACE_PATH}/son ${LIB_INSTALL} link)
            sos_sdk_build_lib(${LIB_WORKSPACE_PATH}/StratifyAPI ${LIB_INSTALL} link)
            if(INCLUDE_QT)
                message(STATUS "Building QT Libraries")
                sos_sdk_build_qt_lib(${LIB_WORKSPACE_PATH}/StratifyQML/StratifyLabs StratifyLabsUI link)
                sos_sdk_build_qt_lib(${LIB_WORKSPACE_PATH}/StratifyQt/StratifyLabs StratifyData link)
                sos_sdk_build_qt_lib(${LIB_WORKSPACE_PATH}/StratifyQt/StratifyLabs StratifyIO link)
            endif()
        endif()
    endif()

    if(INCLUDE_APP)
        message(STATUS "Building Applications")
        foreach(PROJECT ${APP_PROJECTS})
            message(STATUS "Building: " ${PROJECT})
            sos_sdk_build_app(${APP_WORKSPACE_PATH}/${PROJECT})
        endforeach()
    endif()

    if(INCLUDE_BSP)
        message(STATUS "Building BSPs")
        foreach(PROJECT ${BSP_PROJECTS})
            message(STATUS "Building: " ${PROJECT})
            sos_sdk_build_app(${BSP_WORKSPACE_PATH}/${PROJECT})
        endforeach()
    endif()

endif()