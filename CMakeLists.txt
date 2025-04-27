# set minimum cmake version
cmake_minimum_required(VERSION 3.28 FATAL_ERROR)

# project name and language
project(shob LANGUAGES CXX)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin)

# use boost:
find_package(Boost 1.83)
if (Boost_FOUND)
    include_directories(${Boost_INCLUDE_DIRS})
else()
    message(FATAL_ERROR "Boost not found")
endif()

file(GLOB football_files "src/shob.football/*.*")
add_library(shob.football STATIC ${football_files})
set_target_properties(shob.football PROPERTIES CXX_STANDARD 20)

file(GLOB general_files "src/shob.general/*.*")
add_library(shob.general STATIC ${general_files})
set_target_properties(shob.general PROPERTIES CXX_STANDARD 20)

file(GLOB readers_files "src/shob.readers/*.*")
add_library(shob.readers STATIC ${readers_files})
set_target_properties(shob.readers PROPERTIES CXX_STANDARD 20)

file(GLOB html_files "src/shob.html/*.*")
add_library(shob.html STATIC ${html_files})
set_target_properties(shob.html PROPERTIES CXX_STANDARD 20)

file(GLOB teams_files "src/shob.teams/*.*")
add_library(shob.teams STATIC ${teams_files})
set_target_properties(shob.teams PROPERTIES CXX_STANDARD 20)

add_executable(shob src/shob.cpp)
set_target_properties(shob PROPERTIES CXX_STANDARD 20)

file(GLOB readers_test_files "src/shob.readers.test/*.*")
add_executable(shob.readers.test ${readers_test_files})
set_target_properties(shob.readers.test PROPERTIES CXX_STANDARD 20)

file(GLOB football_test_files "src/shob.football.test/*.*")
add_executable(shob.football.test ${football_test_files})
set_target_properties(shob.football.test PROPERTIES CXX_STANDARD 20)

file(GLOB general_test_files "src/shob.general.test/*.*")
add_library(shob.general.test STATIC ${general_test_files})
set_target_properties(shob.general.test PROPERTIES CXX_STANDARD 20)

file(GLOB html_test_files "src/shob.html.test/*.*")
add_executable(shob.html.test ${html_test_files})
set_target_properties(shob.html.test PROPERTIES CXX_STANDARD 20)

file(GLOB teams_test_files "src/shob.teams.test/*.*")
add_executable(shob.teams.test ${teams_test_files})
set_target_properties(shob.teams.test PROPERTIES CXX_STANDARD 20)

include(FetchContent)

FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.16.0
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

target_link_libraries(shob.football shob.general shob.readers shob.teams)
target_link_libraries(shob.readers.test shob.general shob.general.test shob.readers gtest_main)
target_link_libraries(shob.football.test shob.football shob.general shob.general.test shob.readers gtest_main)
target_link_libraries(shob.html.test shob.html gtest_main)
target_link_libraries(shob shob.football shob.general shob.readers shob.html shob.teams)
target_link_libraries(shob.teams shob.readers)
target_link_libraries(shob.teams.test shob.teams shob.readers shob.general.test gtest_main)

enable_testing()

add_test(
  NAME shob-readers-unit-tests
  COMMAND $<TARGET_FILE:shob.readers.test>
  WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
)

add_test(
  NAME shob-football-unit-tests
  COMMAND $<TARGET_FILE:shob.football.test>
  WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
)

add_test(
  NAME shob-html-unit-tests
  COMMAND $<TARGET_FILE:shob.html.test>
  WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
)

add_test(
  NAME shob-teams-unit-tests
  COMMAND $<TARGET_FILE:shob.teams.test>
  WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
)

