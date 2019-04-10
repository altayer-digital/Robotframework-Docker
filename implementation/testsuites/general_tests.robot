*** Settings ***
Resource        ../resources/navbar_keywords.robot
Resource    ../resources/general_web_keywords.robot

Test Setup      Open Browser And Setup
Test Teardown   Close Browser

*** Variables ***

&{search_item}  main=red socks    music=coldplay

*** Test Cases ***

Search Items
    [Documentation]
    ...  It will search for a product
    [Tags]  regression  stable  search
    Verify Logo
    Search keywords  &{search_item}[${BRAND}]