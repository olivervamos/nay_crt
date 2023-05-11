*** Settings ***
Library    QWeb
Library    String
Library    Collections

*** Variables ***

*** Keywords ***
Setup Browser
    OpenBrowser    about:blank    chrome
    GoTo    https://www.tpd.sk/    
    Click Element    //button[contains(@id,'AllowAll')]    #accept cookies

Navigate to category
    Hover Text    Počítače a smartfóny
    Click Text    Mobilné Telefóny    smartfóny Samsung

Sorting high to low
    Click Text    Od najdrahšieho
    
Price sorting control
    #Create List of prices
    ${elements_count}    Get Element Count    //div[contains(@class,'products__item')]
    ${price_list}    Create List
    FOR    ${counter}    IN RANGE    ${elements_count}
        ${xpath}    Set Variable    //div[contains(@class,'products__item')][${counter}+1]//span[contains(@class,'number left')]
        ${price_txt}    Get Text    ${xpath}    between=???€
        ${price_txt2}    Remove String    ${price_txt}    ${SPACE}
        ${price_txt3}    Fetch From Left    ${price_txt2}    ,
        ${price_num}    Convert To Number    ${price_txt3}
        Append To List    ${price_list}    ${price_num}
    END
    #Price sorting control
    ${ListCount-1}=    Evaluate    ${elements_count}-1
       FOR    ${counter}    IN RANGE    ${elements_count}
           ${counter+1}=    Evaluate    ${counter}+1
           IF    $counter == ${ListCount-1}    BREAK
           ${ListItem1}=    Get From List    ${price_list}    ${counter}
           ${ListItem2}=    Get From List    ${price_list}    ${counter+1}
           Should Be True    ${ListItem1}>=${ListItem2}
           Log    ${ListItem1}' and '${ListItem2}
       END

Get Names of items
    [Arguments]    ${num_of_items}
    ${NAMES_ITEMS}    Create List
    FOR    ${counter}    IN RANGE    ${num_of_items}
        ${name}    Get Text    //div[contains(@class,'products__item')][${counter}+1]//div[contains(@class,'valign')]    between=???${SPACE}- 
        Append To List    ${NAMES_ITEMS}    ${name}
    END
    Set Test Variable    ${NAMES_ITEMS}
    Log    List of items names after sorting> ${NAMES_ITEMS}

Get Names of items in basket
    [Arguments]    ${num_of_items}
    ${NAMES_ITEMS_BASKET}    Create List
    FOR    ${counter}    IN RANGE    ${num_of_items}
        ${name}    Get Text    //div[contains(@class,'cart__products__row ')][${counter}+1]//strong 
        Append To List    ${NAMES_ITEMS_BASKET}    ${name}
    END
    Set Test Variable    ${NAMES_ITEMS_BASKET}
    Log    List of items names in basket> ${NAMES_ITEMS_BASKET}
    
Verify item name in basket
    [Arguments]    ${num_of_items}
    FOR    ${counter}    IN RANGE    ${num_of_items}
        ${txt_for_verify}    Get From List    ${NAMES_ITEMS}    ${counter}
        VerifyText    ${txt_for_verify}
        Log    ${txt_for_verify}
    END
    
Add items to basket
#Add 3 most expensive items to basket 
    [Arguments]    ${num_of_items}                      
    FOR    ${counter}    IN RANGE    ${num_of_items}
        #${element_num}    Evaluate    ${counter}+1
        Click Element    //div[contains(@class,'products__item')][${counter}+1]//button[contains(@class,'buy')]
        Click Element    //a[contains(@data-dismiss,'modal')]
    END

Open basket
    Click Element    //a[contains(@title,'Zobraziť nákupný košík')]//r-span[contains(@data-element,'cart')]    anchor=//a[contains(@title,'Prihlásenie')]
    Click Element    //a[contains(@title,'Prejsť do nákupného košíka')]    anchor=//a[contains(@title,'Zobraziť nákupný košík')]//r-span[contains(@data-element,'cart')]
Delete from basket and verify remove  #${position_item} start from 0.
    [Arguments]    ${position_item}
    ${delete_item}    Get From List    ${NAMES_ITEMS_BASKET}    ${position_item}
    ClickElement    //div[contains(@class,'cart__products__row ')][${position_item}+1]//i[contains(@class,'ico--x')]
    Sleep    0.5s
    ClickElement    //button[contains(@class,'confirm')]
    VerifyNoText    ${delete_item}
    Log    ${delete_item}

Type search Text
    [Arguments]    ${text_for_search}
    TypeText    //input[contains(@name, 'search')]    ${text_for_search}    anchor=//div[contains(@class,'den-xs hidden-sm')]
    ${xpath}    Set Variable    //a[@data-keyword='${text_for_search}']
    ClickElement    ${xpath}
    #ClickElement    //a[contains(@data-keyword,'${text_for_search}')]
    #ClickElement    //div[contains(@class,'btn-group bootstrap-select js-autocomplete-select hidden-cxs hidden-xs hidden-sm')]
    #ClickElement    //a[@title="Zobraziť všetky výsledky vyhľadávania"]
    #${xpath}    Set Variable    (//a[@href="/vyhladavanie?search="])[1]
    #ClickElement    ${xpath}    anchor=//a[@title="Registrácia"]
    #ClickElement    locator=(//a[@href="/vyhladavanie?search="])[1]
    #PressKey    //input[contains(@name, 'search')]    {ENTER}
    #ClickText    Zobraziť všetky výsledky
    #ClickElement    //i[contains(@class, 'ico ico--magnifying-glass')]    anchor=//div[contains(@class,'den-xs hidden-sm')]
     
Verify text in every item
    [Arguments]    ${verify_text}
    #${last_page}    Get Text    //div[contains(@class,'pager__count')]/span    between=???${SPACE}stránok    anchor=stránok
    ${xpath}    Set Variable    //li[@class= 'pager__item'][last()]
    ${last_page}    Get Text    ${xpath}    timeout=10s
    SetConfig    CaseInsensitive    True
    FOR    ${counter}    IN RANGE    ${last_page}-1
        
        ${elements_count}    Get Element Count    //div[contains(@class, 'products__item')]
        FOR    ${counter}    IN RANGE    ${elements_count}
            Verify Element Text    //div[contains(@class, 'products__item')][${counter}+1]//a[contains(@class, 'products__name')]    
            ...    ${verify_text}
        END

        Click Element    //a[contains(@rel,'next')]//i[contains(@class,'ico ico--chevron-right')]
    END

No checkout
    Click Text    Prejsť na fakturačné údaje
    Sleep    1s
    Verify No Text    Prejsť na výber dopravy a platby