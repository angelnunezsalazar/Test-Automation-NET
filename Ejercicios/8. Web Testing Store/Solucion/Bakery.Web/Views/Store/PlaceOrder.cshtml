@model Bakery.Web.Models.Order
<h1>
    Place Your Order: @ViewBag.Product.Name
</h1>
@using (Html.BeginForm())
{
    <fieldset class="no-legend">
        <legend>Place Your Order</legend>
        <img class="product-image order-image" src="@Url.Content("~/content/images/products/thumbnails/"+ViewBag.Product.ImageName)" alt="@ViewBag.Product.Name" />
        <ol>
            <li>
                @Html.LabelFor(x => x.Email, "Your Email Address")
                @Html.TextBoxFor(x => x.Email)
            </li>
            <li>
                @Html.LabelFor(x => x.Address, "Shipping Address")
                @Html.TextAreaFor(x => x.Address,new{rows="4",cols="20"})
            </li>
            <li class="quantity">
                @Html.LabelFor(x => x.Quantity)
                @Html.TextBoxFor(x => x.Quantity)
                x <span id="orderPrice">@ViewBag.Product.Price.ToString("c")</span>= <span id="orderTotal"></span></li>
        </ol>
        <input type="hidden" id="productId" name="productId" value="@ViewBag.Product.Id" />
        <input type="hidden" id="productPrice" name="productPrice" value="@ViewBag.Product.Price" />
        <p>
            <input type="submit" value="Place Order"/>
        </p>
    </fieldset> 
}
@section scripts
{
    <script type="text/javascript">
        $(function () {
            $("#Quantity").keyup(function () {
                var total = $(this).val() * $("#productPrice").val();
                $("#orderTotal").text("S/." + total.toFixed(2));
            }).keyup();
        });
    </script>
}


