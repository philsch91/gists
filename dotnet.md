# dotnet .NET

```
dotnet --info
dotnet --list-sdks
dotnet --list-runtimes
dotnet new console|mvc -o <output-directory> -lang C# [-v q(uiet)|m(inimal)|n(ormal)|diag(nostic)]
dotnet new gitignore
dotnet dev-certs https
dotnet dev-certs https --trust
dotnet add [<project-name (CompanyName.ProductName.ProjectName.csproj)>] package <package-name> [-v <version-number>] [options]
dotnet remove [<project-name (CompanyName.ProductName.ProjectName.csproj)>] package <package-name>
dotnet restore
dotnet nuget locals all [(-l|--list)|(-c|--clear)]
dotnet build [-c|--configuration <CONFIGURATION|Debug>]
dotnet run [-c|--configuration <CONFIGURATION>] [arg1...argn]
```
