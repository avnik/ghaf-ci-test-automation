# SPDX-FileCopyrightText: 2022-2024 Technology Innovation Institute (TII)
# SPDX-License-Identifier: Apache-2.0

*** Settings ***
Documentation       Gathering performance data
Force Tags          performance
Resource            ../../resources/ssh_keywords.resource
Resource            ../../resources/device_control.resource
Resource            ../../config/variables.robot
Resource            ../../resources/performance_keywords.resource
Library             ../../lib/output_parser.py
Library             ../../lib/PerformanceDataProcessing.py  ${DEVICE}  ${BUILD_ID}  ${JOB}
Library             Collections
Suite Setup         Common Setup
Suite Teardown      Close All Connections

*** Variables ***
@{changed_VM_tests}


*** Test Cases ***

CPU One thread test
    [Documentation]     Run a CPU benchmark using Sysbench with a duration of 10 seconds and a SINGLE thread.
    ...                 The benchmark records to csv CPU events per second, events per thread, and latency data.
    ...                 Create visual plots to represent these metrics comparing to previous tests.
    [Tags]              cpu  SP-T67-1  nuc  orin-agx  orin-nx  lenovo-x1
    ${output}           Execute Command    sysbench cpu --time=10 --threads=1 --cpu-max-prime=20000 run
    Log                 ${output}
    &{cpu_data}         Parse Cpu Results   ${output}
    &{statistics}       Save Cpu Data       ${TEST NAME}  ${cpu_data}
    Log                 <img src="${DEVICE}_${TEST NAME}.png" alt="CPU Plot" width="1200">    HTML
    IF  "${statistics}[flag]" == "1"
        ${fail_msg}     Create fail message  ${statistics}
        FAIL            ${fail_msg}
    END

CPU multimple threads test
    [Documentation]     Run a CPU benchmark using Sysbench with a duration of 10 seconds and MULTIPLE threads.
    ...                 The benchmark records to csv CPU events per second, events per thread, and latency data.
    ...                 Create visual plots to represent these metrics comparing to previous tests.
    [Tags]              cpu  SP-T67-2  nuc  orin-agx  orin-nx  lenovo-x1
    ${output}           Execute Command    sysbench cpu --time=10 --threads=${threads_number} --cpu-max-prime=20000 run
    Log                 ${output}
    &{cpu_data}         Parse Cpu Results   ${output}
    &{statistics}       Save Cpu Data       ${TEST NAME}  ${cpu_data}
    Log                 <img src="${DEVICE}_${TEST NAME}.png" alt="CPU Plot" width="1200">    HTML
    IF  "${statistics}[flag]" == "1"
        ${fail_msg}     Create fail message  ${statistics}
        FAIL            ${fail_msg}
    END

Memory Read One thread test
    [Documentation]     Run a memory benchmark using Sysbench for 60 seconds with a SINGLE thread.
    ...                 The benchmark records Operations Per Second, Data Transfer Speed, Average Events per Thread,
    ...                 and Latency for READ operations.
    ...                 Create visual plots to represent these metrics comparing to previous tests.
    [Tags]              memory  SP-T67-3  nuc  orin-agx  orin-nx  lenovo-x1
    ${output}           Execute Command    sysbench memory --time=60 --memory-oper=read --threads=1 run
    Log                 ${output}
    &{mem_data}         Parse Memory Results   ${output}
    &{statistics}       Save Memory Data       ${TEST NAME}  ${mem_data}
    Log                 <img src="${DEVICE}_${TEST NAME}.png" alt="Mem Plot" width="1200">    HTML
    IF  "${statistics}[flag]" == "1"
        ${fail_msg}     Create fail message  ${statistics}
        FAIL            ${fail_msg}
    END

Memory Write One thread test
    [Documentation]     Run a memory benchmark using Sysbench for 60 seconds with a SINGLE thread.
    ...                 The benchmark records Operations Per Second, Data Transfer Speed, Average Events per Thread,
    ...                 and Latency for WRITE operations.
    ...                 Create visual plots to represent these metrics comparing to previous tests.
    [Tags]              memory  SP-T67-4  nuc  orin-agx  orin-nx  lenovo-x1
    ${output}           Execute Command    sysbench memory --time=60 --memory-oper=write --threads=1 run
    Log                 ${output}
    &{mem_data}         Parse Memory Results   ${output}
    &{statistics}       Save Memory Data       ${TEST NAME}  ${mem_data}
    Log                 <img src="${DEVICE}_${TEST NAME}.png" alt="Mem Plot" width="1200">    HTML
    IF  "${statistics}[flag]" == "1"
        ${fail_msg}     Create fail message  ${statistics}
        FAIL            ${fail_msg}
    END

