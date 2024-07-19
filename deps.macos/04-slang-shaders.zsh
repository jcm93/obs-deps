autoload -Uz log_debug log_error log_info log_status log_output

## Dependency Information
local name='slang-shaders'
local version='1.0'
local url='https://github.com/libretro/slang-shaders.git'
local hash='05a41341be035d30633741bdf23ed361abce31cb'

## Build Steps
setup() {
  log_info "Setup (%F{3}${target}%f)"
  setup_dep ${url} ${hash}
}

clean() {
  cd "${dir}"

  if [[ ${clean_build} -gt 0 && -d build_${arch} ]] {
    log_info "Clean build directory (%F{3}${target}%f)"

    rm -rf build_${arch}
  }
}

build() {
  autoload -Uz mkcd

  log_info "Build (%F{3}${target}%f)"

  cd "${dir}"
}

install() {
  log_info "Install (%F{3}${target}%f)"

  cd "${dir}"
  rm -rf .git
  rm -f .gitlab-ci.yml
  rm -f configure
  rm -f Makefile
  ditto . "${target_config[output_dir]}"/lib/slang-shaders
}


