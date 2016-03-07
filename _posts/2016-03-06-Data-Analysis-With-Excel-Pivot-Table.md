---
layout: post
title: Data Analysis With Excel Pivot Table
comments: true
---

In today's cloud computing industry, data is essential to understand your
business, your customer and your system. In my experience, it usually boils
down to analyzing a key performance indicator (KPI) in terms of a set of
aspects. For example, I might be interested in the number of activities
performed by a user, and I might want to know how that is correlated with the
user's gender, region s/he lives in, and the client used.

There are many ways I can use that data. I might be interested in comparing the
KPI by user gender first, then by the client types, or by the regions first,
then by the genders, etc. This could all be done writing scripts. But Excel
PivotTable can be handy in such scenarios.

Suppose [this is my data
source](https://github.com/kflu/kflu.github.io/files/160868/stats.txt). And
this can be the result if it's drilled down by Gender, Region, and finally
Client type:

![gener-region-client](https://cloud.githubusercontent.com/assets/1031978/13562142/cca0312a-e3e9-11e5-8929-6f99035c9ff4.png)

If you need a different order of drill down, or different aggregation function
(e.g., averaging instead of summing), you can do so by adjusting the pivot
table options:

![pivot table options](https://cloud.githubusercontent.com/assets/1031978/13562171/29356eb4-e3ea-11e5-9d59-2f519279bb73.png)

The following screencast illustrates the use of PivotTable to analyze it.

![using pivot table](https://cloud.githubusercontent.com/assets/1031978/13562034/6a3b0b1e-e3e8-11e5-8ff1-98a87e14db9b.gif)

It is also important to note that, the "source data" that I used here is
already a digest of raw data from the enormous amount of log files from our big
data system. The log files have many columns than just the few "aspects" that I
mentioned earlier. It is very important to understand and plan ahead the
several aspects you will be interested in analyzing, so you can use big data
systems like map-reduce to cook down them into the digest. In a summary, an
end-to-end workflow of analyzing big data is usually like this:

![data work flow](https://cloud.githubusercontent.com/assets/1031978/13562474/d50cb834-e3ed-11e5-8657-8ba115cf7290.png)
