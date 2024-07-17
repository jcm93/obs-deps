autoload -Uz log_debug log_error log_info log_status log_output

## Dependency Information
local name='librashader'
local version='0.2.4'
local url='https://github.com/SnowflakePowered/librashader.git'
local hash='fff80df5a024346d9409089e8965e323c6ab6698'
local libra_profile='release'

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

config() {
  if [[ "$config" == "Release" ]]; then
    libra_profile="release"
  elif [[ "$config" == "RelWithDebInfo" ]]; then
    libra_profile="release-with-debug"
  elif [[ "$config" == "Debug" ]]; then
    libra_profile="debug"
  elif [[ "$config" == "MinSizeRel" ]]; then
    libra_profile="optimized"
  fi
}

build() {
  autoload -Uz mkcd

  log_info "Build (%F{3}${target}%f)"

  cd "${dir}"
  cargo +nightly run -p librashader-build-script -- --profile ${libra_profile} --target x86_64-apple-darwin
  cargo +nightly run -p librashader-build-script -- --profile ${libra_profile} --target aarch64-apple-darwin
  lipo -create -output target/${libra_profile}/librashader.dylib target/x86_64-apple-darwin/${libra_profile}/librashader.dylib target/aarch64-apple-darwin/${libra_profile}/librashader.dylib
}

install() {
  log_info "Install (%F{3}${target}%f)"

  cd "${dir}"
  cp -Rp target/${libra_profile}/librashader.dylib "${target_config[output_dir]}"/lib
}

