using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

namespace Beskar
{
    public static class Ping
    {
        private static string _invocationId;

        [FunctionName("Ping")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ExecutionContext executionContext, ILogger log)
        {

            _invocationId = executionContext.InvocationId.ToString();

            log.LogInformation("PING function service endpoint received a request.");

            log.LogInformation(Environment.GetEnvironmentVariable("AzureWebJobsStorage", EnvironmentVariableTarget.Process));

            await Task.Yield();

            return (ActionResult)new OkObjectResult(new
            {
                returnMessage = "Ping Function Response",
                functionName = "PING",
                invocationId = _invocationId,
                returnStatusCode = 0,
                returnDate = DateTimeOffset.UtcNow
            });

        }
    }
}
