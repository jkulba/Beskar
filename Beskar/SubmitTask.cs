using System;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Threading.Tasks;

using Azure;
using Azure.Storage.Queues;
using Azure.Storage.Queues.Models;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;

using Newtonsoft.Json;

namespace Beskar
{
    public static class SubmitTask
    {
        private static string _invocationId;
        private static ILogger _logger;

        [FunctionName("SubmitTask")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req, ExecutionContext executionContext, ILogger logger)
        {
            _invocationId = executionContext.InvocationId.ToString();
            _logger = logger;

            var indentedJsonSerializerSettings = new JsonSerializerSettings()
            {
                Formatting = Formatting.Indented
            };

            var executionContextJson = JsonConvert.SerializeObject(
                executionContext, indentedJsonSerializerSettings);

            _logger.LogInformation(executionContextJson);

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();

            dynamic data = JsonConvert.DeserializeObject(requestBody);

            TaskRequest taskRequest = new()
            {
                Id = _invocationId,
                CommandType = data?.CommandType,
                Content = data?.Content,
                CreatedDate = DateTimeOffset.UtcNow
            };

            // string connectionString = Environment.GetEnvironmentVariable("StorageConnectionString");
            string connectionString = "UseDevelopmentStorage=true";
            string queueName = "request-input-queue";
            // string queueName = Environment.GetEnvironmentVariable("RequestInputQueue");
            QueueClientOptions queueClientOptions = new QueueClientOptions()
            {
                MessageEncoding = QueueMessageEncoding.Base64
            };

            try
            {
                QueueClient queueClient = new QueueClient(connectionString, queueName, queueClientOptions);
                await InsertMessageAsync(queueClient, taskRequest);
            }
            catch (RequestFailedException ex)
                when (ex.ErrorCode == QueueErrorCode.QueueAlreadyExists)
            {
                // Ignore any errors if the queue already exists
            }

            return (ActionResult)new OkObjectResult(new
            {
                returnMessage = "Success",
                returnStatusCode = 0,
                invocationId = taskRequest.Id
            });

        }

        static async Task InsertMessageAsync(QueueClient theQueue, TaskRequest taskRequest)
        {
            if (null != await theQueue.CreateIfNotExistsAsync())
            {
                _logger.LogInformation("The queue was created.");
            }

            string jsonString = JsonConvert.SerializeObject(taskRequest);

            await theQueue.SendMessageAsync(jsonString);
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
