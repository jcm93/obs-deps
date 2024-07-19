autoload -Uz log_debug log_error log_info log_status log_output

## Dependency Information
local name='SDL2'
local version='2.28.5'
local url='https://github.com/libsdl-org/SDL.git'
local hash='15ead9a40d09a1eb9972215cceac2bf29c9b77f6'
local SDLARGS=()

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

config() {
  if [[ "$config" == "RelWithDebInfo" ]]; then
    CFLAGS='-g'
  elif [[ "$config" == "Debug" ]]; then
    CFLAGS='-O0 -g'
  fi
  SDLARGS=()
  SDLARGS+=("-DCMAKE_OSX_ARCHITECTURES=${arch}")
}

build() {
  autoload -Uz mkcd

  log_info "Build (%F{3}${target}%f)"

  cd "${dir}"
  mkdir -p build
  pushd build
  
  ## dSYMs require the Xcode generator; for reasons, presumably an xcodebuild bug, this does not actually generate a dSYM
  ## xcodebuild build -project ../Xcode/SDL/SDL.xcodeproj -scheme "Shared Library" -configuration Debug XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT="dwarf-with-dsym"

  cmake .. "${SDLARGS[@]}"
  cmake --build . --config ${config}

  popd
}

install() {
  log_info "Install (%F{3}${target}%f)"

  cd "${dir}"
  cp -Rp build/libSDL2-2.0.0.dylib "${target_config[output_dir]}"/lib
  mkdir -p "${target_config[output_dir]}"/include/SDL2
  cp -Rp build/include/SDL2/* "${target_config[output_dir]}"/include/SDL2
  cp -Rp build/include-config-/SDL2/* "${target_config[output_dir]}"/include/SDL2
}



