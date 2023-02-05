<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

# Alpine Linux with OpenSSH
Another Docker container build on Alpine Linux with OpenSSH.

## Build the image
Use this command to build the image:
```shell
docker build -t sshd .
```

This is my `Dockerfile`. Adjust the Alpine Linux version:

    # Inpired by https://github.com/raesene and https://github.com/sickp.
    # Build: docker build -t sshd .

    FROM alpine:3.17.1
    LABEL maintainer "daniel@isociel.com"
    EXPOSE 22

    COPY banner /etc/ssh/
    COPY motd /etc/
    COPY entrypoint.sh /

    # The following line is to prevent the error:
    # Make the script 'executable'. Prevents the error: permission denied unknown
    RUN ["chmod", "+x", "/entrypoint.sh"]

    # RUN apk update --no-cache
    # RUN apk --update add bind-tools && rm -rf /var/cache/apk/*

    # OpenSSH installation, permit "root" and set "root" password.
    RUN apk add --no-cache openssh \
    && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
    && echo "root:root" | chpasswd

    # Networking package installation
    RUN apk add --no-cache busybox-extras sudo iputils curl iproute2 nmap tcpdump nmap-ncat iperf socat

    ENTRYPOINT ["/entrypoint.sh"]

After the build, the image should be `~42Mb`.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Run the container
Use this command run the container and to expose port `TCP/2222` on the Docker host to port `TCP/22` inside the container:
```sh
docker run -it --rm -p 2222:22 --name sshd --hostname sshd sshd
```
This is the interactive mode. You will see a username and password for SSH access.

    % docker run -it --rm -p 2222:22 --name sshd --hostname sshd sshd
    ssh username: remote
    ssh password: YXcIGzbS+rgH9Nki+xp9
    Server listening on 0.0.0.0 port 22.
    Server listening on :: port 22.

>The best way to run the container is in `detach mode`. Just replace `-it` with `-d`.

Use this command to get the password for the use `remote`, if you run it in `detach mode`:
```sh
docker logs -n all sshd
```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## SSH inside the container
Start another terminal, on any Linux or macOS, and use this command to access the container via SSH:
```sh
ssh -p 2222 -l remote 127.0.0.1
```
    % ssh -p 2222 -l remote 127.0.0.1
    Warning: Permanently added '[127.0.0.1]:2222' (ED25519) to the list of known hosts.

    Linux x86_64, 5.15.49-linuxkit on host sshd

    Welcome to Alpine Docker container 3.17.1!

    This Alpine container was build with OpenSSH and networking tools.
    Please issue the command "docker logs <container ID>" to get the
    username and password.

    The password for "root" is "root" and it can be used to ssh in the container.

    USERNAME: remote
    PASSWORD: 3Nln14yxi2YA79L1pxg3

    Thank you for using this container!

    remote@127.0.0.1's password: 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Terminate the container
Use this command to terminate the container:
```sh
docker rm -f sshd
```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License
Distributed under the MIT License. See [LICENSE](LICENSE) for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact
Daniel Della-Noce - [Linkedin](https://www.linkedin.com/in/daniel-della-noce-2176b622/) - daniel@isociel.com

Project Link: [https://github.com/ddella/sshd](https://github.com/ddella/sshd)
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

<p align="right">(<a href="#readme-top">back to top</a>)</p>

