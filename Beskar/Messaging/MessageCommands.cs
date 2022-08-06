using System.Threading.Tasks;
using Azure.Storage.Queues;
using Microsoft.Extensions.Logging;

namespace Beskar.Messaging
{
    public class MessageCommands : IMessageCommands
    {
        private readonly ILogger<MessageCommands> _logger;

        public MessageCommands(ILogger<MessageCommands> logger)
        {
            _logger = logger;
        }

        public async Task InsertMessageAsync(QueueClient queueClient, string message)
        {
            if (null != await queueClient.CreateIfNotExistsAsync())
            {
                _logger.LogInformation("TheQueue was created.");
            }
            await queueClient.SendMessageAsync(message);
        }

        public Task<string> RetrieveNextMessageAsync(QueueClient queueClient)
        {
            throw new System.NotImplementedException();
        }
    }
}