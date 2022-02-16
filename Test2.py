#!/usr/bin/env python3
import os
from os.path import expanduser
home = expanduser("~")
bash_command = ["cd ~/PycharmProjects/devops-netology/", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
#    print(result)
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(f'{home}/PycharmProjects/devops-netology/{prepare_result}')
        print(prepare_result)
