*** Settings ***
Resource    ../resources/keywords.robot
Test Setup    Setup Browser
Test Teardown    CloseBrowser

*** Variables ***
${checkout_txt}    Checkout: Complete

*** Test Cases ***
Basket delete
   [Documentation]    Delete all items in basket and check they were deleted
   Get users credentials
   Log into    ${STANDARD_USER_LOGIN}    ${PASSWORD}
   Sorting high to low
   Price sorting control
   Add items to basket    3
   Open basket
   Price sorting control in basket
   Delete from basket    3
   Verify No Element    //button[contains(@name,'remove')]

Checkout
   [Documentation]    Completes the order and checks if the order was successful
   Get users credentials
   Log into    ${STANDARD_USER_LOGIN}    ${PASSWORD}
   Sorting high to low
   Price sorting control
   Add items to basket    3
   Open basket
   Price sorting control in basket
   Checkout and fill data    x    xx    00000
   Verify Text    ${checkout_txt}