Memory Read multimple threads test
    [Documentation]     Run a memory benchmark using Sysbench for 60 seconds with MULTIPLE threads.
    ...                 The benchmark records Operations Per Second, Data Transfer Speed, Average Events per Thread,
    ...                 and Latency for READ operations.
    ...                 Create visual plots to represent these metrics comparing to previous tests.
    [Tags]              memory  SP-T67-5  nuc  orin-agx  orin-nx  lenovo-x1
    ${output}           Execute Command    sysbench memory --time=60 --memory-oper=read --threads=${threads_number} run
    Log                 ${output}
    &{mem_data}         Parse Memory Results   ${output}
    ${statistics}       Save Memory Data       ${TEST NAME}  ${mem_data}
    Log                 <img src="${DEVICE}_${TEST NAME}.png" alt="Mem Plot" width="1200">    HTML
    IF  "${statistics}[flag]" == "1"
        ${fail_msg}     Create fail message  ${statistics}
        FAIL            ${fail_msg}
    END

Memory Write multimple threads test
    [Documentation]     Run a memory benchmark using Sysbench for 60 seconds with MULTIPLE threads.
    ...                 The benchmark records Operations Per Second, Data Transfer Speed, Average Events per Thread,
    ...                 and Latency for WRITE operations.
    ...                 Create visual plots to represent these metrics comparing to previous tests.
    [Tags]              memory  SP-T67-6  nuc  orin-agx  orin-nx  lenovo-x1
    ${output}           Execute Command    sysbench memory --time=60 --memory-oper=write --threads=${threads_number} run
    Log                 ${output}
    &{mem_data}         Parse Memory Results   ${output}
    &{statistics}       Save Memory Data       ${TEST NAME}  ${mem_data}
    Log                 <img src="${DEVICE}_${TEST NAME}.png" alt="Mem Plot" width="1200">    HTML
    IF  "${statistics}[flag]" == "1"
        ${fail_msg}     Create fail message  ${statistics}
        FAIL            ${fail_msg}
    END

FileIO test
    [Documentation]     Run a fileio benchmark using Sysbench for 30 seconds with MULTIPLE threads.
    ...                 The benchmark records File Operations, Throughput, Average Events per Thread,
    ...                 and Latency for read and write operations.
    ...                 Create visual plots to represent these metrics comparing to previous tests.
    [Tags]              fileio  SP-T67-7  nuc  orin-agx  orin-nx  lenovo-x1

    Transfer FileIO Test Script To DUT
    Execute Command      ./fileio_test ${threads_number}  sudo=True  sudo_password=${PASSWORD}

    ${fileio_rd_output}  Execute Command    cat sysbench_results/fileio_rd_report
    Log                  ${fileio_rd_output}
    &{fileio_rd_data}    Parse FileIO Read Results   ${fileio_rd_output}
    &{statistics_rd}     Save FileIO Data       ${TEST NAME}_read  ${fileio_rd_data}

    ${fileio_wr_output}  Execute Command    cat sysbench_results/fileio_wr_report
    Log                  ${fileio_wr_output}
    &{fileio_wr_data}    Parse FileIO Write Results   ${fileio_wr_output}
    &{statistics_wr}     Save FileIO Data       ${TEST NAME}_write  ${fileio_wr_data}

    Log    <img src="${DEVICE}_${TEST NAME}_read.png" alt="Mem Plot" width="1200">    HTML
    Log    <img src="${DEVICE}_${TEST NAME}_write.png" alt="Mem Plot" width="1200">   HTML

    ${fail_msg}=  Set Variable  ${EMPTY}
    IF  "${statistics_rd}[flag]" == "1"
        ${add_msg}     Create fail message  ${statistics_rd}
        ${fail_msg}=    Set Variable  READ:\n${add_msg}
    END
    IF  "${statistics_wr}[flag]" == "1"
        ${add_msg}      Create fail message  ${statistics_rd}
        ${fail_msg}=    Set Variable  ${fail_msg}\nWRITE:\n${add_msg}
    END
    IF  "${statistics_rd}[flag]" == "1" or "${statistics_wr}[flag]" == "1"
        FAIL            ${fail_msg}
    END

