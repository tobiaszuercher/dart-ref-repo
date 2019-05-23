/* Options:
Date: 2019-05-23 11:16:54
Version: 5.50
Tip: To override a DTO option, remove "//" prefix before updating
BaseUrl: http://localhost:5000

//GlobalNamespace: 
//AddServiceStackTypes: True
//AddResponseStatus: False
//AddImplicitVersion: 
//AddDescriptionAsComments: True
//IncludeTypes: 
//ExcludeTypes: 
//DefaultImports: package:servicestack/servicestack.dart
*/

import 'package:servicestack/servicestack.dart';

abstract class PagedRequest
{
    int page;
    int pageSize;

    PagedRequest({this.page,this.pageSize});
    PagedRequest.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        page = json['page'];
        pageSize = json['pageSize'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'page': page,
        'pageSize': pageSize
    };

    TypeContext context = _ctx;
}

abstract class PagedAndOrderedRequest extends PagedRequest
{
    String orderBy;

    PagedAndOrderedRequest({this.orderBy});
    PagedAndOrderedRequest.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        super.fromMap(json);
        orderBy = json['orderBy'];
        return this;
    }

    Map<String, dynamic> toJson() => super.toJson()..addAll({
        'orderBy': orderBy
    });

    TypeContext context = _ctx;
}

class FooListDto implements IConvertible
{
    String id;

    FooListDto({this.id});
    FooListDto.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        id = json['id'];
        return this;
    }

    Map<String, dynamic> toJson() => {
        'id': id
    };

    TypeContext context = _ctx;
}

class PagedResult<T> implements IConvertible
{
    int page;
    int pageSize;
    int totalResults;
    List<T> results;

    PagedResult({this.page,this.pageSize,this.totalResults,this.results});
    PagedResult.fromJson(Map<String, dynamic> json) { fromMap(json); }

    fromMap(Map<String, dynamic> json) {
        page = json['page'];
        pageSize = json['pageSize'];
        totalResults = json['totalResults'];
        results = JsonConverters.fromJson(json['results'],'List<${runtimeGenericTypeDefs(this,[0]).join(",")}>',context);
        return this;
    }

    Map<String, dynamic> toJson() => {
        'page': page,
        'pageSize': pageSize,
        'totalResults': totalResults,
        'results': JsonConverters.toJson(results,'List<T>',context)
    };

    TypeContext context = _ctx;
}

// @Route("/foos", "GET")
class GetFoos extends PagedAndOrderedRequest implements IReturn<PagedResult<FooListDto>>, IConvertible
{
    GetFoos();
    GetFoos.fromJson(Map<String, dynamic> json) : super.fromJson(json);
    fromMap(Map<String, dynamic> json) {
        super.fromMap(json);
        return this;
    }

    Map<String, dynamic> toJson() => super.toJson();
    createResponse() { return new PagedResult<FooListDto>(); }
    String getTypeName() { return "GetFoos"; }
    TypeContext context = _ctx;
}

TypeContext _ctx = new TypeContext(library: 'localhost', types: <String, TypeInfo> {
    'PagedRequest': new TypeInfo(TypeOf.AbstractClass),
    'PagedAndOrderedRequest': new TypeInfo(TypeOf.AbstractClass),
    'FooListDto': new TypeInfo(TypeOf.Class, create:() => new FooListDto()),
    'PagedResult<T>': new TypeInfo(TypeOf.GenericDef,create:() => new PagedResult()),
    'GetFoos': new TypeInfo(TypeOf.Class, create:() => new GetFoos()),
});


