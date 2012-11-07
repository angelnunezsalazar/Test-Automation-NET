﻿namespace Bakery.Web.Models
{
    public class Product
    {
        public int Id { get; set; }
        
        public string Name { get; set; }

        public string Description { get; set; }

        public decimal Price { get; set; }

        public string ImageName { get; set; }
    }
}