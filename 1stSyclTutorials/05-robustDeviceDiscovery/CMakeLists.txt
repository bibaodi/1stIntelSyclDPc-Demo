
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

project(05test_application)

set(SRC_FILES
    "src/main.cpp"
    "src/program.cpp")

set(SYCL_FILES
    "src/main.cpp")
    
set(HEADER_FILES
    "src/program.h")

#find_package(ComputeCpp REQUIRED)
find_package(IntelSYCL REQUIRED PATHS $ENV{TBBROOT})
message(status "xxxxxxxxxxxxx:""${SYCL_INCLUDE_DIR}")
add_executable("${PROJECT_NAME}" "${SRC_FILES}" "${HEADER_FILES}")

target_include_directories("${PROJECT_NAME}" PRIVATE 
                           "${SYCL_INCLUDE_DIRS}"
                           "${CMAKE_SOURCE_DIR}/src")

add_sycl_to_target(TARGET "${PROJECT_NAME}"
                   SOURCES "${SYCL_FILES}")
