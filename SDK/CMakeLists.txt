cmake_minimum_required(VERSION 3.12)
project(${PROJECT_NAME}-SDK)
set(BASE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/dependencies)
file(MAKE_DIRECTORY ${BASE_DIRECTORY})
message(STATUS "Base directory ${BASE_DIRECTORY}")

function(sdk_add_subdirectory NAME BRANCH)
  cmsdk2_git_clone_or_pull_branch(
    WORKING_DIRECTORY ${BASE_DIRECTORY}
    NAME ${NAME}
    REPOSITORY https://github.com/StratifyLabs/${NAME}.git
    BRANCH ${BRANCH})
  add_subdirectory(${BASE_DIRECTORY}/${NAME} ${NAME} EXCLUDE_FROM_ALL)
endfunction()

include(CTest)
option(SDK_IS_TEST "Enable all SDK API tests" OFF)
message(STATUS "Enable all tests? " ${SDK_IS_TEST})
if(SDK_IS_TEST)
  message(STATUS "Enabling tests for Api, Inet, Json, and Crypto")
  set(API_IS_TEST ON CACHE INTERNAL "Enable API Test")
  set(INET_API_IS_TEST ON CACHE INTERNAL "Enable InetAPI Test")
  set(CRYPTO_API_IS_TEST ON CACHE INTERNAL "Enable CryptoAPI Test")
  set(CLOUD_API_IS_TEST ON CACHE INTERNAL "Enable CloudAPI Test")
  set(JSON_API_IS_TEST ON CACHE INTERNAL "Enable JsonAPI Test")
  set(CRYPTO_API_IS_TEST ON CACHE INTERNAL "Enable CryptoAPI Test")
endif()
set(SOS_CONFIG_PATH ${CMAKE_CURRENT_SOURCE_DIR}/config)
set(LWIP_STRATIFYOS_PATH ${CMAKE_CURRENT_SOURCE_DIR}/dependencies/StratifyOS/include)
if(${CMSDK_IS_ARM})
  set(API_PUBLIC_COMPILE_OPTIONS -Os CACHE INTERNAL "API Public compile options O3")
else()
  set(API_PUBLIC_COMPILE_OPTIONS -O3 CACHE INTERNAL "API Public compile options")
  set(API_PUBLIC_LINK_OPTIONS "" CACHE INTERNAL "API Public Link options")
endif()
set(API_PUBLIC_DEBUG_COMPILE_OPTIONS -g CACHE INTERNAL "API Public debug compile options")
sdk_add_subdirectory(API v1.6)
include(${BASE_DIRECTORY}/API/libraries/API.cmake)
set(LWIP_CONFIG_PATH ${CMAKE_CURRENT_SOURCE_DIR}/config)
set(MBEDTLS_CONFIG_FILE ${CMAKE_CURRENT_SOURCE_DIR}/config/mbedtls/config.h)
add_subdirectory(dependencies/CMakeSDK CMakeSDK)
sdk_add_subdirectory(JsonAPI v1.5)
sdk_add_subdirectory(InetAPI v1.5)
sdk_add_subdirectory(CryptoAPI v1.4)
sdk_add_subdirectory(CloudAPI v1.3)






