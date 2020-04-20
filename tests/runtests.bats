VAGRANT_CMD=/tmp/exec/vagrant

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
