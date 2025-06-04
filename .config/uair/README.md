## Socat binary
Make sure socat is installed in system.
```bash
which socat
```

If output is empty, install socat using


##### For Arch linux
```bash
sudo pacman -S socat
```

## Setting up systemd
#### Create symlink of service file to user systemd
```bash
ln -s /path/to/service/file/uair-socat.service $HOME/.config/systemd/user/uair-socat.service
```
#### Reload and restart the service
```bash
systemctl --user daemon-reload
systemctl --user restart uair-socat.service
```
#### Check systemd status
```bash
systemctl --user status uair-socat.service
```


## Create a logfile to log status
```bash
touch /tmp/pomodoro-log.json
```


## Troubleshooting
```bash
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user restart uair-socat.service
```
