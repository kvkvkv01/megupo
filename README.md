# Meguca Liftoff

 A Simple & Straightforwad Script for building Bakape's Shamichan on a fresh Debian server.

## What Gets Installed

- PostgreSQL 11
- Go 1.13.1
- Node.js 14.5.0
- Rust 1.47.0
- Required system packages and development libraries
- Shamichan (Meguca v6)

## Installation Steps

1. Clone this repository 
2. Save the script as `install.sh`
3. Make it executable:
   ```bash
   chmod +x install.sh
   ```
4. Run as root:
   ```bash
   sudo ./install.sh
   ```

## Configuration

### PostgreSQL
- Creates user 'meguca' with password 'meguca'
- Creates database 'meguca'
- Sets max_connections to 1024

### Environment Variables
- Adds Go to system PATH
- Sets up Rust environment

## Troubleshooting

1. If the first `make` fails, this is expected. The script continues (or at least should) and applies required fixes. If something interrupts the script you can simply finish it by running the commands (at your own risk). 
2. VERY IMPORTANT: You WILL see FFmpeg-related errors, to solve these you need to make sure that the thumbnailer patches were applied correctly:
   ```bash
    THUMBNAILER_PATH="$(go env GOPATH)/pkg/mod/github.com/bakape/thumbnailer/v2@v2.7.1"
    cp ffmpeg-fix/ffmpeg.h "${THUMBNAILER_PATH}/ffmpeg.h"
    cp ffmpeg-fix/ffmpeg.c "${THUMBNAILER_PATH}/ffmpeg.c"
    cp ffmpeg-fix/ffmpeg.go "${THUMBNAILER_PATH}/ffmpeg.go"
   ```

## Post-Installation

After successful installation, Shamichan will be available at:
- Default address: `localhost:8000`
- Default admin login: admin
- Default admin password: password

## Security Notes

- Change default PostgreSQL password after installation
- Review and adjust PostgreSQL configuration for production use
- Setup SSL/TLS for production deployment
- Configure firewall rules appropriately
- Have fun

## License

See Shamichan repository for license information.

## Final notes

This should take less than 15min to install. A Super-Synchronous Hyperreal-Time Imageboard for Everyone. 

[@oonomoco](https://x.com/oonomoco)
