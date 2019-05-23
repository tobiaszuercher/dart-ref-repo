# dart-ref-repo
Servicestack Service implementation to reproduce issue with `dart-ref`.

generated service reference: [foos.dtos.dart](foos.dtos.dart)


Using `JsonServiceClient` to get data from backend:

```dart
  var client = new JsonServiceClient("http://localhost:5000");
  var response = await client.get(new GetFoos());
```

Results in this exception (screenshot taken from flutter app on ios simulator):
![exception](exception.png)

The call to createInstance() is in [json_converters.dart](https://github.com/ServiceStack/servicestack-dart/blob/master/lib/json_converters.dart#L257) where typeInfo is null.

We wrap retrieving lists in a PagedResult which leads to this problem. Using `ts-ref`/typescripts JsonServiceClient works perfectly fine in our other aurelia SPAs with these dtos and the same backend.

Backend:
```csharp
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
    
