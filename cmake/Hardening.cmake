# Apply common warning, optimization, and hardening flags to a target.
# Usage: apply_hardening(<target>)

include(CheckCCompilerFlag)

function(apply_hardening target)
  target_compile_options(${target} PRIVATE
    -Wall
    -Wextra
    -Wpedantic
    -Werror
    -Wshadow
    -Wconversion
    -Wsign-conversion
    -Wmissing-prototypes
    -Wstrict-prototypes
    -Wformat=2
    -O3
    -march=native
    -flto
    -fPIE
    -fno-plt
    -pipe
    -fdata-sections
    -ffunction-sections
    -fstack-protector-strong
    -D_FORTIFY_SOURCE=2
  )

  target_link_options(${target} PRIVATE
    -flto
    -fstack-protector-strong
    -Wl,-O1
    -Wl,--as-needed
    -fno-plt
    -fPIE
    -pie
    -Wl,--no-undefined
    -Wl,-z,relro
    -Wl,-z,now
    -Wl,--gc-sections
  )

  check_c_compiler_flag("-fstack-clash-protection" HAS_STACK_CLASH)
  if (HAS_STACK_CLASH)
    target_compile_options(${target} PRIVATE -fstack-clash-protection)
  endif()

  check_c_compiler_flag("-fcf-protection=full" HAS_CFI)
  if (HAS_CFI)
    target_compile_options(${target} PRIVATE -fcf-protection=full)
    target_link_options(${target} PRIVATE -fcf-protection=full)
  endif()
endfunction()

