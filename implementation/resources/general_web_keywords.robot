*** Settings ***
Library    Selenium2Library
Library    Collections
Library    DebugLibrary
Library    String
Library    FakerLibrary
Library    OperatingSystem
Library    XvfbRobot
Library    RequestsLibrary
Library    ../../execution/lib/AltayerLib.py
Library    ../../execution/lib/SeleniumHelperLib.py


*** Variables ***

${BROWSER}                        chrome
${BROWSER_SELECTOR}               mac_chrome
${PLATFORM_SELECTOR}              windows
${DEFAULT_WINDOWS_VERSION}        10
${DEFAULT_MAC_VERSION}            Sierra
${REMOTE_DESIRED}                 ${false}
${SELENIUM_TIMEOUT}               10 seconds
${IS_IE}                          ${false}
${REMOTE_SESSION}                 get session id
&{CHECK_ELEMENT}                  main=nav-logo    music=.musicLogo
${BRAND}                          main
${VERSION}                        prod
${DOMAIN}                         ae
${BSUser}                         PUT_BROWSER_STACK_USER
${AccessKey}                      PUT_BROWSER_STACK_ACCESS_KEY
${REMOTE_URL}                     http://${BSUser}:${AccessKey}@hub.browserstack.com:80/wd/hub
${LANGUAGE}                       ${EMPTY}
${COUNTRY}                        ${EMPTY}
${WEB_SITE}                       www.amazon.com
${ADMIN_URL}
${TEST NAME}                      NONE
${SUITE NAME}                     NONE
${TMP_PATH}                 /tmp
&{timeouts}  min=10s  mid=30s  max=60s

*** Keywords ***

Check website version
    [Arguments]  ${brand}=${BRAND}  ${version}=${VERSION}   ${domain}=${DOMAIN}     ${language}=${LANGUAGE}     ${country}=${COUNTRY}
    [Documentation]  This verfies the version of the website and updates the website URL
    ${authentication_part}=     set variable if  '${version}' == 'beta'  or   '${version}' == 'alpha'  or   '${version}' == 'uat'    ${http_user}:${http_pass}@
    ...     ${EMPTY}
    ${version_to_sent}=     set variable if  '${version}' == 'beta' or '${version}' == 'alpha' or '${version}' == 'uat'       non-prod
    ...  prod

    ${temp_url} =   generate website url  ${version_to_sent}  ${language}  ${country}  ${brand}
    ${temp_admin_url} =    generate admin url   ${BRAND}

    set global variable  ${WEB_SITE}  https://${version}${temp_url}
    set global variable  ${ADMIN_URL}  ${temp_admin_url}/admin/

    ${url}=     set variable if
    ...         '${version}' == 'beta' or '${version}' == 'alpha' or '${version}' == 'uat'  https://${http_user}:${http_pass}@${version}${temp_url}
    ...         https://${temp_url}
    [Return]    ${url}

Open Browser And Setup
    [Documentation]  Open browser with parameters
    ${final_url}=  check website version  ${BRAND}  ${VERSION}   ${DOMAIN}     ${LANGUAGE}    ${COUNTRY}
    ${FINAL_SITE}  Set Variable  ${final_url}
    @{parts}  split string  ${suite_name}  .

    &{windows_ie_11}  Create Dictionary  browserName=internet explorer  platform=WINDOWS  os_version=10     project=altayer (${BRAND})  ignoreProtectedModeSettings=${True}  ie.ensureCleanSession=${True}    name=[Test-name: @{parts}[3] - ${test_name}]
    &{mac_safari}  Create Dictionary  platform=MAC  browserName=safari  resolution=1280x1024  project=altayer (${BRAND})  name=[Test-name: @{parts}[3] - ${test_name}]
    &{mac_chrome}     Create Dictionary  platform=MAC   browserName=chrome   resolution=1280x1024  project=altayer (${BRAND})  browser_version=61     name=[Test-name: @{parts}[3] - ${test_name}]  browserstack.debug=true  browserstack.networkLogs=true
    &{mac_firefox}     Create Dictionary  platform=MAC   browserName=firefox   resolution=1280x1024  project=altayer (${BRAND})   name=[Test-name: @{parts}[3] - ${test_name}]
    &{grid_chrome}     Create Dictionary  browserName=chrome  platform=LINUX

    set tags  ${BROWSER_SELECTOR}
    Run Keyword If  '${BROWSER_SELECTOR}'=='windows_10_ie_11'   Open Browser  ${FINAL_SITE}  remote_url=${REMOTE_URL}  browser=&{windows_ie_11}[browserName]  desired_capabilities=&{windows_ie_11}
    ...  ELSE IF  '${BROWSER_SELECTOR}'=='firefox'   Open FF Browser  ${FINAL_SITE}  remote_url=${REMOTE_URL}  browser=&{mac_firefox}[browserName]  desired_capabilities=&{mac_firefox}
    ...  ELSE IF  '${BROWSER_SELECTOR}'=='mac_chrome'   Open CH Browser  ${FINAL_SITE}  remote_url=${REMOTE_URL}    browser=&{mac_chrome}[browserName]  desired_capabilities=&{mac_chrome}
    ...  ELSE IF  '${BROWSER_SELECTOR}'=='grid_chrome'  Open CH Browser  ${FINAL_SITE}  remote_url=${REMOTE_URL}    browser=&{grid_chrome}[browserName]  desired_capabilities=&{grid_chrome}
    ...  ELSE  Open Browser   ${WEB_SITE}  remote_url=${False}  browser=${BROWSER}

    Set Selenium Timeout  ${SELENIUM_TIMEOUT}
    run keyword if  ${IS_IE}  Fix Auth

