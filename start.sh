#!/bin/bash

k="/home/gitlab-runner/id_rsa"
app=remote_jupyter

v=$(ssh -i ${k} runner@172.17.0.1 'echo "$( sudo docker container inspect -f '{{.State.Running}}' '$app' )"')

echo ${v}

if [[ ${v} == 'true' ]]; then
  ssh -i ${k} runner@172.17.0.1 'sudo docker container stop '$app'; sudo docker container rm '$app''
fi

if [[ ${v} == 'false' ]]; then
  ssh -i ${k} runner@172.17.0.1 'sudo docker container rm '$app
fi

ls -l
ssh -i ${k} runner@172.17.0.1 'rm -r '$app'; mkdir '$app'; sudo chown runner '$app
scp -i /home/gitlab-runner/id_rsa -r [!.]* runner@172.17.0.1:$app

ssh -i ${k} runner@172.17.0.1 'cd '$app'; ls'
ssh -i ${k} runner@172.17.0.1 'cd '$app'; sudo docker build -t '$app' .'
f=$(ssh -tt -i ${k} runner@172.17.0.1 'echo "$( cd '$app'; sudo docker run -d -p 8888:8888 --name '$app' '$app' )"')
echo ${f}

ssh -i ${k} runner@172.17.0.1 'sudo docker image prune -a -f'
ssh -i ${k} runner@172.17.0.1 'sudo docker builder prune -a -f'