autoload -Uz log_debug log_error log_info log_status log_output

## Dependency Information
local name='Molten-VK'
local version='1.2.9'
local url='https://github.com/KhronosGroup/MoltenVK.git'
local hash='bf097edc74ec3b6dfafdcd5a38d3ce14b11952d6'

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
  ./fetchDependencies --macos
  xcodebuild build -quiet -project MoltenVKPackaging.xcodeproj -scheme "MoltenVK Package (macOS only)" -configuration ${config}
}

install() {
  log_info "Install (%F{3}${target}%f)"

  cd "${dir}"
  cp -Rp Package/${config}/MoltenVK/dynamic/dylib/macOS/libMoltenVK.dylib "${target_config[output_dir]}"/lib
  if [[ -f "Package/${config}/MoltenVK/dynamic/dylib/macOS/libMoltenVK.dylib.dSYM" ]] {
    cp -Rp Package/${config}/MoltenVK/dynamic/dylib/macOS/libMoltenVK.dylib.dSYM "${target_config[output_dir]}"/lib
  }
  mkdir -p "${target_config[output_dir]}"/include/MoltenVK
}


