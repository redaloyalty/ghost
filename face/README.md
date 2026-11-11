# Face unlock

Howdy on the lock screen. Press Enter on an empty field, look at the camera, it opens. The password still works.

The camera is `/dev/face`, a udev link: the monitor's camera while it is plugged in, the laptop IR camera when it is not. See `99-face-camera.rules.example`.

Steps that worked on Ubuntu 24.04:

1. Build deps: `sudo apt install libinih-dev libevdev-dev python3-opencv python3-numpy libopencv-dev libdlib-dev`, then `sudo pip3 install dlib --break-system-packages`.
2. Howdy 3 from source. Meson looks for `/usr/bin/python` by default, so:
   `meson setup b -Dpython_path=/usr/bin/python3 -Dpam_dir=/usr/lib/x86_64-linux-gnu/security && meson compile -C b && sudo meson install -C b`
3. Models: run `howdy/src/dlib-data/install.sh`, then copy the `.dat` files to `/usr/local/share/dlib-data/` (the script leaves them where it ran).
4. Laptop IR light is often off on Linux. `linux-enable-ir-emitter configure` finds the control, `sudo linux-enable-ir-emitter setup-howdy` turns it on before each check.
5. In `/usr/local/etc/howdy/config.ini`: `device_path = /dev/face`, `abort_if_lid_closed = false` (docked with the lid shut still uses the monitor camera).
6. Add a face per camera: `sudo howdy -U $USER add`, once facing the laptop, once facing the monitor.
7. Check: `sudo python3 /usr/local/lib/x86_64-linux-gnu/howdy/compare.py $USER; echo $?` - 0 is a match, 11 no match, 13 too dark.
8. `/etc/pam.d/i3lock`: `auth sufficient pam_howdy.so` above `auth include login`. Keep a root shell open while testing.

`bin/lock` runs i3lock without `-e`, otherwise an empty Enter never reaches PAM and the face check never runs.

A colour camera (most monitors) can be fooled by a photo and fails in the dark. IR is the safe one.
