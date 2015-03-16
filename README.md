# README #

Splunk TA for bash_history.  For some background, see [Duane's Blog Post](http://duanewaddle.com/splunking-bash-history/).

### Splunk Setup ###

	Sourcetypes: bash_history

	Inputs:  YES
	Index-time config: YES	
	Search-time config: YES	

### Additional setup requirements  ###

In addition to the Splunk setup requirements, you will also need to:

* Put bash-history.sh in /usr/local/bin
* (as root) mkdir -m 1777 /var/log/bashhist
* Add to desired users' .profiles  "source /usr/local/bin/bash-history.sh"

