#1/18/24
Docker Code:

FROM ubuntu:latest
RUN apt-get update && apt-get install -y openssl openssh-client

# Create the .ssh directory
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

WORKDIR /data

# Copy the script and known_hosts file
COPY transfer_script.sh /data/
COPY known_hosts /root/.ssh/known_hosts
COPY id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

# Set the correct permissions
RUN chmod +x /data/transfer_script.sh
RUN chmod 644 /root/.ssh/known_hosts

CMD ["/data/transfer_script.sh"]


transfer_script.sh: 

#!/bin/bash

# Set your password
password="Password"

# Compress and encrypt the directory
tar -czvf - /data/ | openssl enc -aes-256-cbc -salt -pbkdf2 -k "$password" -out encrypted_archive.enc

# Transfer the encrypted archive
scp encrypted_archive.enc username@10.110.141.47:/home/username

known_hosts:

#different communication keys are used so each keys gets its own token

10.110.141.47 ssh-rsa 

AAAAB3NzaC1yc2EAAAADAQABAAABgQCpH4MUADzrX2iBVvdsN53yqbMFyP532WB/Ns/F26/AuDL/r2iB83S1d2kIfxKk6oSzUtRnwY90gYAM+Cm8QybCCRbdRxdF52wB0YPWGASlsNgQbc44B0wAQB+pI/LNYedWFhqv8DL5t8aWx49+SfSFJR0TlU0Z++jkbrpBiPeDKRyyaQ7qg9kzNcBZciyltRw246s28dtE+hNHu1zLMPlBG3soFUZEmiQ49Cgq/PgJuOLcU5cFX0LIWx0+qd7kXLikmNUMC1MrEdDcDkPVx3ybCpXwPU1EIjU7NqlXoWaIHkDyMQGTTPj8D+8KHVnKIzccrqOpgt7/iJJPNHaNtJfKdOLnsPrnbcemoWWGrloCiefMrpK4L//ZdgXmpHrfV+v5kPQjHByrJyouff83K5jjWo+Uu4IXW/tSCBe8KRyqdIBoj0MbfaQSJaO0svDURPkdEnovTjgqQyTCsdnW6IhEoKWfJkZkMEN1cM30MriZJNrXXkPMmh+8mdKVck7mBus=

10.110.141.47 ecdsa-sha2-nistp256 

AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBORAtUpfZWty0zrxuth2fr5kjbLo82U1YTckc58XASoQUTIzeLUjy88XxutqhmcPNlZc0e6Yv1uctYzOh9wikHQ=

10.110.141.47 ssh-ed25519 

AAAAC3NzaC1lZDI1NTE5AAAAIIEycicwUI70Gfs6x9nRBeVCwFRsuYfn68AGklgD8buR

id_rsa:

-----BEGIN OPENSSH PRIVATE KEY-----
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
LTE4MC53bGFuLmNwcC5lZHUBAgM=
-----END OPENSSH PRIVATE KEY-----

auto_transfer.sh:

#one possible implementation to run the transfer_script.sh infinitely

#!/bin/bash
while true
do
    # Your command or script here
    /home/Username/transfer_script.sh

    # Sleep for 10 seconds
    sleep 10
done
