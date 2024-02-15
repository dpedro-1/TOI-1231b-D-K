# TOI-1231b-D-K
This is a repository for the TOI-1231b team for implimentation of Dockers and Kubernetes at Cal Poly Pomona

## Introduction

This is the drone docking team software repo. It contains the kubernetes configuration
files (.yaml's), Dockerfile, which is what will be created into an image to be 
hosted by the kubernetes cluster system (no file extension), and bash scripts, which
are what the Dockerfile will use to implement the node-level file transfer(.sh).

There are two logic hardware pieces that will go inside the drone: the Pixhawk and
raspberry pi. The Pixhawk is essentially a microcontroller that will have to be
preconfigured with auxillary software (flightplanner), which will provide stability
to the drone through PID controllers. The raspberry pi, on the other hand, is truly
the on-flight computer. It is running an operating system (tentatively alpine linux)
capable of running detection and automation programs and scripts. Since the raspberry pi
4 model B on the drone has a Broadcom BCM2711, Quad core Cortex-A72 (ARM v8 (aarch 64)),
the drone will be capable of running complex tasks besides file transfer. Files will
be created from sensor data, such as alitude, proximity, images, or live video. Since the 
pixhawk has a camera attached to it, this data will be fed through to the raspberry
pi for algorithm purposes.

Some of the functions or operations that the raspberry pi can do on the sensor feed
includes but is not limited to: 

- image processing
- color detection
- path detection
- obstacle avoidance
- proximity controller (PID)

So there are two elements to the software in the onboard computer(raspberry pi):
sensor data processing, and sensor data transfer. 

### Sensor data file transfer (dock complete)

Since a successful dock assumes that the small drone pi and big drone pi are
connected through an gigabit ethernet connection, these tasks are autonmously
accomplished upon detection of ethernet inet6 link.

Overall Purpose:  Enable automated, secure, and IPv6-preferential file transfer
between two Raspberry Pi devices (possibly within a drone context).

Docker functionality:

1. Sets Up Secure Transfer Environment:

   * Prepares an Alpine Linux-based container, installing tools for encryption (OpenSSL) and SSH networking (openssh-client, iproute2).
   * Creates a dedicated .ssh directory and ensures secure permissions on SSH keys.
2. Orchestrates Deployment:

   * Copies your custom 'transfer_script.sh', along with authentication (id_rsa) and trusted hosts information (known_hosts), for running inside the container.
   * Specifies 'transfer_script.sh' as the container's startup command for automated execution.
  
Transfer_scrip.sh Functionality

1. Checks connectivity:
   * Verifies both target Raspberry Pis have functioning IPv6 addresses on their 'eth0' network interfaces, favoring this protocol for transfer.
   
2. Prepares and Encrypts Payload:
   * Compresses files from a designated 'source_dir' into a tar.gz archive for efficient transfer.
   * Encrypts the archive using AES-256 encryption and a specified password for extra security during transit.
3. Secure Transfer (if IPv6 found):
   * Uses 'scp' for an SSH-based file transfer. This leverages pre-configured keys for trusted and automated transmission to the target device.
   
 Some things to note:
 
 * Assumes: This setup presumes preconfigured, passwordless SSH access is configured between the Pis to support seamless automated transfer.
 
 * Emphasis on Security: Both the Dockerfile preparations (permissions) and the script's encryption focus on safe data transfer in potentially untrusted networks.
 Many thanks and Kudos to Isaac for implementing security (additional salt in enc command), it would not have happened without him.
 
### Sensor data processing (dock incomplete)

This is while the drones are not in a docked state (i.e. there is no ethernet connection), or right before docking. There is still work to be accomplished in this
sector. So far, the drone is being assembled, and the connection between the pixhawk
and raspberry pi has not been finalized. This can be accomplished several ways. So far, I have written pseudo code (pythonic) for something that uses this connection 
type: [mavlink](https://docs.px4.io/main/en/companion_computer/pixhawk_rpi.html)

Although, this scheme is not the only way that this connection can be accomplished,
it would be a wise design choice since the pixhawk already has countless sensors, which would then be accessible to the raspberry pi through mavlink. 

Another possible way of accomplishing this would be to have the sensors attached to
the pi itself, though this is a bit redundant, as there needs to be a connection 
established between the pixhawk and raspberry pi, regardless. Available and compatible hardware is a definite concern in electing one connection scheme over the
other. Since we have a pixhawk camera module, I have elected a tentative mavlink connection. 

[Here is my tentative program](./data_processing/pymavl.py)
