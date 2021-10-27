cmake_minimum_required (VERSION 3.12)

project(sl-SDK)

set(API_IS_SDK TRUE CACHE INTERNAL "Build SDK projects")
option(IS_PULL "Pull SDK projects" ON)

set(BASE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/dependencies)
file(MAKE_DIRECTORY ${BASE_DIRECTORY})

message(STATUS "Base directory ${BASE_DIRECTORY}")

# refresh the bootstrap code if needed
execute_process(
	COMMAND git pull
	WORKING_DIRECTORY ${BASE_DIRECTORY}/CMakeSDK
	)

execute_process(
	COMMAND cmake --build . --target install
	WORKING_DIRECTORY ${BASE_DIRECTORY}/CMakeSDK/cmake_link
	)

add_custom_target(pull_sdk)

macro(sdk_add_subdirectory NAME BRANCH)
	sos_sdk_git_clone_or_pull_branch(${BASE_DIRECTORY} ${NAME} https://github.com/StratifyLabs/${NAME}.git ${BRANCH})
	add_subdirectory(${BASE_DIRECTORY}/${NAME} ${NAME} EXCLUDE_FROM_ALL)
endmacro()

include(CTest)

set(STRATIFYOS_LWIP_PATH
	${CMAKE_CURRENT_SOURCE_DIR}/../InetAPI/lwip/include
	${CMAKE_CURRENT_SOURCE_DIR}/../InetAPI/lwip/lwip-2.1.2/src/include
	CACHE INTERNAL "LWIP INCLUDE PATHS")


sdk_add_subdirectory(API main)
include(${BASE_DIRECTORY}/API/libraries/API.cmake)

set(MBEDTLS_CONFIG_FILE ${CMAKE_CURRENT_SOURCE_DIR}/config/mbedtls/config.h CACHE INTERNAL "MBEDTLS config file")

add_subdirectory(dependencies/CMakeSDK CMakeSDK)

sdk_add_subdirectory(JsonAPI v1.0)
sdk_add_subdirectory(InetAPI main)



