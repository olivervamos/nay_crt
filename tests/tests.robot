*** Settings ***
Resource    ../resources/keywords.robot
Test Setup    Setup Browser
Test Teardown    CloseBrowser

*** Variables ***
${checkout_txt}    Checkout: Complete
${number_of_items}    3
${search_text}    samsung

*** Test Cases ***
Basket delete
   [Documentation]    Delete all items in basket and check they were deleted
   Accept Cookies
   Navigate to category
   Sorting high to low
   Price sorting control
   Get Names of items    ${number_of_items}
   Add items to basket    ${number_of_items}
   Open basket
   Get Names of items in basket    ${number_of_items}
   Should Be Equal    ${NAMES_ITEMS}    ${NAMES_ITEMS_BASKET}
   Delete from basket and verify remove

Search
    [Documentation]
    Accept Cookies
    Type search Text    ${search_text}

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