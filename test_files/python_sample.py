# Sample Python File for Syntax Testing

# Variables
integer_var = 42
float_var = 3.14
string_var = "Hello, world!"
boolean_var = True

# Lists
sample_list = [1, 2, 3, 4, 5]

# Dictionaries
sample_dict = {"name": "John", "age": 30, "city": "New York"}

# Tuples
sample_tuple = (10, 20, 30)

# Sets
sample_set = {1, 2, 3, 4, 5}

# Conditional Statements
if integer_var > 10:
    print("Integer is greater than 10")
elif integer_var == 10:
    print("Integer is 10")
else:
    print("Integer is less than 10")

# Loops
# For loop
for num in sample_list:
    print(num)

# While loop
count = 0
while count < 5:
    print(count)
    count += 1

# Functions
def greet(name):
    return f"Hello, {name}!"

print(greet("Alice"))

# Lambda Functions
add = lambda x, y: x + y
print(add(2, 3))

# List Comprehensions
squares = [x**2 for x in range(10)]
print(squares)

# Exception Handling
try:
    result = 10 / 0
except ZeroDivisionError as e:
    print("Error:", e)
finally:
    print("This is executed no matter what")

# Classes and Objects
class Animal:
    def __init__(self, name):
        self.name = name

    def speak(self):
        raise NotImplementedError("Subclass must implement abstract method")

class Dog(Animal):
    def speak(self):
        return "Woof!"

class Cat(Animal):
    def speak(self):
        return "Meow!"

print(f" 2 to the 3rd {math.pow(2, 3)}")

dog = Dog("Buddy")
cat = Cat("Kitty")
print(dog.speak())
print(cat.speak())

# File I/O
with open("sample.txt", "w") as file:
    file.write("Hello, file!")

with open("sample.txt", "r") as file:
    content = file.read()
    print(content)

# Generators
def countdown(n):
    while n > 0:
        yield n
        n -= 1

for number in countdown(5):
    print(number)

# Decorators
def my_decorator(func):
    def wrapper():
        print("Something is happening before the function is called.")
        func()
        print("Something is happening after the function is called.")
    return wrapper

@my_decorator
def say_hello():
    print("Hello!")

say_hello()

# Context Managers
class MyContextManager:
    def __enter__(self):
        print("Entering the context")
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        print("Exiting the context")

with MyContextManager():
    print("Inside the context")
