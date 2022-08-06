using System;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace Beskar
{
    public static class SubmitTask
    {
        private static string _invocationId;

        [FunctionName("SubmitTask")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req, ExecutionContext executionContext, ILogger log)
        {
            _invocationId = executionContext.InvocationId.ToString();

            var indentedJsonSerializerSettings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented
            };

            var executionContextJson = JsonConvert.SerializeObject(
                executionContext, indentedJsonSerializerSettings);

            log.LogInformation(executionContextJson);

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();

            dynamic data = JsonConvert.DeserializeObject(requestBody);

            TaskRequest taskRequest = new()
            {
                Id = _invocationId,
                CommandType = data?.CommandType,
                Content = data?.Content,
                CreatedDate = DateTimeOffset.UtcNow
            };

            return (ActionResult)new OkObjectResult(new
            {
                returnMessage = "Success",
                returnStatusCode = 0,
                invocationId = taskRequest.Id
            });

        }
    }

    public record TaskRequest
    {
        public string Id { get; init; }
        [Required]
        public string CommandType { get; init; }
        [Required]
        public string Content { get; init; }
        public DateTimeOffset CreatedDate { get; init; }
    }

}