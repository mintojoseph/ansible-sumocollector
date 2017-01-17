SumoCollector
--------------
Ansible role to install SumoCollector. This role was based on wgregorian as recommended by Sumo staff.  That was a native install using yum.  
We now support yum, tarball and docker installs.  Hot patches would likely be first available via tarball for testing bugfixes with sumologic team.

Changelog from wgregorian
-------------------------
Switched from single source file to /etc/sumo/sumo.d
Supports automatic docker app logs if using journald or syslog driver.
By default installs sumo as systemd unit running a docker container.
Supports file based (rather than cloud based) management.
Tunes host to avoid sumo errors setting ulimits.
Installs sysstat to host for performance monitoring to support Linux Performance Dashboard.
Sets up cron jobs for sysstat and disk checks.
Installs monitors for traefik and mesos.
Installs host metrics to support Host Metrics dashboard
Transitions from old sumo.conf to recommended user.properties file.

Having extra files in /etc/sumo/sumo.d is not a problem.  If path is not found
sumo blade will not load.  Sumo watches the sourcefile or folder so changes
should be taken up automatically without restarting the process.

Currently only the docker install method is fully supported.  
The yum install seems to lag behind docker and tarball versions
and sumo support recommended the tar or docker install.
The docker container closely resembles the tar install (/opt/SumoCollector).
If a native install is needed, handlers.yml would need to be modified and
a systemd service based on native install should be written for surviving host shutdowns etc.

Role Variables
--------------

Default variables:

# ansible-sumocollector
###### Ansible role to install SumoCollector. This role was inspired by modcloth's SumoCollector role, but it goes one step further by including the ability to include additional log paths.

## Role Variables

### RedHat OS Family
```
For a complete list see defaults.yml

deployment_id: Following sumo best practices, there is a top-level deployment_id which sets
_sourceCategory allowing indexing based on deployment.

# Credentials.  Set these in your environment or over-ride.
sumologic_collector_accessid: "{{ lookup('env', 'SUMO_COLLECTOR_ACCESS_ID' }}"
sumologic_collector_accesskey: "{{ lookup('env', 'SUMO_COLLECTOR_ACCESS_KEY' }}"
sumocollector_installer_rpm: "https://collectors.sumologic.com/rest/download/rpm/64"
sumologic_installer_rpm_local_folder: "/tmp"
```

### Debian OS Family
```
sumologic_installer_remote_file: "/tmp/sumocollector.deb"
sumocollector_installer_download: "https://collectors.sumologic.com/rest/download/deb/64"
```

### Credentials
```
- assuming environment variables $sumologic_collector_accessid and $sumologic_collector_accesskey are set:
sumologic_collector_accessid: "{{ lookup('env','sumologic_collector_accessid') }}"
sumologic_collector_accesskey: "{{ lookup('env','sumologic_collector_accesskey') }}"
```

### Allow overwrite of old collectors. 
- See: https://service.sumologic.com/help/Default.htm#Using_Clobber.htm
```
sumologic_collector_clobber: ""
sumologic_installer_file: ""
sumologic_collector_source_template: "collector.json.j2"
sumologic_collector_timezone: "UTC"
sumologic_collector_force_timezone: "false"
```

### log names and location
- be sure to specify the sumologic_collector_default_log_path variable, as below pattern for 1 or many log locations:
```
sumologic_collector_default_log_path:
  - name: "EXAMPLE LOG"
    path: "/var/log/EXAMPLE.log"
    use_multiline: false
    category: "EXAMPLE"
  - name: "EXAMPLE LOG 2"
    path: "/var/log/EXAMPLEi2.log"
    use_multiline: false
    category: "EXAMPLE2"
```

### Group variable example:
- be sure to specify the sumologic_collector_application_log_path variable, as below pattern for 1 or many log locations:
```
sumologic_collector_application_log_path:
  - name: "APP LOG"
    path: "/var/log/APP.log"
    use_multiline: false
    category: "APP" }
```

## Examples

### Installation

#### via ansible-galaxy
##### installation-A
- run `ansible-galaxy install wgregorian.sumocollector`

###### or
##### installation-B
- requirements.yml

```
---
    - src: wgregorian.sumocollector
```
- and run the following to make the role available to playbook:
`ansible-galaxy install -r requirements.yml`

and running:
`ansible-galaxy install -r requirements.yml`

Example Commandline Options
---------------------------
`ansible-playbook -i /path/to/hosts site.yml -e sumologic_force_restart=yes -e @/ath/to/over-ride-vars.yml`

## Legacy vars for sumo.conf.j2
These could be migrated to user.properties.

```
sumologic_installer_file: ""
sumologic_collector_source_template: "collector.json.j2"
sumologic_collector_timezone: "UTC"
sumologic_collector_force_timezone: "false"
sumologic_collector_default_log_path:
  - name: "EXAMPLE LOG"
    path: "/var/log/EXAMPLE.log"
    use_multiline: false
    category: "EXAMPLE"
```

Group variable example:

```
sumologic_collector_application_log_path:
  - name: "APP LOG"
    path: "/var/log/APP.log"
    use_multiline: false
    category: "APP" }
```

##### playbook
- sample
```
---
    - hosts: servers
      roles:
         - role: wgregorian.sumocollector
```
#### via librarian-ansible
- Ansiblefile
```
role 'ansible-sumocollector',
  git: 'https://github.com/wgregorian/ansible-sumocollector.git'
```
##### playbook
- sample
```
---
- hosts: all
  roles:
  - role: ansible-sumocollector
```
- run the following install role vi librarian-ansible to be available to playbook: `librarian-ansible install`

Troubleshooting
---------------
If there are errors in a source file, it may be difficult to discover.
You can check in the UI by seeing if the file-name shows up in a collector's sources.  You may inspect the json for the source by clicking the info icon.
You can find the errors by changing the source while tailing collector.log
in another shell:

`tail -f /path/to/collector.log | grep blade`

Roadmap
-------
Add sumo api calls to map docker-stats uuid names to nice container names using HTTP source.
Add examples of sumo api calls to configure queries and alerts.
Add dashboard templates via api calls.

License
-------
MIT

Project Contributors
-------
##### William Gregorian - CISO, FutureAdvisor.
##### Kesten Broughton - Sr. Devops Engineer, CognitiveScale
