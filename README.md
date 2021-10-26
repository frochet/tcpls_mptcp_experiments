# TCPLS vs MPTCP experiments

This repository is a fork of Quentin DeConinck's [ACM SIGCOMM 2020 Tutorial on Multipath Transport Protocols](https://conferences.sigcomm.org/sigcomm/2020/tutorial-mptp.html).
It contains topologies and scripts to reproduce results from the paper:  

TCPLS: Modern Transport Services with TCP and TLS

## Prerequisites and Setup

To benefit from the hands-on, you need recent versions of the following software installed on your local computer:

* [Vagrant](https://www.vagrantup.com/docs/installation)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

> The remaining of this hands-on assumes that your host is running a Linux-based system.
> However, the commands to run on your local machine are only limited to interactions with vagrant.

To setup the vagrant box, simply `cd` to this folder and run the following commands on your host
```bash
# The first `vagrant up` invocation fetches the vagrant box and runs the provision script.
# It is likely that this takes some time, so launch this command ASAP!
# The following `vagrant reload` command is required to restart the VM with the Multipath TCP kernel.
$ vagrant up; vagrant reload
# Now that your VM is ready, let's SSH it!
$ vagrant ssh
```
Once done, you should be connected to the VM.
To check that your VM's setup is correct, let's run the following commands inside the VM
```bash
$ cd ~; ls
# iproute-mptcp  mininet  minitopo  oflops  oftest  openflow  picotls  pox  pquic
$ uname -a
# Linux ubuntu-bionic 4.14.146.mptcp #17 SMP Tue Sep 24 12:55:02 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```

> Starting from now, we assume that otherwise stated, all commands are run inside the vagrant box. 

The `experiments` folder is shared with the vagrant box, such as the VM can access to this folder containing the experiment files through the `/tcpls_experiments` folder.
The network experiments that we will perform in the remaining of this tutorial rely on [minitopo](https://github.com/frochet/minitopo) which itself is a wrapper of [Mininet](http://mininet.org/). This repository is installed within the Virtual Machine during the provision phase.

## How to run the TCPLS and MPTCP experiments?

We will use the tool `mprun` that stems from minitopo's installation.
This tools allows to launch scripted experiments over a given topology,
doing:  

```bash
mprun -t topo_file -x xp_file
```

Where `topo_file` is the file containing the description of a network
scenario and `xp_file` the one with the description of the experiment to
perform.

### Generating TCPLS vs MTPCP results (Fig 11.)

So, in the VM, go into /tcpls_experiments/tcpls and let's start with the
MPTCP aggregation experiment (Figure 11 Bandwidth Aggregation, comparing
MPTCP with TCPLS). You'll run an experiment outputing two log files, one
containing the transfert goodput, and one containing a tcpdump trace.

```bash
mprun -t topo_aggregation -x xp_mptcp_aggregation
```

Wait until it completes (~20 to 30 seconds). You'll get the file
`client_tcpdump.log`. move this file to another directory. You'll need
to convert it to the right format for the plot script, using
[convert_tcpdump.py](https://github.com/pluginized-protocols/picotcpls/blob/master/t/ipmininet/convert_tcpdump.py).
Name the coverted file `mptcp_client_tcpdump_pruned_aggregation.log` if
you want a drop in replacement for the global plot script (plots.sh,
calling all .py plot scripts). The name of the goodput file generated is
written in xp_mptcp_aggregation (should be
`mptcp_client_goodput_aggregation.log`).

Now to generate TCPLS' result, first deactivate MPTCP on the Vagrant
box:

```bash
sysctl net.mptcp.mptcp_enabled=0
```
Then launch the TCPLS bandwidth aggregation experiment:

```bash
mprun -t topo_aggegation -x xp_tcpls_aggregation
``` 

Again, that will spin the experiment in the background and give you a
`client_tcpdump.log` and a goodput .log file. The tcpdump one needs also
to be converted.

### Generating Recovery Stress-test (Fig. 9) results

Let's start with MPTCP first. Enable MPTCP back :)

```bash
sysctl net.mptcp.mptcp_enabled=1
```
Then you may run the following automated experiment:

```bash
mprun -t topo_two_client_paths_two_server_paths -x xp_mptcp_drop
```

This script will also output a client_tcpdump.log to convert, and a
goodput file.

Now disable MPTCP, and do the same for TCPLS:

```bash
mprun -t topo_two_client_paths_two_server_paths -x xp_tcpls_drop
```

In total, you should get 4 .log files, and the tcpdump ones need to be
converted using convert_tcpdump.py before using the plot script.