Open FF Browser
    [Arguments]  ${site}  ${remote_url}  ${browser}  ${desired_capabilities}
    Open Browser  ${site}  remote_url=${remote_url}  browser=${browser}  desired_capabilities=${desired_capabilities}
    sleep  1s
    ${randomString}=  Generate Random String
    Go To  ${WEB_SITE}/?${randomString}

Open CH Browser
    [Arguments]  ${site}  ${remote_url}  ${browser}  ${desired_capabilities}
    ${remote_url}=  run keyword if  ${REMOTE_DESIRED} == ${False}   Local settings for Chrome
    ...     ELSE    set variable  ${remote_url}
    run keyword if  ${REMOTE_DESIRED} == ${True}   Open Browser  ${web_site}  remote_url=${remote_url}  browser=${browser}  desired_capabilities=${desired_capabilities}
    run keyword if  ${REMOTE_DESIRED} == ${True}   Get build and session id and print it on console
    ${randomString}=  Generate Random String
    Go To    ${site}/

Get build and session id and print it on console
    ${REMOTE_SESSION}=    Selenium2Library.get session id
    ${build_id}=  get_browser_stack_build_id  ${BSUser}  ${AccessKey}
    log to console   ${\n}Browser Stack Session: https://automate.browserstack.com/builds/${build_id}/sessions/${remote_session}

Local settings for Chrome
    Start Virtual Display    1920    1080
    ${options}  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Call Method  ${options}  add_argument  --no-sandbox
    ${prefs}    Create Dictionary    download.default_directory=${TMP_PATH}
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    Create Webdriver    Chrome    chrome_options=${options}
    [Return]  ${EMPTY}

Open IE Browser
    [Arguments]  ${web_site}  ${remote_url}  ${browser}  ${desired_capabilities}
    Open Browser  ${web_site}  remote_url=${remote_url}  browser=${browser}  desired_capabilities=${desired_capabilities}
    Set Suite Variable  ${IS_IE}  ${True}

Fix Auth
    wait until page contains element  q
    Go To Link  /

Click Text
    [Arguments]  ${text}  ${wait}=True
    Click Element  xpath=(//*[contains(text(),"${text}")])[1]
    run keyword if  ${wait}  sleep  0.5s

Go To Link
    [Arguments]  ${link}
    go to  ${WEB_SITE}/${link}
    Wait Until Page Contains Element  &{CHECK_ELEMENT}[${BRAND}]    5s
    sleep  2s

Go Back and Wait
    go back
    Wait Until Page Contains Element  &{CHECK_ELEMENT}[${BRAND}]    5s
    sleep  2s

Save Screenshot
    [Arguments]  ${index}=1
    ${str}=     replace string      ${test_name}     ${space}     _
    ${str2}=     replace string      ${test_name}     _-_     -
    Capture Page Screenshot    screenshots${/}${str2}-${index}.png
    File Should Exist    results/screenshots${/}${str2}-${index}.png

Verify Logo
    Wait Until Page Contains Element  &{CHECK_ELEMENT}[${BRAND}]  &{timeouts}[max]