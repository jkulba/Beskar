using System;

using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

using Serilog;

[assembly: FunctionsStartup(typeof(Beskar.Startup))]

namespace Beskar
{
    public class Startup : FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            var logger = new LoggerConfiguration()
              .Enrich.FromLogContext()
              .Enrich.WithThreadId()
              .WriteTo.Console(outputTemplate: "[{Timestamp:HH:mm:ss} {Level:u3}] {Message:lj}{NewLine}{Exception}")
            //   .WriteTo.File("log.txt", rollingInterval: RollingInterval.Day, outputTemplate: "[{Timestamp:HH:mm:ss} {Level:u3}] {Message:lj}{NewLine}{Exception}")
              .CreateLogger();

            builder.Services.AddLogging(LoaderOptimizationAttribute => LoaderOptimizationAttribute.AddSerilog(logger));

        }
    }
}


//    "Enrich": [ "FromLogContext", "WithMachineName", "WithThreadId", "WithExceptionDetails" ],
