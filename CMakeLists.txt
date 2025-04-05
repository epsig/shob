# set minimum cmake version
cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

# project name and language
project(shob LANGUAGES CXX)

file(GLOB shob_files "src/*.*")
add_library(shob STATIC ${shob_files})
set_target_properties(shob PROPERTIES CXX_STANDARD 20)

file(GLOB test_files "test/*.*")
add_executable(shobTest ${test_files})

set_target_properties(shobTest PROPERTIES CXX_STANDARD 20)

include(FetchContent)

FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG release-1.11.0
)
FetchContent_GetProperties(googletest)
if(NOT googletest_POPULATED)
    FetchContent_Populate(googletest)

    # Prevent GoogleTest from overriding our compiler/linker options
    # when building with Visual Studio
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    # Prevent GoogleTest from using PThreads
    set(gtest_disable_pthreads ON CACHE BOOL "" FORCE)

    # adds the targers: gtest, gtest_main, gmock, gmock_main
    add_subdirectory(
      ${googletest_SOURCE_DIR}
      ${googletest_BINARY_DIR}
      )

    # Silence std::tr1 warning on MSVC
    if(MSVC)
        foreach(_tgt gtest gtest_main gmock gmock_main)
            target_compile_definitions(${_tgt}
            PRIVATE
            "_SILENCE_TR1_NAMESPACE_DEPRECATION_WARNING"
          )
        endforeach()
    endif()
endif()

target_link_libraries(shobTest shob gtest_main)