Sysbench test in NetVM
    [Documentation]      Run CPU and Memory benchmark using Sysbench in NetVM.
    [Tags]               SP-T67-8    nuc  orin-agx  orin-nx  lenovo-x1

    Transfer Sysbench Test Script To NetVM
    ${output}            Execute Command    ./sysbench_test 1  sudo=True  sudo_password=${PASSWORD}

    &{threads}    	            Create Dictionary	 net-vm=1
    Save sysbench results       net-vm   _1thread

    &{statistics_cpu}       Read CPU csv and plot  net-vm_${TEST NAME}_cpu_1thread
    &{statistics_mem_rd}    Read Mem csv and plot  net-vm_${TEST NAME}_memory_read_1thread
    &{statistics_mem_wr}    Read Mem csv and plot  net-vm_${TEST NAME}_memory_write_1thread

    Log    <img src="${DEVICE}_net-vm_${TEST NAME}_cpu_1thread.png" alt="CPU Plot" width="1200">       HTML
    Log    <img src="${DEVICE}_net-vm_${TEST NAME}_memory_read_1thread.png" alt="Mem Plot" width="1200">    HTML
    Log    <img src="${DEVICE}_net-vm_${TEST NAME}_memory_write_1thread.png" alt="Mem Plot" width="1200">    HTML

    ${fail_msg}=  Set Variable  ${EMPTY}
    IF  "${statistics_cpu}[flag]" == "1"
        ${add_msg}      Create fail message  ${statistics_cpu}
        ${fail_msg}=    Set Variable  CPU:\n${add_msg}
    END
    IF  "${statistics_mem_rd}[flag]" == "1"
        ${add_msg}      Create fail message  ${statistics_mem_rd}
        ${fail_msg}=    Set Variable  ${fail_msg}\nMEM READ:\n${add_msg}
    END
    IF  "${statistics_mem_wr}[flag]" == "1"
        ${add_msg}      Create fail message  ${statistics_mem_wr}
        ${fail_msg}=    Set Variable  ${fail_msg}\nMEM WRITE:\n${add_msg}
    END
    IF  "${statistics_cpu}[flag]" == "1" or "${statistics_mem_rd}[flag]" == "1" or "${statistics_mem_wr}[flag]" == "1"
        FAIL  ${fail_msg}
    END

Sysbench test in VMs on LenovoX1
    [Documentation]      Run CPU and Memory benchmark using Sysbench in Virtual Machines
    ...                  for 1 thread and MULTIPLE threads if there are more than 1 thread in VM.
    [Tags]               SP-T67-9    lenovo-x1
    [Setup]         LenovoX1 Setup
    &{threads}    	Create Dictionary    net-vm=1
    ...                                  gui-vm=2
    ...                                  gala-vm=2
    ...                                  zathura-vm=1
    ...                                  chromium-vm=4
    ${vms}	Get Dictionary Keys	 ${threads}
    @{failed_vms} 	Create List
    Set Global Variable  @{failed_vms}

    Connect to netvm

    FOR	 ${vm}	IN	@{vms}
        ${threads_n}	Get From Dictionary	  ${threads}	 ${vm}
        ${vm_fail}      Transfer Sysbench Test Script To VM   ${vm}
        IF  '${vm_fail}' == 'FAIL'
            Log to Console  Skipping tests for ${vm} because couldn't connect to it
        ELSE
            ${output}       Execute Command       ./sysbench_test ${threads_n}  sudo=True  sudo_password=${PASSWORD}
            Run Keyword If    ${threads_n} > 1   Save sysbench results   ${vm}
            Save sysbench results   ${vm}   _1thread
            Switch Connection    ${netvm_ssh}
        END
    END

    Read VMs data CSV and plot  test_name=${TEST NAME}  vms_dict=${threads}

    Log    <img src="${DEVICE}_${TEST NAME}_cpu_1thread.png" alt="CPU Plot" width="1200">       HTML
    Log    <img src="${DEVICE}_${TEST NAME}_memory_read_1thread.png" alt="Mem Plot" width="1200">    HTML
    Log    <img src="${DEVICE}_${TEST NAME}_memory_write_1thread.png" alt="Mem Plot" width="1200">    HTML

    Log    <img src="${DEVICE}_${TEST NAME}_cpu.png" alt="CPU Plot" width="1200">       HTML
    Log    <img src="${DEVICE}_${TEST NAME}_memory_read.png" alt="Mem Plot" width="1200">    HTML
    Log    <img src="${DEVICE}_${TEST NAME}_memory_write.png" alt="Mem Plot" width="1200">    HTML

    ${length}       Get Length    ${failed_vms}

    ${isEmpty}    Run Keyword And Return Status    Should Be Empty    ${changed_VM_tests}
    IF  ${isEmpty} == False
        IF  ${length} > 0
            FAIL    Deviation detected in the following tests: "${changed_VM_tests}"\nSome of VMs were not tested due to connection fail: ${failed_vms}
        ELSE
            FAIL    Deviation detected in the following tests: "${changed_VM_tests}"
        END
    ELSE
        Run Keyword If  ${length} > 0    Fail    Some of VMs were not tested due to connection fail: ${failed_vms}
    END

    ${isEmpty}    Run Keyword And Return Status    Should Be Empty    ${changed_VM_tests}
    ${fail_msg}=  Set Variable  ${EMPTY}
    IF  ${isEmpty} == False
      ${fail_msg}=  Set Variable  Deviation detected in the following tests: "${changed_VM_tests}"\n
    END
    IF  ${length} > 0
      ${fail_msg}=  Set Variable  ${fail_msg}These VMs were not tested due to connection fail: ${failed_vms}
    END
    IF  ${isEmpty} == False or ${length} > 0
        FAIL  ${fail_msg}
    END


