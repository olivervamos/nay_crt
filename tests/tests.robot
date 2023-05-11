*** Settings ***
Resource    ../resources/keywords.robot
Test Setup    Setup Browser
Test Teardown    CloseBrowser

*** Variables ***
${checkout_txt}    Checkout: Complete
${number_of_items}    3
${search_text}    Samsung

*** Test Cases ***
Basket delete
    [Documentation]    
    Navigate to category
    Sorting high to low
    Price sorting control
    Get Names of items    ${number_of_items}
    Add items to basket    ${number_of_items}
    Open basket
    Get Names of items in basket    ${number_of_items}
    #Should Be Equal    ${NAMES_ITEMS}    ${NAMES_ITEMS_BASKET}
    Verify item name in basket    ${number_of_items}
    Delete from basket and verify remove    0

Search
    [Documentation]
    Type search Text   ${search_text}
    Sleep    5s
    Verify text in every item    ${search_text}

Checkout empty basket
    [Documentation]   
    Open basket
    No checkout
    

    
