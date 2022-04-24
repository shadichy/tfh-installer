# neutralinojs

The default template for a Neutralinojs app. It's possible to use your favorite frontend framework by using [these steps](https://neutralino.js.org/docs/how-to/use-a-frontend-library).

## Contributors

Shadichy 1st
Shadichy 2nd
Shadichy 3rd

## License

[MIT](LICENSE)

## Icon credits

- `trayIcon.png` - Made by Team Fuho Vietnam

# tfh-installer

## Guide:

```bash
Usage: ./build.sh [--help] [--clean] [--version] [--target=<target>] [--os=<os>]

Options:

  -h,--help			        Show this help
  -c,--clean                Clean the build directory
  -V,--version              Show the version
  -D,--build-dir=<dir>		Build the binaries in the specified directory (default: $(pwd))
  -t,--target=<target>		Build the specified target (default: all)
							Supported targets: AppImage, script
  -s,--os=<os>			    Build the specified os (default: all)
							Supported os: linux, mac
  -m,--arch=<arch>			Build the specified architecture (default: $(uname -m))
							Supported architecture: x86_64, i686
  -d,--debug			    Build the debug version
  -u,--update			    Update the binaries
```
