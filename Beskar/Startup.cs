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
              .WriteTo.Console()
              .WriteTo.File("log.txt", rollingInterval:RollingInterval.Day)
              .CreateLogger();

              builder.Services.AddLogging(LoaderOptimizationAttribute => LoaderOptimizationAttribute.AddSerilog(logger));
        }
    }
}