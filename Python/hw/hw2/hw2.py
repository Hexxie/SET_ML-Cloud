from functools import wraps

def is_palidrome(obj):
    """
        Assignment 1
        Checks if the given object is a palindrome.

        Parameters:
        obj (str or int): The object to check, which should be of type string or integer.

        Returns:
            bool: True if the object is a palindrome, False otherwise.

        Raises:
            TypeError: If the object is not of type string or integer.
    """
    if (type(obj) is str or type(obj) is int):
        obj_str = str(obj)
        return obj_str == obj_str[::-1]
    else:
        raise TypeError("The object should be int or string")

def simple_calculator(operation, a, b):
    """
        Assignment 2

        Performs basic arithmetic operations (add, subtract, multiply, divide)
        based on the operation provided

        Returns:
            Calculations

        Raises:
            TypeError: in case a or b is not a number
    """
    if not isinstance(a, (int, float)) or not isinstance(b, (int, float)):
        raise TypeError("Both a and b must be numbers (int or float)")
    
    match operation:
        case "+":
            return a+b
        case "-":
            return a-b
        case "*":
            return a*b
        case "/":
            try:
                result = a / b
            except ZeroDivisionError:
                print("Cannot divide by zero")
                return 0
            else:
                return result
        case _:
            print("Invalid operation")


def retry(func):
    """
    Decorator retry that retries a function up to three times if it raises an exception.
    """
    @wraps(func)
    def wrapper(*args, **kwargs):
        counter = 1
        while counter < 4:
            try:
                #print(f"args: {args}, kwargs: {kwargs}")
                func(*args, **kwargs)
                print("Executed successfully")
                break
            except Exception:
                print(f"retry nr {counter}")
                counter = counter + 1
    return wrapper

@retry
def example(threshold):
    from random import random
    if random() <= threshold:
        raise Exception()

if __name__ == "__main__":
    #Assignment 1
    print(is_palidrome("radar")) #True
    print(is_palidrome("hello")) #False
    print(is_palidrome(12321)) #True
    print(is_palidrome(12345)) #False
    print()

    #Assignment 2
    print(simple_calculator("+", 5, 3))
    print(simple_calculator("-", 10, 7))
    print(simple_calculator("*", 6, 4))
    print(simple_calculator("/", 9, 3))
    print(simple_calculator("/", 10, 0))
    try:
        simple_calculator("+", "a", "b")
    except TypeError:
        print("TypeError raised")
    print()
    #Assignment 3
    example(0.9) # fail in 9 out of 10 cases
    print()
    example(0.5) # fail in 5 out of 10 cases