# ansible-role-sumologic
###### Ansible role to install SumoCollector. This role was inspired by modcloth's SumoCollector role, but it goes one step further by including the ability to include additional log paths.

## Role Variables

### RedHat OS Family
```
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

###  Playbook
```
---
    - hosts: servers
      roles:
         - role: wgregorian.sumocollector
```
### Installation
- via ansible-galaxy
```
    ansible-galaxy install wgregorian.sumocollector
```

    - automated by creating a `requirements.yml` with this block:

```
---
    - src: wgregorian.sumocollector
```

    - and running:

```
    ansible-galaxy install -r requirements.yml
```

## License
###### MIT

## Author Information
###### William Gregorian - CISO, FutureAdvisor.
