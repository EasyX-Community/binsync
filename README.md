# binsync v1.0.1

#### Description
Synchronize bin directory across multiple systems with rsync.

Usage example: You have 5 raspberry pi's all running arm64 raspbian and want to save time compiling once for all machines<br />
Usage example: You have 3 computer's all running amd64 debian and want to save time compiling once for all machines

#### Notes
- It is important the instructions are completed in order!
- You can only have one host machine under one root/user account
- You can have as many client machines as you like, under any root/user account
- Stable release can be obtained from releases page
- Releases will only be generated for major versions

#### Gather client SSH keys
1. Login as non-root user
2. `su` and enter root password if setting up root
3. Generate the key `ssh-keygen` (leave all options including password empty and press enter)
4. chmod 700 /root/.ssh/id_rsa
4. Print the key `cat ${HOME}/.ssh/id_rsa.pub`
5. Copy the line printed out into a notepad (yes it is one giant line)

#### Install keys on host machine
1. Login as non-root user
2. `su` and enter root password if setting up root
3. `nano ${HOME}/.ssh/authorized_keys`
4. Copy the lines from notepad and paste into the file
5. Save & Exit

#### On the host machine
1. Login as non-root user
2. `su` and enter root password if setting up root as the host
3. Change to directory you wish to install repository
4. Clone repo `git clone https://gogs.easyx.cc/EasyX-Community/binsync.git`
5. Change to repository directory `cd binsync`
6. Copy config `cp bin/config.inc.sample bin/config.inc`
7. Edit config `nano bin/config.inc`
8. Execute installer `./install_binsync.sh`
9. Enter in your User, Host, and Directory
10. Note: Do not set up cronjob on the host machine! The clients do the push/pull!

#### On the client(s) machines
1. Login as non-root user
2. `su` and enter root password if setting up root as the client
3. Change to directory you wish to install repository
4. Clone repo `git clone https://gogs.easyx.cc/EasyX-Community/binsync.git`
5. Change to repository directory `cd binsync`
6. Copy config `cp bin/config.inc.sample bin/config.inc`
7. Edit config `nano bin/config.inc`
8. Execute installer `./install_binsync.sh`
9. Enter in your User, Host, and Directory
10. Run manually `binsync-manual`
11. Add cronjob `crontab -e`
12. Add in: `*/5 * * * *             $HOME/bin/binsync-push ; $HOME/bin/binsync-pull ;`
13. Save & Exit

#### Updating (manual)
Make sure you keep both the bin folder and the repository. To update do the following:
1. Run update script `binsync-update`

#### Updating (automatic)
1. Open cronjob editor `crontab -e`
2. Add in: `@weekly                 $HOME/bin/binsync-update ;`

#### Coming features
- Can't think of any at the moment, but please create GitHub or Gogs issue ticket if you have any suggestions.

#### Donations:
**XMR:** 84wwa7EKo8uasZAHijHKtBTuBaMPuNjCJgnfGJrsLFo4aZcfrzGvUX33sSeFNdno8fPiTDGnz4h1bCvsdFQYWRuR2619FzS <br />
**ETH(ERC-20):** 0xc89eEa9b5C0cfa7f583dc1A6405a7d5730ADB603 <br />
**BNB(BSC)** 0xc89eEa9b5C0cfa7f583dc1A6405a7d5730ADB603 <br />
**RTM:** RDg5KstHYvxip77EiGhPKYNL3TZQr6456T <br />
**AVN:** R9zSPpKjo6tCutMT5FyyGNr2vRaAssEtrm <br />
**PHL:** F7XaUosKYEXPP62o31DdpDoADo3VcxoFP4 <br />
**PEXA:** XBghzGLdeUzspUcJpeggPFLs3mAyTRHpPH <br />
