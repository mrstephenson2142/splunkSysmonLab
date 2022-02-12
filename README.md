# Quick Test Lab 

# whatami

This guide will accomplish the following. 
- 3 Server Lab
  - Ubuntu Linux Running [Splunk Enterprise](https://www.splunk.com/en_us/software/splunk-enterprise.html)
  - Windows Server Running Domain Controller and DNS
  - Windows Client Joined to the Server
- Logging into Splunk
- [Sysmon Running Swift On Security Configuration File](https://github.com/SwiftOnSecurity/sysmon-config)
- [Invoke-Atomic Framework Setup](https://github.com/redcanaryco/atomic-red-team)

# whyami 

We take for granted sometimes that we accumulate a lot of knowledge along our journey that allows us to set up a lab of the cool things we see in webinars, Bsides, etc. Not to say that it is out of reach for anyone who wants it, but it might be harder without all of that road knowledge. 

This lab bridges the gap and gives a head start to anyone that wants an environment where they can test scripts or attacks against a Windows environment and see what it looks like in Splunk. If you want to see how logging holds up against tests mapped to the MITRE ATT&CK framework, learn more Splunk, use more PowerShell, and learn Sysmon, read on. 

The goal is to be able to: 

- Run tests using the Invoke-Atomic framework that are mapped to MITRE ATT&CK
- Learn to hunt better in Splunk
- Tune your Sysmon Detections
- Repeat

It doesn't have to stop there, if you have the knowledge and/or Google you can expand on the lab, find new tools to play with, and new data sources to log. You can even dig through the installation scripts in this repo, see what modifications were made, and set up your own labs. 

# Associations 

I am not associated with Red Canary, Atomic Red Team, Microsoft, Swift On Security, Splunk, or any other entity mentioned in this guide. I'm just a guy pulling levers in a lab. 

# Warning 

Don't use this as a production environment, keep it segmented, be safe, do not test anything you're not allowed to. #notlegaladvice. 

# Getting Started 

There is a pretty extensive guide on the setup in this repo, and there are several scripts written that do the majority of the configuration for you. During the setup, you will still have to enter IP addresses, open PowerShell, run scripts, and install operating systems. 

This lab uses evaluation copies of Splunk Enterprise and the Windows Operating Systems, so you'll have to recreate it every once in a while. 

- [Set up the Environment](./Setup.md)
- [Perform Tests](./Testing.md)