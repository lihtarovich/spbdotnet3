using System;
using System.IO;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;

namespace DataAccessLayer
{
    /// <summary>
    /// This class is obligatory for "dotnet ef database upgrade" and "add migration" commands 
    /// </summary>
    public class ApplicationContextFactory : IDesignTimeDbContextFactory<UserContext>
    {
        public UserContext CreateDbContext(String[] args)
        {
            IConfiguration config = new ConfigurationBuilder()
                .SetBasePath(Path.Combine(Directory.GetCurrentDirectory(), "../Output/x64/Debug/netcoreapp3.1"))
                .AddJsonFile("appsettings.json", false, true)
                .Build();
            
            var optionsBuilder = new DbContextOptionsBuilder<UserContext>();
            optionsBuilder.UseNpgsql(config.GetConnectionString("DefaultConnection"), 
                builder => { builder.MigrationsAssembly("DataAccessLayer"); });
            return new UserContext(optionsBuilder.Options);
        }
    }
}