
class Category:
    c2i = {
        "Food & Dining": 0,
        "Travel": 1,
        "Lend": 2,
        "Borrow": 3,
        "MISC": 4,
        "Return": 5,
        "Receive": 6,
    }

    i2c = [
        "Food & Dining",
        "Travel",
        "Lend",
        "Borrow",
        "MISC",
        "Return",
        "Receive"]

    DEFAULT_CATEGORY_INT = 4
    FLOW_CATEGORY_INT = [2, 3, 5, 6]

    LEND = 2
    BORROW = 3
    RETURN = 5
    RECEIVE = 6

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
            return c == "Borrow"

    @staticmethod
    def is_return(c):
        if isinstance(c, int):
            return c == 5
        elif isinstance(c, str):
            return c == "Return"

    @staticmethod
    def is_lend(c):
        if isinstance(c, int):
            return c == 2
        elif isinstance(c, str):
            return c == "Lend"

    @staticmethod
    def is_receive(c):
        if isinstance(c, int):
            return c == 6
        elif isinstance(c, str):
            return c == "Receive"

    @staticmethod
    def is_flow(c):
        return Category.is_borrow(c) or Category.is_lend(c) or \
                Category.is_return(c) or Category.is_receive(c)




