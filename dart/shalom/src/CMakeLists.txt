# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(shalom_library VERSION 0.0.1 LANGUAGES C)

add_library(shalom SHARED
  "shalom.c"
)

set_target_properties(shalom PROPERTIES
  PUBLIC_HEADER shalom.h
  OUTPUT_NAME "shalom"
)

target_compile_definitions(shalom PUBLIC DART_SHARED_LIB)

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(shalom PRIVATE "-Wl,-z,max-page-size=16384")
endif()
