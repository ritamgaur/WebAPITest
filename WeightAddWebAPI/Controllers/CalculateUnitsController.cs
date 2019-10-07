using System.Web.Mvc;
using WebApplication1.Models;
using System.Net;
using System.Net.Http;
using Newtonsoft.Json.Linq;

namespace WebApplication1.Controllers
{
    public class CalculateUnitsController : Controller
    {
        #region Stored procedure
        const string RETURNKEY_STATUS = "status";
        const string RETURNKEY_MESSAGE = "message";
        const string RETURNKEY_RESULT = "result";
        #endregion

        //public HttpResponseMessage Post(UnitModel mo)
        //{
        //    // Send an error response if the ModelState is invalid
        //    if (!ModelState.IsValid)
        //    {
        //        return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ModelState);
        //    }
        //    return Request.CreateResponse(HttpStatusCode.Created);
        //}
        [HttpPost]
        public string Calculate(UnitModel mo)
        {
            string response = "";
            if (!ModelState.IsValid)
            {
                var items = mo.items;

                JObject json = JObject.Parse(items);

                //return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ModelState);
            }
            //return Request.CreateResponse(HttpStatusCode.Created);
            return response;
        }
    }
}