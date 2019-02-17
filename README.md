# README #

Splunk TA for bash_history.  For some background, see [Duane's Blog Post](http://duanewaddle.com/splunking-bash-history/).

### Splunk Setup ###

	Sourcetypes: bash_history

	Inputs:  YES
	Index-time config: YES	
	Search-time config: YES	

### Additional setup requirements  ###

In addition to the Splunk setup requirements, you will also need to:

* (as root) mkdir -m 1777 /var/log/bashhist
* Put contents of etc/profile.d into your real /etc/profile.d so it runs for everyone

Or do whatever you have to do on your OS.  MacOS for example does not by default
call /etc/profile.d scripts.  You're kinda on your own, or submit a PR :)
