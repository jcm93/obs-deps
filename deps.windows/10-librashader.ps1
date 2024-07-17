param(
    [string] $Name = 'librashader',
    [string] $Version = '0.2.4',
    [string] $Uri = 'https://github.com/SnowflakePowered/librashader.git',
    [string] $Hash = 'd72519b9fd112aa332c7a665918712b5860e6c62',
    [string] $Libra_profile = 'release'
)

function Setup {
    Setup-Dependency -Uri $Uri -Hash $Hash -DestinationPath $Path
}

function Clean {
    Set-Location $Path
    if ( Test-Path "build_${Target}" ) {
        Log-Information "Clean build directory (${Target})"
        Remove-Item -Path "build_${Target}" -Recurse -Force
    }
}

function Configure {
    Log-Information "Configure (${Target})"
    Set-Location $Path
    
    switch ($Configuration) {
    "Release" {
        $Libra_profile = "release"
        break
    }
    "RelWithDebInfo" {
        $Libra_profile = "release-with-debug"
        break
    }
    "Debug" {
        $Libra_profile = "debug"
        break
    }
    "MinSizeRel" {
        $Libra_profile = "optimized"
        break
    }
    default {
        $Libra_profile = "release"
        break
    }
    }
}

function Build {
    Log-Information "Build (${Target})"
    Set-Location $Path

    cargo +nightly run -p librashader-build-script -- --profile $Libra_profile
}

function Install {
    Log-Information "Install (${Target})"
    Set-Location $Path

    $Options = @(
        '--install', "build_${Target}"
        '--config', $Configuration
    )

    if ( $Configuration -match "(Release|MinSizeRel)" ) {
        $Options += '--strip'
    }

    Invoke-External cmake @Options
}
