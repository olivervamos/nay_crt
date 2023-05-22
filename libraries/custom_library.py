from QWeb.keywords.element import get_element_count
from QWeb.keywords.text import get_text
import logging


def price_sorting_control():
    """ Create List of prices """
    elements_count = get_element_count("//div[contains(@class,'products__item')]")
    prices = []
    for i in range(elements_count):
        element_order = i+1
        locator = f"//div[contains(@class,'products__item')][{element_order}]//span[contains(@class,'number left')]"
        price = get_text(locator, between="???€").replace(' ','')
        price_num = int(price.split(',')[0])
        logging.info(price_num)
        prices.append(price_num)

    if prices != sorted(prices, reverse=True):
        raise AssertionError('sorting of items is not corect form high to low')