# Utility macros to enforce the presence of headers and symbols.
# Usage:
#   require_headers(ctype.h stdio.h ...)
#   require_symbol(getopt_long "getopt.h")

include(CheckIncludeFile)
include(CheckSymbolExists)

function(require_headers)
  foreach(hdr IN LISTS ARGN)
    string(REPLACE "." "_" var "HAVE_${hdr}")
    check_include_file("${hdr}" ${var})
    if (NOT ${var})
      message(FATAL_ERROR "Required header <${hdr}> not found")
    endif()
  endforeach()
endfunction()

function(require_symbol sym header)
  check_symbol_exists(${sym} ${header} HAVE_${sym})
  if (NOT HAVE_${sym})
    message(FATAL_ERROR "Required function ${sym} not found")
  endif()
endfunction()

