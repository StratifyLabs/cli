set(SDK_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/SDK)
set(SDK_PATH ${SDK_DIRECTORY}/StratifyLabs-SDK)

file(MAKE_DIRECTORY ${SDK_PATH})
set(DEPENDENCIES_DIRECTORY ${SDK_DIRECTORY}/dependencies)
file(MAKE_DIRECTORY ${DEPENDENCIES_DIRECTORY})

file(REMOVE_RECURSE ${DEPENDENCIES_DIRECTORY}/CMakeSDK)

set(CMAKE_SDK_DIRECTORY ${DEPENDENCIES_DIRECTORY}/CMakeSDK)
execute_process(
  COMMAND git clone --branch main https://github.com/StratifyLabs/CMakeSDK.git
  WORKING_DIRECTORY ${DEPENDENCIES_DIRECTORY}
)

option(IS_ARM_CROSS_COMPILE "Setup the system to cross compile to Stratify OS" OFF)

if(IS_ARM_CROSS_COMPILE)
  set(BUILD_DIR cmake_arm)
  execute_process(
    COMMAND cmake -DSDK_DIRECTORY=${SDK_DIRECTORY} -P ${DEPENDENCIES_DIRECTORY}/CMakeSDK/scripts/bootstrap.cmake
  )
else()
  set(BUILD_DIR cmake_link)

  file(MAKE_DIRECTORY ${CMAKE_SDK_DIRECTORY}/${BUILD_DIR})

  if(NOT GENERATOR)
    set(GENERATOR Ninja)
  endif()

  set(ENV{SOS_SDK_PATH} ${SDK_PATH})
  execute_process(
    COMMAND cmake .. -G${GENERATOR}
    WORKING_DIRECTORY ${CMAKE_SDK_DIRECTORY}/${BUILD_DIR}
  )

  execute_process(
    COMMAND cmake --build . --target install
    WORKING_DIRECTORY ${CMAKE_SDK_DIRECTORY}/${BUILD_DIR}
  )

  file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${BUILD_DIR})
endif()


