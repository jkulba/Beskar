using System;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;

namespace Beskar
{
    public static class Ping
    {
        private static string _invocationId;

        [FunctionName("Ping")]
        public static async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req, ExecutionContext executionContext, ILogger log)
        {

            _invocationId = executionContext.InvocationId.ToString();

            PingResponse pingResponse = new()
            {
                RequestId = _invocationId,
                Application = "Beskar Functions",
                StatusCode = 0,
                Message = "Beskar Functions Ping Response",
                CreatedDate = DateTimeOffset.UtcNow
            };

            log.LogInformation("Ping request received: {pingResponse}", pingResponse);

            await Task.Yield();

            return (ActionResult)new OkObjectResult(pingResponse);
        }
    }

    public record PingResponse
    {
        public string RequestId { get; init; }
        public string Application { get; init; }
        public int StatusCode { get; init; }
        public string Message { get; init; }
        public DateTimeOffset CreatedDate { get; init; }
    }

}