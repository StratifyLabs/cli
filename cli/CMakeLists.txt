cmsdk2_add_executable(
  TARGET RELEASE
  NAME cli
  CONFIG release
  ARCH ${CMSDK_ARCH})
cmsdk2_add_sources(
  TARGET ${RELEASE}
  DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src)
target_compile_definitions(${RELEASE}
  PRIVATE
  -DVERSION=\"${CMAKE_PROJECT_VERSION}\")
target_include_directories(${RELEASE}
  PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}/src)
set_property(TARGET ${RELEASE} PROPERTY CXX_STANDARD 17)
cmsdk2_app_add_dependencies(
  TARGET ${RELEASE}
  DEPENDENCIES InetAPI TestAPI FsAPI ThreadAPI)
cmsdk2_add_executable(
  TARGET DEBUG
  NAME cli
  CONFIG debug
  ARCH ${CMSDK_ARCH})
cmsdk2_copy_target(
  SOURCE ${RELEASE}
  DESTINATION ${DEBUG})

install(
  PROGRAMS ${CMAKE_CURRENT_SOURCE_DIR}/build_release_link/${PROJECT_NAME}_release_link${CMSDK_EXEC_SUFFIX}
  DESTINATION ${CMSDK_LOCAL_PATH}/bin RENAME ${PROJECT_NAME}${CMSDK_EXEC_SUFFIX})
