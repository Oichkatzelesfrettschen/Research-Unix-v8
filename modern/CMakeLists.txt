include(Require)
include(Hardening)

# Validate headers and required runtime symbols.
require_headers(ctype.h fcntl.h getopt.h stdio.h stdlib.h string.h unistd.h errno.h)
require_symbol(getopt_long "getopt.h")
require_symbol(strtoul "stdlib.h")
require_symbol(open "fcntl.h")
require_symbol(creat "fcntl.h")
require_symbol(read "unistd.h")
require_symbol(write "unistd.h")
require_symbol(lseek "unistd.h")
require_symbol(close "unistd.h")

add_executable(flcopy flcopy.c)
set_target_properties(flcopy PROPERTIES
  C_STANDARD 99
  C_STANDARD_REQUIRED YES
)

# Apply a shared set of warnings, optimizations, and hardening flags.
apply_hardening(flcopy)

# Optional complexity analysis with lizard.
find_program(LIZARD_EXECUTABLE NAMES lizard)
if (LIZARD_EXECUTABLE)
  add_test(NAME flcopy_lizard
    COMMAND bash -c "${LIZARD_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/flcopy.c || true")
endif()

install(TARGETS flcopy RUNTIME DESTINATION bin)

add_test(NAME flcopy_hardening
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/test-flcopy.sh)
set_tests_properties(flcopy_hardening PROPERTIES
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
