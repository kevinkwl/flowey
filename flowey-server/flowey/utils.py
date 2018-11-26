
class Category:
    c2i = {
        "Food & Dining": 0,
        "Travel": 1,
        "Lending": 2,
        "Borrowing": 3,
        "MISC": 4,
        "Returning": 5,
    }

    i2c = [
        "Food & Dining",
        "Travel",
        "Lending",
        "Borrowing",
        "MISC",
        "Returning"]

    DEFAULT_CATEGORY_INT = 4
    FLOW_CATEGORY_INT = [2, 3, 5]

    LEND = 2
    BORROW = 3
    RETURN = 5

    @staticmethod
    def name(ci):
        if ci > len(Category.i2c):
            ci = Category.DEFAULT_CATEGORY_INT
        return Category.i2c[ci]

    @staticmethod
    def is_borrow(c):
        if isinstance(c, int):
            return c == 3
        elif isinstance(c, str):
            return c == "Borrowing"

    @staticmethod
    def is_return(c):
        if isinstance(c, int):
            return c == 5
        elif isinstance(c, str):
            return c == "Returning"

    @staticmethod
    def is_lend(c):
        if isinstance(c, int):
            return c == 2
        elif isinstance(c, str):
            return c == "Returning"

    @staticmethod
    def is_flow(c):
        return Category.is_borrow(c) or Category.is_lend(c) or \
                Category.is_return(c)




