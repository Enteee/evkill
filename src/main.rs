use std::env;
use std::process::exit;
use std::path::Path;
use std::fs::File;
use std::os::unix::io::AsRawFd;

use ctrlc;

use std::thread;

use nix::ioctl_write_int;

const UAPI_IOC_MAGIC: u8 = b'E';
const UAPI_IOC_EVIOCGRAB: u8 = 0x90;
ioctl_write_int!(eviocgrab, UAPI_IOC_MAGIC, UAPI_IOC_EVIOCGRAB);

fn usage() {
    println!("usage: evkill <device>");
    exit(1);
}

fn main() {

    ctrlc::set_handler(move || {
        exit(0);
    })
    .expect("Error setting Ctrl-C handler");

    let args: Vec<String> = env::args().collect();
    match args.len() {
        2 => {
            let path = Path::new(&args[1]);
            let display = path.display();

            let file = match File::open(&path) {
                Err(why) => panic!("couldn't open {}: {}", display, why),
                Ok(file) => file,
            };

            unsafe {
                match eviocgrab(file.as_raw_fd(),1) {
                    Err(why) => panic!("couldn't send EVIOCGRAB to {}: {}", display, why),
                    Ok(_) => (),
                };
            }
            loop {
                thread::park();
            }
        },
        _ => usage(),
    }
}

