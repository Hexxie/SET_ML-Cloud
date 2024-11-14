## Assignment #1
Write a function is_palindrome that returns True if a passed object is a palindrome and False otherwise.

We want this function to work with str and int

## Assignment #2
Write a function simple_calculator(operation, a, b) that performs basic arithmetic operations (add, subtract, multiply, divide) based on the operation provided.

- raise TypeError in case a or b is not a number
- handle 0 in case of division

## Assignment #3
Write a decorator retry that retries a function up to three times if it raises an exception.

```
@retry
def example(threshold):
    from random import random
    if random() <= threshold:
        raise Exception()

example(0.9) # fail in 9 out of 10 cases
example(0.5) # fail in 5 out of 10 cases
```

Don't forget about *args, **kwargs