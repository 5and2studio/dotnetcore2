#!/bin/bash
# chmod a+x /where/i/saved/it/hello_world.sh

echo "sourceing dotnet_ef_update"

####
#### This script is by Benjamin Day
#### Twitter: @benday
#### Website: https://www.benday.com
####
#### Feel free to use this script and remember to be nice if it
#### doesn't work and remember how much you paid for it.
####
function dotnet_ef_update() {
  if [ $# -ne 2 ]; then
    echo "This script requires two parameters."
    echo "Parameter 1 is the name of the DLL that contains your migrations without '.dll'.  Example: MyApp.Api.dll --> MyApp.Api"
    echo "Parameter 2 is the name of the startup DLL without '.dll'.  Example: MyApp.WebUi.dll --> MyApp.WebUi"
    exit 1
  fi

  StartupDllName=$2.dll

  EfMigrationsNamespace=$1
  EfMigrationsDllName=$1.dll
  StartupDllDepsJson=$2.deps.json
  StartupDllRuntimeConfigJson=$2.runtimeconfig.json
  DllDir=$PWD
  # EfMigrationsDllDepsJsonPath=$PWD/bin/$BuildFlavor/netcoreapp1.0/$EfMigrationsDllDepsJson
  PathToNuGetPackages=$HOME/.nuget/packages

  NotFound=NotFound
  PathToEfDll=$NotFound

  PathToEfDll_Option=$PWD/ef.dll

  if [ "$PathToEfDll" = "$NotFound" ]; then
    if [ -e $PathToEfDll_Option ]; then
      PathToEfDll=$PathToEfDll_Option
    fi
  fi

  PathToEfDll_Option=$(find . -type f -name "ef.dll")

  if [ "$PathToEfDll" = "$NotFound" ]; then
    if [ -e $PathToEfDll_Option ]; then
      PathToEfDll=$PathToEfDll_Option
    fi
  fi

  if [ "$PathToEfDll" = "$NotFound" ]; then
    echo >&2 "********************************"
    echo >&2 " ERROR: COULD NOT LOCATE EF.DLL"
    echo >&2 "********************************"
  else
    echo "Found ef.dll at $PathToEfDll"
    echo "Running deployment..."

    dotnet exec --depsfile ./$StartupDllDepsJson --runtimeconfig ./$StartupDllRuntimeConfigJson --additionalprobingpath $NUGET_PACKAGES $PathToEfDll database update --assembly ./$EfMigrationsDllName --project-dir . --verbose --startup-assembly $StartupDllName --root-namespace $EfMigrationsNamespace
  fi
}
