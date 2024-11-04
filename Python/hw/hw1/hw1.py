
def assignment_1_1():
    """
        Creates a new list of company names using for loops

        Returns:
            list[str]: A list of company names
    """
    companies = [
    {'name': 'Apple', 'hq': 'Cupertino, California'},
    {'name': 'Google', 'hq': 'Mountain View, California'},
    {'name': 'Netflix', 'hq': 'Los Gatos, California'}
    ]

    company_names = []
    for company in companies:
        company_names.append(company["name"])
    
    return company_names

def assignment_1_2():
    """
        Creates a new list of company names using list comprehension

        Returns:
            list[str]: A list of company names
    """
    companies = [
    {'name': 'Apple', 'hq': 'Cupertino, California'},
    {'name': 'Google', 'hq': 'Mountain View, California'},
    {'name': 'Netflix', 'hq': 'Los Gatos, California'}
    ]

    return [company["name"] for company in companies]

def assignment_2():
    """
        Removes duplicates

        Returns:
            list[str]: A list without duplicates
    """
    companies = ['netflix', 'apple', 'apple', 'google']
    return list(dict.fromkeys(companies))

def assignment_3():
    """
        Creates dict with keys from the first list and values from the second

        Returns:
            Dict with keys and values
    """
    keys = ['name', 'hq', 'no_employees', 'established']
    values = ['Apple', 'Cupertino, California', 161000, 1976]

    dict = {keys[i]: values[i] for i in range(len(keys))}

    return dict


if __name__ == '__main__':
    print(f'{assignment_1_1()}\n')
    print(f'{assignment_1_2()}\n')
    print(f'{assignment_2()}\n')
    print(f'{assignment_3()}\n')