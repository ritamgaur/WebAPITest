using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;

namespace WeightAddWebAPI.Validators
{
    /// <summary>
    /// This is a custom validation attribute that will raise validation errors if a received number value is negative.
    /// </summary>
    public class NonNegativeNumberAttribute : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            if (!(value is int))
            {
                return new ValidationResult("NonNegativeAttribute can only be applied to ints.");
            }
            if ((int)value < 0)
            {
                return new ValidationResult("value should be non-negative. value: " + value.ToString());
            }
            return null;
        }
    }
}
