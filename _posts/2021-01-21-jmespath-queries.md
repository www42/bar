---
layout:     post
title:      "JMESPath Queries"
date:       2021-01-21 17:30:00 +0100
categories: Azure CLI JMESPath
image1:     assets/images/2021-01-21-jmespath-queries/jpterm.png
---

[ms-docs]:        https://docs.microsoft.com/en-us/cli/azure/query-azure-cli
[azure-citadel]:  https://azurecitadel.com/prereqs/cli/cli-3-jmespath/
[jmespath]:       https://jmespath.org/
[jpterm]:         https://github.com/jmespath/jmespath.terminal


JMESPath queries are very useful to filter Azure CLI output.

This post is an excerpt of:
* Query command results with Azure CLI - [Microsoft Docs][ms-docs]
* CLI 2.0 JMESPATH - [Azure Citadel][azure-citadel]

### Arrays and Objects

In the JSON world there are two kinds of things - arrays and objects. For a complete language specification see [JMESPath.org][jmespath].

An object is a collection of `key:value` pairs surrounded by curly brackets, eg

```json
{
    "id": "/subscriptions/xxxxxxxx-82ee-49bf-a689-825a603e5c08/resourceGroups/Cloudshell-RG",
    "location": "westeurope",
    "managedBy": null,
    "name": "Cloudshell-RG",
    "properties": {
      "provisioningState": "Succeeded"
    },
    "tags": {},
    "type": "Microsoft.Resources/resourceGroups"
}
```

In contrast an array is a list of elements - values and/or object - surrounded by square brackets, eg
```json
[
    1,
    2,
    "foo",
    {
      "bar":[
        3,
        4
      ]
    },
    5
]
```

Assuming JSON as the default output format it is a common need to filter the outcome of Azure CLI commands. Luckily there is the global --query parameter do perform JMESPath queries.



### Selecting Array Elements

```bash
az group list                           # array starting point
az group list --query "[*]"             # all elements (pass through the whole array)
az group list --query "[0]"             # first element
az group list --query "[1]"             # second element
az group list --query "[-1]"            # last element
az group list --query "[0:2]"           # [a:b]  slicing from a to b-1  (sic!)
```

Fun fact: Slicing always generates an array

```bash
az group list --query "[0]"             # single object
az group list --query "[:1]"            # array (with a single object)
```


### Selecting an Individual Value of an Object

```bash
az group list --query "[0]"             # single object starting point
az group list --query "[0].location"    # value is a string surrounded by double quotes
az group list --query "[0].managedBy"   # value is 'null'
az group list --query "[0].properties"  # value is an object
az group list --query "[0].properties.provisioningState"  # value for provisioningState within the properties object
```


### Selecting Multiple Values

```bash
az group list --query "[0].[name,location]"
az group list --query "[0].[name,location,properties]"
az group list --query "[*].[name,location,properties]"
```

Magic trick - Instead of array `[*].[]` use an object `[*].{}`

```bash
az group list --query "[*].{name,location}"                 # doesn't work - keys are missing
az group list --query "[*].{foo:name,bar:location}"         # keys added
az group list --query "[*].{name:name,location:location}"   # better keys
```

Tipp: Use variable to store complex queries

```bash
query="[*].{name:name,location:location}"
az group list --query $query
```

### Filter Objects

Projection Operator  `?key=='value'`

```bash
az group list --query "[?name=='Cloudshell-RG']"
az group list --query "[?name=='Cloudshell-RG' && location=='westeurope']"  #  &&    logical AND
                                                                            #  ||    logical OR
```                                                                            

What other comapators do exist?

```bash
#   ==  equal
#   !=  not equal
#   >   greater then (numeric values only)
#   etc
```



### Functions

```bash
# length()
az group list --query "length([*])"                         # number of elements

# starts_with()
az group list --query "[?starts_with(name, 'Cloud')].name"
az group list --query "[?ends_with(name, '-RG')].name"
az group list --query "[?contains(name, 'e')].name"

# sort()    --> Sorting array  
az group list --query "sort([*].name)"
az group list --query "reverse(sort([*].name))"


# sort_by() --> Sorting array of objects       
az group list --query "sort_by([*], &name)"
az group list --query "reverse(sort_by([*], &name))"


# Pipe Expressions
az group list --query "[?name=='Cloudshell-RG'].name"           # array of a single string
az group list --query "[?name=='Cloudshell-RG'].name | [0]"     # string
```

### Flatten an Array 

Flatten Operator `[]`

Example 1 (`jpterm flat1.json`)
```json
[
    1,2,[3,[4,5],6],7,[8,9]
]
```

```bash
#   [*]       [1,2,[3,[4,5],6],7,[8,9]]
#   []        [1,2,3,[4,5],6,7,8,9]
#   [][]      [1,2,3,4,5,6,7,8,9]
```


Example 2 (`jpterm flat2.json`)
```json
{
    "foo": [
      { "numbers": [1,2,3] },
      { "numbers": [4,5,6] }
    ]
}
```


```bash
#   foo[*]                          [{n:[1,2,3]},{n:[4,5,6]}]
#   foo[*].numbers                  [[1,2,3],[4,5,6]]
#   foo[*].numbers.[]               [1,2,3,4,5,6]
```

### Tool `jpterm`

Great tool for exploring JMESPath queries.

<img src="{{ page.image1 | relative_url }}" alt="jpterm" width="800"/>

Tipp: `^-5` erase JMESPath expression