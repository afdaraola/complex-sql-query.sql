EQL enforces the following precedence rules for operators.

The rules are listed in descending order:
Parentheses (as well as brackets in lookup expressions and IN expressions). Note that you can freely add parentheses any time you want to impose an alternative precedence or to make precedence clearer.
* /
+ -
= <> < > <= >=
IS (IS NULL, IS NOT NULL, IS EMPTY, IS NOT EMPTY)
BETWEEN
NOT
AND
OR
All binary operators are left-associative, as are all of the JOIN operators.
