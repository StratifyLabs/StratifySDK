cmake_minimum_required (VERSION 3.6)

#[[

example:

cmake -DINCLUDE_QT=1 -P StratifySDK.cmake

Options must be before the '-P' switch.

]]#

option(CLEAN "Clean all projects when building" OFF)
option(GIT_STATUS "Show status of all git repo's (implies SKIP_PULL and SKIP_BUILD" OFF)
option(GIT_PULL "Pull from git before building" ON)
option(BUILD "Build all projects" ON)

option(INSTALL_LIBRARIES "Install libraries" ON)
option(INCLUDE_LIBRARIES "Build libraries" ON)
option(INCLUDE_ARM "Include ARM libraries (cmake_arm build targets)" ON)
option(INCLUDE_LINK "Build link libraries for the desktop (cmake_link build targets)" OFF)
option(INCLUDE_THIRD_PARTY "Include third party libraries" ON)
option(INCLUDE_QT "Build SDK Qt libraries" OFF)
option(INCLUDE_PRIVATE "Build private repos" OFF)
option(INCLUDE_BSP "Build Stratify OS BSPs (must INCLUDE_ARM too)" OFF)
option(INCLUDE_APP "Build Stratify OS Applications (must INCLUDE_ARM too" OFF)

if( ${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Darwin" )
    set(SOS_TOOLCHAIN_CMAKE_PATH /Applications/StratifyLabs-SDK/Tools/gcc/arm-none-eabi/cmake)
endif()
if( ${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows" )
  set(SOS_TOOLCHAIN_CMAKE_PATH C:/StratifyLabs-SDK/Tools/gcc/arm-none-eabi/cmake)
endif()

include(${SOS_TOOLCHAIN_CMAKE_PATH}/sos-sdk.cmake)

if(CLEAN)
    set(SOS_SDK_CLEAN_ALL TRUE)
endif()

set(WORKSPACE_PATH ${CMAKE_SOURCE_DIR}/..)

set(LIB_WORKSPACE_PATH ${WORKSPACE_PATH})
set(PUBLIC_LIB_PROJECTS 
    StratifyOS
    StratifyOS-mcu-lpc
    son
    sgfx
)

set(PUBLIC_THIRD_PARTY_CLONE_PROJECTS
    StratifyOS-CMSIS
    StratifyOS-mbedtls
    StratifyOS-jansson
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

if(GIT_STATUS)
    set(GIT_PULL OFF)
    set(BUILD OFF)

    if(INCLUDE_LIBRARIES)
        foreach(PROJECT ${PUBLIC_LIB_PROJECTS})
            sos_sdk_git_status(${LIB_WORKSPACE_PATH}/${PROJECT})
        endforeach()
        if(INCLUDE_PRIVATE)
            foreach(PROJECT ${PRIVATE_LIB_PROJECTS})
                sos_sdk_git_status(${LIB_WORKSPACE_PATH}/${PROJECT})
            endforeach()

            if(INCLUDE_QT)
                foreach(PROJECT ${PRIVATE_QT_LIB_PROJECTS})
                    sos_sdk_git_status(${LIB_WORKSPACE_PATH}/${PROJECT})
                endforeach()
            endif()

        endif()
    endif()

    if(INCLUDE_BSP AND INCLUDE_ARM)
        foreach(PROJECT ${BSP_PROJECTS})
            sos_sdk_git_status(${BSP_WORKSPACE_PATH}/${PROJECT})
        endforeach()
    endif()

    if(INCLUDE_APP AND INCLUDE_ARM)
        foreach(PROJECT ${APP_PROJECTS})
            sos_sdk_git_status(${APP_WORKSPACE_PATH}/${PROJECT})
        endforeach()
    endif()

endif()

if(GIT_PULL)
    if(INCLUDE_LIBRARIES AND (INCLUDE_LINK OR INCLUDE_ARM))
        message(STATUS "Pulling Public Libraries")
        foreach(PROJECT ${PUBLIC_LIB_PROJECTS})
            message(STATUS "Clone or Pull: " ${PROJECT})
            sos_sdk_clone_or_pull(${LIB_WORKSPACE_PATH}/${PROJECT} https://github.com/StratifyLabs/${PROJECT}.git ${LIB_WORKSPACE_PATH})
        endforeach()
        sos_sdk_clone_or_pull(${LIB_WORKSPACE_PATH}/StratifyAPI https://github.com/StratifyLabs/StratifyAPI.git ${LIB_WORKSPACE_PATH})

        if(INCLUDE_THIRD_PARTY)
            foreach(PROJECT ${PUBLIC_THIRD_PARTY_CLONE_PROJECTS})
            message(STATUS "Clone or Pull: " ${PROJECT})
                sos_sdk_clone_or_pull(${LIB_WORKSPACE_PATH}/${PROJECT} https://github.com/StratifyLabs/${PROJECT}.git ${LIB_WORKSPACE_PATH})
                #these require an extra step
                execute_process(COMMAND ${SOS_SDK_CMAKE_EXEC} -P ${PROJECT}.cmake .. WORKING_DIRECTORY ${LIB_WORKSPACE_PATH}/${PROJECT})
            endforeach()
        endif()

        if(INCLUDE_LINK AND INCLUDE_QT)
            foreach(PROJECT ${PUBLIC_QT_LIB_PROJECTS})
                message(STATUS "Clone or Pull: " ${PROJECT})
                sos_sdk_clone_or_pull(${LIB_WORKSPACE_PATH}/${PROJECT} https://github.com/StratifyLabs/${PROJECT}.git ${LIB_WORKSPACE_PATH})
            endforeach()
        endif()

        if(INCLUDE_PRIVATE)

            if(INCLUDE_ARM)
                foreach(PROJECT ${PRIVATE_LIB_PROJECTS})
                    message(STATUS "Clone or Pull: " ${PROJECT})
                    sos_sdk_clone_or_pull(${LIB_WORKSPACE_PATH}/${PROJECT} https://github.com/tyler-gilbert/${PROJECT}.git ${LIB_WORKSPACE_PATH})
                endforeach()
            endif()

            if(INCLUDE_QT)
                foreach(PROJECT ${PRIVATE_QT_LIB_PROJECTS})
                    message(STATUS "Clone or Pull: " ${PROJECT})
                    sos_sdk_clone_or_pull(${LIB_WORKSPACE_PATH}/${PROJECT} https://github.com/tyler-gilbert/${PROJECT}.git ${LIB_WORKSPACE_PATH})
                endforeach()
            endif()
        endif()
    endif()


    if(INCLUDE_APP AND INCLUDE_ARM)
        message(STATUS "Pulling Applications")
        foreach(PROJECT ${APP_PROJECTS})
            message(STATUS "Clone or Pull: " ${PROJECT})
            sos_sdk_clone_or_pull(${APP_WORKSPACE_PATH}/${PROJECT} https://github.com/StratifyLabs/${PROJECT}.git ${APP_WORKSPACE_PATH})
        endforeach()
    endif()

    if(INCLUDE_BSP AND INCLUDE_ARM)
        message(STATUS "Pulling BSPs")
        foreach(PROJECT ${BSP_PROJECTS})
            message(STATUS "Clone or Pull: " ${PROJECT})
            sos_sdk_clone_or_pull(${BSP_WORKSPACE_PATH}/${PROJECT} https://github.com/StratifyLabs/${PROJECT}.git ${BSP_WORKSPACE_PATH})
        endforeach()
    endif()
endif()

if(BUILD)
    if(INCLUDE_LIBRARIES)
        message(STATUS "Building Public Libraries")
        if(INCLUDE_ARM)
            foreach(PROJECT ${PUBLIC_LIB_PROJECTS})
                message(STATUS "Building: " ${PROJECT})
                sos_sdk_build_lib(${LIB_WORKSPACE_PATH}/${PROJECT} ${INSTALL_LIBRARIES} arm)
            endforeach()

            if(INCLUDE_THIRD_PARTY)
                foreach(PROJECT ${PUBLIC_THIRD_PARTY_CLONE_PROJECTS})
                    message(STATUS "Building: " ${PROJECT})
                    sos_sdk_build_lib(${LIB_WORKSPACE_PATH}/${PROJECT} ${INSTALL_LIBRARIES} arm)
                endforeach()
            endif()

            sos_sdk_build_lib(${LIB_WORKSPACE_PATH}/StratifyAPI ${INSTALL_LIBRARIES} arm)

            if(INCLUDE_PRIVATE)
                message(STATUS "Building Private Libraries")
                foreach(PROJECT ${PRIVATE_LIB_PROJECTS})
                    message(STATUS "Building: " ${PROJECT})
                    sos_sdk_build_lib(${LIB_WORKSPACE_PATH}/${PROJECT} ${INSTALL_LIBRARIES} arm)
                endforeach()
            endif()
        endif()

        if(INCLUDE_LINK)
            message(STATUS "Building Link Libraries")
            sos_sdk_build_lib(${LIB_WORKSPACE_PATH}/StratifyOS ${INSTALL_LIBRARIES} link)
            sos_sdk_build_lib(${LIB_WORKSPACE_PATH}/son ${INSTALL_LIBRARIES} link)
            sos_sdk_build_lib(${LIB_WORKSPACE_PATH}/StratifyOS-jansson ${INSTALL_LIBRARIES} link)
            sos_sdk_build_lib(${LIB_WORKSPACE_PATH}/StratifyOS-mbedtls ${INSTALL_LIBRARIES} link)
            sos_sdk_build_lib(${LIB_WORKSPACE_PATH}/StratifyAPI ${INSTALL_LIBRARIES} link)
            if(INCLUDE_QT)
                message(STATUS "Building QT Libraries")
                sos_sdk_build_qt_lib(${LIB_WORKSPACE_PATH}/StratifyQML/StratifyLabs StratifyLabsUI link)
                if(INCLUDE_PRIVATE)
                    sos_sdk_build_qt_lib(${LIB_WORKSPACE_PATH}/StratifyQt/StratifyLabs StratifyData link)
                    sos_sdk_build_qt_lib(${LIB_WORKSPACE_PATH}/StratifyQt/StratifyLabs StratifyIO link)
                endif()
            endif()
        endif()


    endif()

    if(INCLUDE_APP AND INCLUDE_ARM)
        message(STATUS "Building Applications")
        foreach(PROJECT ${APP_PROJECTS})
            message(STATUS "Building: " ${PROJECT})
            sos_sdk_build_app(${APP_WORKSPACE_PATH}/${PROJECT})
        endforeach()
    endif()

    if(INCLUDE_BSP AND INCLUDE_ARM)
        message(STATUS "Building BSPs")
        foreach(PROJECT ${BSP_PROJECTS})
            message(STATUS "Building: " ${PROJECT})
            sos_sdk_build_app(${BSP_WORKSPACE_PATH}/${PROJECT})
        endforeach()
    endif()

endif()