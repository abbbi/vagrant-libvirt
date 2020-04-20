VAGRANT_CMD=/tmp/exec/vagrant
#VAGRANT_CMD=vagrant

@test "Spin up and destroy simple virtual machine" {
  export VAGRANT_CWD=tests/simple
  run ${VAGRANT_CMD} destroy -f
  run ${VAGRANT_CMD} up --provider=libvirt
  echo "status = ${status}"
  [ "$status" -eq 0 ]
  run  ${VAGRANT_CMD} destroy -f
  echo "status = ${status}"
  [ "$status" -eq 0 ]
}

@test "Spin up simple virtual machine, provision via shell" {
  export VAGRANT_CWD=tests/simple_provision_shell
  run ${VAGRANT_CMD} destroy -f
  run ${VAGRANT_CMD} up --provider=libvirt
  echo "status = ${status}"
  [ "$status" -eq 0 ]
  echo "status = ${status}"
  echo "${output}"
  [ $(expr "$output" : ".*Hello.*") -ne 0  ]
  run ${VAGRANT_CMD} destroy -f
  echo "status = ${status}"
  [ "$status" -eq 0 ]
}

@test "Spin up virtual machine with second disk" {
  export VAGRANT_CWD=tests/second_disk
  run ${VAGRANT_CMD} destroy -f
  run ${VAGRANT_CMD} up --provider=libvirt
  [ "$status" -eq 0 ]
  echo "${output}"
  [ $(expr "$output" : ".*second_disk_default-vdb.*") -ne 0  ]
  run ${VAGRANT_CMD} destroy -f
}

@test "Spin up virtual machine, adjust memory settings" {
  export VAGRANT_CWD=tests/memory
  run ${VAGRANT_CMD} destroy -f
  run ${VAGRANT_CMD} up --provider=libvirt
  [ "$status" -eq 0 ]
  echo "${output}"
  [ $(expr "$output" : ".*Memory.*1000M.*") -ne 0  ]
  run ${VAGRANT_CMD} destroy -f
}

@test "Spin up virtual machine, adjust cpu settings" {
  export VAGRANT_CWD=tests/cpus
  run ${VAGRANT_CMD} destroy -f
  run ${VAGRANT_CMD} up --provider=libvirt
  [ "$status" -eq 0 ]
  echo "${output}"
  [ $(expr "$output" : ".*Cpus.*2.*") -ne 0  ]
  run ${VAGRANT_CMD} destroy -f
}

@test "Spin up virtual machine, add private network, check if IP is reachable" {
  export VAGRANT_CWD=tests/private_network
  run ${VAGRANT_CMD} destroy -f
  run ${VAGRANT_CMD} up --provider=libvirt
  [ "$status" -eq 0 ]
  echo "${output}"
  [ $(expr "$output" : ".*Cpus.*2.*") -ne 0  ]
  run fping 10.20.30.40
  [ "$status" -eq 0 ]
  echo "${output}"
  [ $(expr "$output" : ".*alive.*") -ne 0  ]
  run ${VAGRANT_CMD} destroy -f
}
