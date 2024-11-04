## Assignment #1
Using this list

```
companies = [

     {'name': 'Apple', 'hq': 'Cupertino, California'},

     {'name': 'Google', 'hq': 'Mountain View, California'},

     {'name': 'Netflix', 'hq': 'Los Gatos, California'}

]
```

Please write code to create a new list of company names by each of these methods:

- Using for loops
- Using list comprehensions

## Assignment #2
Given the list below, write code to remove duplicates.

```
companies = ['netflix', 'apple', 'apple', 'google']
```

- Order should be the same
- list(set(companies)) is not allowed 😀
- Make time complexity better than O(n^2)

## Assignment #3
Given two lists

```
keys = ['name', 'hq', 'no_employees', 'established']

values = ['Apple', 'Cupertino, California', 161000, 1976]
```

Write code that creates dict with keys from the first list and values from the second

```
result = {'name': 'Apple',  ...}
```

It's not required, but you can try to use zip function