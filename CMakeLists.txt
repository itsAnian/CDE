cmake_minimum_required(VERSION 3.10)
project(CDE)

find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

BISON_TARGET(Parser parser.y ${CMAKE_BINARY_DIR}/parser.c)
FLEX_TARGET(Lexer lexer.l ${CMAKE_BINARY_DIR}/lexer.c)

ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)

add_executable(CDE ${BISON_Parser_OUTPUTS} ${FLEX_Lexer_OUTPUTS} main.c)

target_include_directories(CDE PRIVATE ${CMAKE_BINARY_DIR})
