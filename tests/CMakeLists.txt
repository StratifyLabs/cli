
set(PROGRAM_NAME ${CMAKE_CURRENT_SOURCE_DIR}/../app/build_release_link/cli_release_link.elf)
set(TMP_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../tmp)

set(TEST_LIST "")

macro(add_program_test TEST_NAME WILL_FAIL ARGUMENTS)
	add_test(NAME ${TEST_NAME}
		COMMAND ${PROGRAM_NAME} ${ARGUMENTS}
		WORKING_DIRECTORY ${TMP_DIRECTORY}
		)

	set_tests_properties(${TEST_NAME} PROPERTIES
		WILL_FAIL ${WILL_FAIL}
		)

	set_tests_properties(${TEST_NAME} PROPERTIES
		RUN_SERIAL TRUE
		)

endmacro()

add_program_test(initialize FALSE FALSE "--initialize")