*** Keywords ***

Common Setup
    Set Variables   ${DEVICE}
    Connect

LenovoX1 Setup
    [Documentation]    Reboot LenovoX1     # currently it's needed, bc dns doesn't work after net-vm restarting, to be deleted after fix
    Reboot LenovoX1
    ${port_22_is_available}     Check if ssh is ready on device   timeout=180
    IF  ${port_22_is_available} == False
        FAIL    Failed because port 22 of device was not available, tests can not be run.
    END
    Connect
    ${output}          Execute Command    ssh-keygen -R ${NETVM_IP}

Transfer FileIO Test Script To DUT
    Put File           performance-tests/fileio_test    /home/ghaf
    Execute Command    chmod 777 fileio_test

Transfer Sysbench Test Script To NetVM
    Connect to netvm
    Put File           performance-tests/sysbench_test    /home/ghaf
    Execute Command    chmod 777 sysbench_test

Transfer Sysbench Test Script To VM
    [Arguments]        ${vm}
    IF  "${vm}" != "net-vm"
        ${vm_fail}    ${result} =    Run Keyword And Ignore Error    Connect to VM    ${vm}
        Run Keyword If    '${vm_fail}' == 'FAIL'   Append To List	 ${failed_vms}	  ${vm}
        Run Keyword If    '${vm_fail}' == 'FAIL'   Return From Keyword  ${vm_fail}
        Log to console    Successfully connected to ${vm}
    END
    Put File           performance-tests/sysbench_test    /home/ghaf
    Execute Command    chmod 777 sysbench_test

Save cpu results
    [Arguments]        ${test}=cpu  ${host}=ghaf_host

    ${output}          Execute Command       cat sysbench_results/${test}_report
    Log                ${output}
    &{data}            Parse Cpu Results     ${output}
    &{statistics}      Save Cpu Data         ${host}_${TEST NAME}_${test}  ${data}
    IF  "${statistics}[flag]" == "1"
        Append To List     ${changed_VM_tests}        ${host}_${test}
        Log to console     Deviation detected in test: ${host}_${test}
    END

Save memory results
    [Arguments]        ${test}=memory_read  ${host}=ghaf_host

    ${output}          Execute Command       cat sysbench_results/${test}_report
    Log                ${output}
    &{data}            Parse Memory Results  ${output}
    &{statistics}      Save Memory Data      ${host}_${TEST NAME}_${test}  ${data}
    IF  "${statistics}[flag]" == "1"
        Append To List     ${changed_VM_tests}        ${host}_${test}
        Log to console     Deviation detected in test: ${host}_${test}
    END

Save sysbench results
    [Arguments]       ${host}    ${1thread}=${EMPTY}
    Save cpu results      test=cpu${1thread}           host=${host}
    Save memory results   test=memory_read${1thread}   host=${host}
    Save memory results   test=memory_write${1thread}  host=${host}
