# SPDX-FileCopyrightText: 2022-2023 Technology Innovation Institute (TII)
# SPDX-License-Identifier: Apache-2.0

*** Settings ***
Documentation       Common system tests
Resource            ../../resources/ssh_keywords.resource

*** Test Cases ***

Test ghaf version format
    [Documentation]    Test getting Ghaf version and verify its format:
    ...                Expected format: major.minor.yyyymmdd.commit_hash
    [Tags]             bat   SP-T59
    [Setup]     Connect
    Verify Ghaf Version Format
    [Teardown]  Close All Connections

Test nixos version format
    [Documentation]    Test getting Nixos version and verify its format:
    ...                Expected format: major.minor.yyyymmdd.commit_hash (name)
    [Tags]             bat   SP-T60
    [Setup]     Connect
    Verify Nixos Version Format
    [Teardown]  Close All Connections


