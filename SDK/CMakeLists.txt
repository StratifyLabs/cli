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
  set(JSON_API_IS_TEST ON CACHE INTERNAL "Enable JsonAPI Test")
  set(CRYPTO_API_IS_TEST ON CACHE INTERNAL "Enable CryptoAPI Test")
  set(REGEX_API_IS_TEST ON CACHE INTERNAL "Enable RegexAPI Test")
  set(RAPID_FUZZ_API_IS_TEST ON CACHE INTERNAL "Enable RapidFuzzAPI Test")
endif()
set(SOS_CONFIG_PATH ${CMAKE_CURRENT_SOURCE_DIR}/config)
set(LWIP_STRATIFYOS_PATH ${CMAKE_CURRENT_SOURCE_DIR}/dependencies/StratifyOS/include)
if(${CMSDK_IS_ARM})
  set(API_PUBLIC_COMPILE_OPTIONS -Os CACHE INTERNAL "API Public compile options O3")
else()
  set(API_PUBLIC_COMPILE_OPTIONS -O3 CACHE INTERNAL "API Public compile options Os")
endif()
set(API_PUBLIC_DEBUG_COMPILE_OPTIONS -g CACHE INTERNAL "API Public debug compile options -g")
sdk_add_subdirectory(API main)
include(${BASE_DIRECTORY}/API/libraries/API.cmake)
set(LWIP_CONFIG_PATH ${CMAKE_CURRENT_SOURCE_DIR}/config)
set(MBEDTLS_CONFIG_FILE ${CMAKE_CURRENT_SOURCE_DIR}/config/mbedtls/config.h)
add_subdirectory(dependencies/CMakeSDK CMakeSDK)
if(CMSDK_IS_ARM)
  sdk_add_subdirectory(StratifyOS main)
  sdk_add_subdirectory(SosAPI main)
  sdk_add_subdirectory(HalAPI main)
endif()
sdk_add_subdirectory(JsonAPI main)
sdk_add_subdirectory(InetAPI main)
sdk_add_subdirectory(CryptoAPI main)
sdk_add_subdirectory(CloudAPI main)






