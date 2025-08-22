cmake_minimum_required(VERSION 3.20)
project(ResearchUnixV8 LANGUAGES C)

enable_testing()

# Make custom CMake modules available to all subdirectories.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Enable compilation of modern utilities that have been updated for contemporary toolchains.
add_subdirectory(modern)
