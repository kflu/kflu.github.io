---
title: Two's complement notes
layout: post
comments: true
---

In the following discussion, I assume the cardinality of the number set is 2^32,
or, 32 bit integer. But it can be generalized to any size.

A visualization of the integers on the number domain. 

![visualization](data/twos-complement-visualization.png)


There's always one more negative numbers than the positive numbers. That's
because, total available numbers is even (2^32). 0 take a spot, leaving all
positive and negative numbers to split the rest 2^32 - 1 spots, which is an odd
number.

This further leads to the fact that

    abs(int.MinValue) = abs(int.MaxValue) + 1


So on any integer domain, negation should not cause overflow except for
`int.MinValue`. Interestingly, 

    -int.MinValue == int.MinValue


For two's complement representation, $e=mc^2$
