using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using Funq;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using ServiceStack;

namespace DartRefSandbox
{
    class Program
    {
        static void Main(string[] args)
        {
            var host = new WebHostBuilder()
                .UseKestrel()
                .UseContentRoot(Directory.GetCurrentDirectory())
                .UseStartup<Startup>()
                .UseUrls("http://localhost:5000/")
                .Build();

            host.Run();
        }
    }

    public class Startup
    {
        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            app.UseServiceStack(new AppHost());

            app.Run(context =>
            {
                context.Response.Redirect("/metadata");
                return Task.FromResult(0);
            });
        }
    }

    public class AppHost : AppHostBase
    {
        public AppHost()
            : base("MyApp", typeof(Program).Assembly) { }

        public override void Configure(Container container)
        {
        }
    }

    public class FooService : Service
    {
        public PagedResult<FooListDto> Get(GetFoos request)
        {
            var list = new List<FooListDto>
            {
                new FooListDto {Id = "claims/1-A"},
            };

            return new PagedResult<FooListDto>(list, 1, 1, 1);
        }
    }
    
    [Route("/foos", "GET")]
    public class GetFoos : PagedAndOrderedRequest, IReturn<PagedResult<FooListDto>>
    {
    }

    public abstract class PagedAndOrderedRequest : PagedRequest
    {
        public string OrderBy { get; set; }
    }

    public abstract class PagedRequest
    {
        public int Page { get; set; }
        public int PageSize { get; set; }

        protected PagedRequest()
        {
            Page = 1;
            PageSize = 15;
        }
    }

    public class PagedResult<T>
    {
        public int Page { get; set; }
        public int PageSize { get; set; }
        public long TotalResults { get; set; }

        public List<T> Results { get; private set; }

        public PagedResult()
        {
            Results = new List<T>();
        }

        public PagedResult(List<T> results, int page, int pageSize, long totalResults)
        {
            if (results == null)
            {
                Results = new List<T>();
            }
            else
            {
                Results = results;
            }

            Page = page;
            PageSize = pageSize;
            TotalResults = totalResults;
        }

        public PagedResult(List<T> results, PagedRequest request, long totalResults)
            : this(results, request.Page, request.PageSize, totalResults)
        {
        }
    }
    
    public class FooListDto
    {
        public string Id { get; set; }
    }
}