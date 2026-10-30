from django.test import TestCase

from django.test import SimpleTestCase

from .models import Item, OrderItem


class TestOrderItemPrices(SimpleTestCase):

    def test_price_without_discount(self):
        item = Item(price=100)
        order_item = OrderItem(item=item, quantity=3)

        self.assertEqual(order_item.get_final_price(), 300)

    def test_price_with_discount(self):
        item = Item(price=100, discount_price=80)
        order_item = OrderItem(item=item, quantity=3)

        self.assertEqual(order_item.get_final_price(), 240)