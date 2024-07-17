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

  if [[ ${clean_build} -gt 0 && -d "build" ]] {
    log_info "Clean build directory (%F{3}${target}%f)"

    rm -rf "build"
  }
}

build() {
  autoload -Uz mkcd

  log_info "Build (%F{3}${target}%f)"

  cd "${dir}"
  mkdir -p build
  pushd build

  SDLARGS=()
  SDLARGS+=("-DCMAKE_OSX_ARCHITECTURES=arm64;x86_64")
  if [ -n "${GITHUB_ACTIONS+1}" ]; then
      if [ $ImageOS == "macos12" ]; then
          SDLARGS+=(-DCMAKE_OSX_DEPLOYMENT_TARGET=10.11)
          echo "Added 10.11 deployment target to SDL build arguments"
      elif [ $ImageOS == "macos14" ]; then
          SDLARGS+=(-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13)
          echo "Added 10.13 deployment target to SDL build arguments"
      fi
  fi

  cmake .. "${SDLARGS[@]}"
  cmake --build .

  popd
}

install() {
  log_info "Install (%F{3}${target}%f)"

  cd "${dir}"
  cp -Rp build/libSDL2-2.0.0.dylib "${target_config[output_dir]}"/lib
}



