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
   Should Be Equal    ${NAMES_ITEMS}    ${NAMES_ITEMS_BASKET}
   Delete from basket and verify remove

Search
    [Documentation]
    #Type search Text   ${search_text}
    TypeText    //input[contains(@name, 'search')]    ${search_text}    anchor=//div[contains(@class,'den-xs hidden-sm')]
    ClickElement    //i[contains(@class, 'ico ico--magnifying-glass')]    anchor=//div[contains(@class,'den-xs hidden-sm')]
    Sleep    1s 
    Verify text in every item    ${search_text}

Checkout empty basket
   [Documentation]   
   #ClickText    0,00 €
   #ClickText    Prejsť do nákupného košíka
   Open basket
   No checkout
    

    
