param(
    [string] $Name = 'librashader',
    [string] $Version = '0.2.4',
    [string] $Uri = 'https://github.com/SnowflakePowered/librashader.git',
    [string] $Hash = 'fff80df5a024346d9409089e8965e323c6ab6698',
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
    
    $Params = @{
        ErrorAction = "SilentlyContinue"
        Path = @(
            "$($ConfigData.OutputPath)/bin"
            "$($ConfigData.OutputPath)/lib"
            "$($ConfigData.OutputPath)/include"
        )
        ItemType = "Directory"
        Force = $true
    }

    New-Item @Params *> $null

    $Items = @(
        @{
            Path = "target/${Libra_profile}/librashader.h"
            Destination = "$($ConfigData.OutputPath)/include/librashader.h"
            Force = $true
            Recurse = $true
        }
        @{
            Path = "target/${Libra_profile}/librashader.lib"
            Destination = "$($ConfigData.OutputPath)/lib/librashader.lib"
            Force = $true
            Recurse = $true
        }
        @{
            Path = "target/${Libra_profile}/librashader.d"
            Destination = "$($ConfigData.OutputPath)/include/librashader.d"
            Force = $true
            Recurse = $true
        }
        @{
            Path = "target/${Libra_profile}/librashader.dll"
            Destination = "$($ConfigData.OutputPath)/lib/librashader.dll"
            Force = $true
            Recurse = $true
        }
        @{
            Path = "target/${Libra_profile}/librashader.pdb"
            Destination = "$($ConfigData.OutputPath)/bin/librashader.pdb"
            Force = $true
            Recurse = $true
        }
        @{
            Path = "target/${Libra_profile}/librashader.dll.lib"
            Destination = "$($ConfigData.OutputPath)/lib/librashader.dll.lib"
            Force = $true
            Recurse = $true
        }
        @{
            Path = "target/${Libra_profile}/librashader.dll.exp"
            Destination = "$($ConfigData.OutputPath)/include/librashader.dll.exp"
            Force = $true
            Recurse = $true
        }
    )

    $Items | ForEach-Object {
        $Item = $_
        Log-Output ('{0} => {1}' -f $Item.Path, $Item.Destination)
        Copy-Item @Item
    }
}
