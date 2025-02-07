﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;

namespace WeightAddWebAPI.Validators
{
    /// <summary>
    /// This is a custom validation attribute that will raise validation errors if an invalid unit value is received by the API.
    /// </summary>
    public class ValidUnitAttribute : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            
            string val=value.ToString().ToLower();
            if (!(val=="g" || val=="mg" || val=="kg"))
            {
                return new ValidationResult("Invalid unit: " + val);
            }
            return null;
        }
    }
}
