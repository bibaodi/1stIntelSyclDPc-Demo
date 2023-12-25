cmake_minimum_required(VERSION 3.20.5)
if( NOT DEFINED CMAKE_C_COMPILER)
set(CMAKE_C_COMPILER icx)
endif()
if( NOT DEFINED CMAKE_CXX_COMPILER)
set(CMAKE_CXX_COMPILER icpx)
endif()
if( NOT DEFINED CMAKE_Fortran_COMPILER)
set(CMAKE_Fortran_COMPILER ifx)
endif()
#SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -xCORE-AVX2 -g -Rno-debug-disables-optimization")
#SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --profile-gpu")
project(07-dependOnAndHostTask)

set(SRC_FILES
    "src/main.cpp"
    "src/program.cpp")

set(SYCL_FILES
    "src/main.cpp")
    
set(HEADER_FILES
    "src/program.h")

#find_package(ComputeCpp REQUIRED)
find_package(IntelSYCL REQUIRED PATHS $ENV{TBBROOT})
message(STATUS "SYCL_INCLUDE_DIR:${SYCL_INCLUDE_DIR} , SYCL_INCLUDE_DIRS:${SYCL_INCLUDE_DIRS}")
message(STATUS "ENV{TBBROOT}:$ENV{TBBROOT},")
add_executable("${PROJECT_NAME}" "${SRC_FILES}" "${HEADER_FILES}")

target_include_directories("${PROJECT_NAME}" PRIVATE 
                           "${SYCL_INCLUDE_DIR}"
                           "${CMAKE_SOURCE_DIR}/src")

add_sycl_to_target(TARGET "${PROJECT_NAME}"
                   SOURCES "${SYCL_FILES}")
