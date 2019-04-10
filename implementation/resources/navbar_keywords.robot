*** Settings ***
Resource    ./general_web_keywords.robot

*** Variables ***

&{search_box}   main=twotabsearchtextbox    music=searchMusic
&{search_button}   main=css=input.nav-input   music=css=button.playerIconSearch


*** Keywords ***
Search keywords
    [Arguments]  ${search}=${EMPTY}
    input text  &{search_box}[${BRAND}]     ${search}
    click element   &{search_button}[${BRAND}]

