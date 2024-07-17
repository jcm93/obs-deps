autoload -Uz log_debug log_error log_info log_status log_output

## Dependency Information
local name='librashader'
local version='0.2.4'
local url='https://github.com/SnowflakePowered/librashader.git'
local hash='d72519b9fd112aa332c7a665918712b5860e6c62'
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
  else
    libra_profile="debug"
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

