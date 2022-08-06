using System.Threading.Tasks;
using Azure.Storage.Queues;

namespace Beskar.Messaging
{
    public interface IMessageCommands
    {
        Task InsertMessageAsync(QueueClient queueClient, string message);
        Task<string> RetrieveNextMessageAsync(QueueClient queueClient);
    }
}