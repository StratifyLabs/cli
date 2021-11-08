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

# This is used on the CI server, but can be run locally as well
# This is currently NOT used with IS_ARM_CROSS_COMPILE=ON
option(IS_BUILD_AND_TEST "Build and run the API tests" OFF)

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

  if(IS_BUILD_AND_TEST)
    message(STATUS "Build and run API Tests")

    execute_process(
      COMMAND cmake -DSDK_IS_TEST=ON ..
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${BUILD_DIR}
    )

    execute_process(
      COMMAND cmake --build . --target all -- -j8
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${BUILD_DIR}
    )

    execute_process(
      COMMAND cmake --build . --target API_test -- -j8
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${BUILD_DIR}
    )

    execute_process(
      COMMAND ctest -VV
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${BUILD_DIR}
    )
  endif()
endif()

if(IS_BUILD_AND_TEST)

endif()


