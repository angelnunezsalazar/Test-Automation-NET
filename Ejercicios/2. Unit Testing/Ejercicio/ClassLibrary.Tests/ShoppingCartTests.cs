namespace ClassLibrary.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    /*
    Things we know about the shopping cart
    *
    * WHEN i add an item THEN the total items are incremented
    * WHEN i find a product AND the product exists THEN the product is returned
    * WHEN i find a product AND the product does not exist THEN null is returned
    * WHEN i remove an item AND the item exists THEN the item is removed
    * WHEN i clear the cart THEN all the items are removed.
    * WHEN i calculate the sub total THEN the item total(product price * quantity) of all items is returned
    * WHEN i calculate the total THEN the subtotal + tax is returned
    */

    /*
    Things we need to implement
    *
    * WHEN i add an item AND the quantity is 0 or negative THEN nothing should be added
    * WHEN i remove an item AND the item does not exit THEN should throw an exception
    * WHEN i add an item AND the item already exists THEN no new line should be added 
    *                                                AND the line quantity should be equal to the last item quantity
    */

    [TestClass]
    public class ShoppingCartTests
    {

    }
}