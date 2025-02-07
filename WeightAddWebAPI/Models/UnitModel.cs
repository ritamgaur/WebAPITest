﻿using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;
using WeightAddWebAPI.Validators;

namespace WeightAddWebAPI.Models
{
    public class RootObject
    {

        public RootObject() { }
        [DataMember(IsRequired = true)]
        public List<Item> items { get; set; }
    }

    public class Item
    {
        public Item() { }
        [NonNegativeNumber]
        [DataMember(IsRequired = true)]
        public int value { get; set; }

        [ValidUnit]
        [DataMember(IsRequired = true)]
        public string unit { get; set; }
    }
}