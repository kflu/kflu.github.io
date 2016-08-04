
## References:
* [Series](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.Series.html)
* [DataFrame](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.html)
* [Groupby](http://pandas.pydata.org/pandas-docs/stable/groupby.html)
    * [Aggregation](http://pandas.pydata.org/pandas-docs/stable/groupby.html#aggregation)
* [Table style](http://pandas.pydata.org/pandas-docs/stable/style.html)
* [Visualization (charts)](http://pandas.pydata.org/pandas-docs/stable/visualization.html)

### Tips
* Use `<tab>` for completion
* select then press `(` wraps

## Setup


```python
%matplotlib inline
import pandas as pd
import numpy as np
from IPython.display import display, HTML
pd.options.display.max_columns = 999
pd.options.display.max_rows = 999
```

## Reading CSV


```python
data = pd.read_csv(
    'data.tsv', 
    parse_dates=['Timestamp'],
    dtype={'Kind': str},
    dialect='excel-tab')
data[:3]
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>sequence_number</th>
      <th>Timestamp</th>
      <th>Kind</th>
      <th>NormalCount</th>
      <th>TotalCount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>484828304</td>
      <td>2016-06-18 00:49:34</td>
      <td>10.27</td>
      <td>3</td>
      <td>10</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1006221952</td>
      <td>2016-04-13 17:31:09</td>
      <td>10.31</td>
      <td>6</td>
      <td>14</td>
    </tr>
    <tr>
      <th>2</th>
      <td>227783421</td>
      <td>2016-03-20 11:10:28</td>
      <td>10.27</td>
      <td>5</td>
      <td>13</td>
    </tr>
  </tbody>
</table>
</div>



## Column selection, transormation


```python
# a columln is a Series:
counts = data['TotalCount']

# transformation:
even_counts = counts.apply(lambda x: x % 2 == 0)

# transpose a DataFrame:
transposed = data.transpose()
```

## Filtering


```python
filter_vec = data['Kind'] == "10.20"  # result: [True, True, False, ...]
filter_vec
```




    0    False
    1    False
    2    False
    3     True
    4    False
    5     True
    6    False
    7    False
    8    False
    Name: Kind, dtype: bool




```python
data[filter_vec]
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>sequence_number</th>
      <th>Timestamp</th>
      <th>Kind</th>
      <th>NormalCount</th>
      <th>TotalCount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>3</th>
      <td>2112888815</td>
      <td>2016-06-27 10:28:03</td>
      <td>10.20</td>
      <td>3</td>
      <td>15</td>
    </tr>
    <tr>
      <th>5</th>
      <td>808318967</td>
      <td>2016-04-10 21:11:11</td>
      <td>10.20</td>
      <td>4</td>
      <td>12</td>
    </tr>
  </tbody>
</table>
</div>



You can also construct the filtering vector using arbitrary function by using `.apply()`:


```python
data[ data['Kind'].apply(lambda x: x > '10.27') ]
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>sequence_number</th>
      <th>Timestamp</th>
      <th>Kind</th>
      <th>NormalCount</th>
      <th>TotalCount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>1006221952</td>
      <td>2016-04-13 17:31:09</td>
      <td>10.31</td>
      <td>6</td>
      <td>14</td>
    </tr>
  </tbody>
</table>
</div>



Filter vectors can be combined using `vec1 | vec2`:


```python
data[ (data['Kind'] == '10.31') | \
      (data['sequence_number'] == 808318967) ]
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>sequence_number</th>
      <th>Timestamp</th>
      <th>Kind</th>
      <th>NormalCount</th>
      <th>TotalCount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>1006221952</td>
      <td>2016-04-13 17:31:09</td>
      <td>10.31</td>
      <td>6</td>
      <td>14</td>
    </tr>
    <tr>
      <th>5</th>
      <td>808318967</td>
      <td>2016-04-10 21:11:11</td>
      <td>10.20</td>
      <td>4</td>
      <td>12</td>
    </tr>
  </tbody>
</table>
</div>



## Adding removing columns


```python
data.loc[:, 'NewCol'] = data['Kind'] > '10.27'
# or: data['NewCol'] = data['Kind'] > '10.27'
display(data[:2])

cols = list(data.columns)
cols.remove('NewCol')
seqnums = data['sequence_number'] # remember it in case we need it later
cols.remove('sequence_number')

# remove it
data = data[ cols ]
```


<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>sequence_number</th>
      <th>Timestamp</th>
      <th>Kind</th>
      <th>NormalCount</th>
      <th>TotalCount</th>
      <th>NewCol</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>484828304</td>
      <td>2016-06-18 00:49:34</td>
      <td>10.27</td>
      <td>3</td>
      <td>10</td>
      <td>False</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1006221952</td>
      <td>2016-04-13 17:31:09</td>
      <td>10.31</td>
      <td>6</td>
      <td>14</td>
      <td>True</td>
    </tr>
  </tbody>
</table>
</div>


### Count unique column values


```python
x = data['Kind'].value_counts()
display(x)
display(type(x))
```


    10.27    4
    10.24    2
    10.20    2
    10.31    1
    Name: Kind, dtype: int64



    pandas.core.series.Series



```python
data['Kind'].unique()
```




    array(['10.27', '10.31', '10.20', '10.24'], dtype=object)



## Column Wise Operation

`Series.Combine(other, func)` should serve the general purpose, but it seems the `func` return type is enforced to be the same as the series that's operated on.

Otherwise, division, multiplecatioin are all "numpy" flavored: `/` and `*`:


```python
aveCount = data['NormalCount'] / data['TotalCount']
data["AverageCount"] = aveCount
data[:2]
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Timestamp</th>
      <th>Kind</th>
      <th>NormalCount</th>
      <th>TotalCount</th>
      <th>AverageCount</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2016-06-18 00:49:34</td>
      <td>10.27</td>
      <td>3</td>
      <td>10</td>
      <td>0.300000</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2016-04-13 17:31:09</td>
      <td>10.31</td>
      <td>6</td>
      <td>14</td>
      <td>0.428571</td>
    </tr>
  </tbody>
</table>
</div>



## Grouping

[Document](http://pandas.pydata.org/pandas-docs/stable/groupby.html)


```python
grouped = data.groupby('Kind') # or ['Kind', 'NewCol']
display("Type of grouped is {0}".format(type(grouped)))

# iterating:
for key, group in grouped:
    print("==========")
    print("KEY IS: {0}".format(key))
    print("GROUP CONTENT:")
    print(group)
```


    "Type of grouped is <class 'pandas.core.groupby.DataFrameGroupBy'>"


    ==========
    KEY IS: 10.20
    GROUP CONTENT:
                Timestamp   Kind  NormalCount  TotalCount  AverageCount
    3 2016-06-27 10:28:03  10.20            3          15      0.200000
    5 2016-04-10 21:11:11  10.20            4          12      0.333333
    ==========
    KEY IS: 10.24
    GROUP CONTENT:
                Timestamp   Kind  NormalCount  TotalCount  AverageCount
    6 2016-05-18 20:29:01  10.24            3          14      0.214286
    7 2016-03-24 18:36:10  10.24            6          15      0.400000
    ==========
    KEY IS: 10.27
    GROUP CONTENT:
                Timestamp   Kind  NormalCount  TotalCount  AverageCount
    0 2016-06-18 00:49:34  10.27            3          10      0.300000
    2 2016-03-20 11:10:28  10.27            5          13      0.384615
    4 2016-03-29 11:48:52  10.27            5          16      0.312500
    8 2016-05-22 20:26:01  10.27            5          16      0.312500
    ==========
    KEY IS: 10.31
    GROUP CONTENT:
                Timestamp   Kind  NormalCount  TotalCount  AverageCount
    1 2016-04-13 17:31:09  10.31            6          14      0.428571
    

### Aggregation

It can be tricky. Refer to the [aggregation doc](http://pandas.pydata.org/pandas-docs/stable/groupby.html#aggregation)


```python
# You must select a single column before agg():
grouped['TotalCount'].agg({
        'sum': lambda group: sum(group),
        'min': lambda group: min(group)})
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>min</th>
      <th>sum</th>
    </tr>
    <tr>
      <th>Kind</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>10.20</th>
      <td>12</td>
      <td>27</td>
    </tr>
    <tr>
      <th>10.24</th>
      <td>14</td>
      <td>29</td>
    </tr>
    <tr>
      <th>10.27</th>
      <td>10</td>
      <td>55</td>
    </tr>
    <tr>
      <th>10.31</th>
      <td>14</td>
      <td>14</td>
    </tr>
  </tbody>
</table>
</div>




```python
def f(group):
    print(group)
    return "FOO"

# this is wrong:
# grouped.agg(f)
```


```python
# alternatively, construct per-column aggregation then combine them into a DataFrame:

total = grouped['TotalCount'].agg(sum) # result is a Series
display(total)

normal = grouped['NormalCount'].agg(sum)
display(normal)

new_data = pd.DataFrame({
        'total': total,
        'normal': normal,
        'ave': normal/total})
display(new_data)
```


    Kind
    10.20    27
    10.24    29
    10.27    55
    10.31    14
    Name: TotalCount, dtype: int64



    Kind
    10.20     7
    10.24     9
    10.27    18
    10.31     6
    Name: NormalCount, dtype: int64



<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ave</th>
      <th>normal</th>
      <th>total</th>
    </tr>
    <tr>
      <th>Kind</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>10.20</th>
      <td>0.259259</td>
      <td>7</td>
      <td>27</td>
    </tr>
    <tr>
      <th>10.24</th>
      <td>0.310345</td>
      <td>9</td>
      <td>29</td>
    </tr>
    <tr>
      <th>10.27</th>
      <td>0.327273</td>
      <td>18</td>
      <td>55</td>
    </tr>
    <tr>
      <th>10.31</th>
      <td>0.428571</td>
      <td>6</td>
      <td>14</td>
    </tr>
  </tbody>
</table>
</div>



```python
# To order the columns:
new_data = pd.DataFrame({'total' : total})
new_data['normal'] = normal
new_data['ave'] = normal / total

display(new_data)
```


<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>total</th>
      <th>normal</th>
      <th>ave</th>
    </tr>
    <tr>
      <th>Kind</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>10.20</th>
      <td>27</td>
      <td>7</td>
      <td>0.259259</td>
    </tr>
    <tr>
      <th>10.24</th>
      <td>29</td>
      <td>9</td>
      <td>0.310345</td>
    </tr>
    <tr>
      <th>10.27</th>
      <td>55</td>
      <td>18</td>
      <td>0.327273</td>
    </tr>
    <tr>
      <th>10.31</th>
      <td>14</td>
      <td>6</td>
      <td>0.428571</td>
    </tr>
  </tbody>
</table>
</div>


## Visualization

* [Visualization doc (charts)](http://pandas.pydata.org/pandas-docs/stable/visualization.html)
* [Style doc (table styles)](http://pandas.pydata.org/pandas-docs/stable/style.html)

For table coloring, you may need [seaborn](https://stanford.edu/~mwaskom/software/seaborn/). To install use `conda install seaborn`.


```python
import seaborn as sns
cm = sns.light_palette("green", as_cmap=True)

# conditional formatting
new_data.style.background_gradient(cmap=cm)
```





        <style  type="text/css" >
        
        
            #T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow0_col0 {
            
                background-color:  #9dd79d;
            
            }
        
            #T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow0_col1 {
            
                background-color:  #d3f5d3;
            
            }
        
            #T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow0_col2 {
            
                background-color:  #e5ffe5;
            
            }
        
            #T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow1_col0 {
            
                background-color:  #92d192;
            
            }
        
            #T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow1_col1 {
            
                background-color:  #acdfac;
            
            }
        
            #T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow1_col2 {
            
                background-color:  #a0d9a0;
            
            }
        
            #T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow2_col0 {
            
                background-color:  #008000;
            
            }
        
            #T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow2_col1 {
            
                background-color:  #008000;
            
            }
        
            #T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow2_col2 {
            
                background-color:  #8acc8a;
            
            }
        
            #T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow3_col0 {
            
                background-color:  #e5ffe5;
            
            }
        
            #T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow3_col1 {
            
                background-color:  #e5ffe5;
            
            }
        
            #T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow3_col2 {
            
                background-color:  #008000;
            
            }
        
        </style>

        <table id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3d" None>
        

        <thead>
            
            <tr>
                
                <th class="blank">
                
                <th class="col_heading level0 col0">total
                
                <th class="col_heading level0 col1">normal
                
                <th class="col_heading level0 col2">ave
                
            </tr>
            
            <tr>
                
                <th class="col_heading level2 col0">Kind
                
                <th class="blank">
                
                <th class="blank">
                
                <th class="blank">
                
            </tr>
            
        </thead>
        <tbody>
            
            <tr>
                
                <th id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3d" class="row_heading level0 row0">
                    10.20
                
                <td id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow0_col0" class="data row0 col0">
                    27
                
                <td id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow0_col1" class="data row0 col1">
                    7
                
                <td id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow0_col2" class="data row0 col2">
                    0.259259
                
            </tr>
            
            <tr>
                
                <th id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3d" class="row_heading level2 row1">
                    10.24
                
                <td id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow1_col0" class="data row1 col0">
                    29
                
                <td id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow1_col1" class="data row1 col1">
                    9
                
                <td id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow1_col2" class="data row1 col2">
                    0.310345
                
            </tr>
            
            <tr>
                
                <th id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3d" class="row_heading level2 row2">
                    10.27
                
                <td id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow2_col0" class="data row2 col0">
                    55
                
                <td id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow2_col1" class="data row2 col1">
                    18
                
                <td id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow2_col2" class="data row2 col2">
                    0.327273
                
            </tr>
            
            <tr>
                
                <th id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3d" class="row_heading level2 row3">
                    10.31
                
                <td id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow3_col0" class="data row3 col0">
                    14
                
                <td id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow3_col1" class="data row3 col1">
                    6
                
                <td id="T_04ff6be2_59d8_11e6_822b_9a5fd3327a3drow3_col2" class="data row3 col2">
                    0.428571
                
            </tr>
            
        </tbody>
        </table>
        


