## Parameters

1. Right click under Measures --> Create parameter
2. Right click the para --> Show parameter control
3. Right click the variable --> Size of bins



## Hierarchy

[Youtube](https://www.youtube.com/watch?v=RI-7ebWp9kE)

1. Drag sub-cat onto main cat --> Should auto create category



## Interactive dashboard

[Udemy](https://www.udemy.com/course/tableau10/learn/lecture/5650552#overview)

1. Click dropdown of one of the panes in the dashboard --> Use as filter



## Bullet

1. Drag "Goal" and "Actual" to the top --> Show me function



## Aggregations

*Detail* card: Lets you add more granularity than the plot

- X = sum(Sales) 
- Y = avg(Profit Ratio)
- Detail = Customer (will plot 1 dot per customer)



### Level of Detail

[Whitepaper](https://www.tableau.com/sites/default/files/media/whitepaper_lod_eng_0.pdf)

[15 examples](https://www.tableau.com/about/blog/LOD-expressions), ch 10 and 16

[Youtube vid, timestamped](https://www.youtube.com/watch?v=IvZd1L9zWxo&t=608s)

Adding details to a visual that are more granular than the primary key

- Fix the measure at a certain LOD
- Include dimensions not on the view
- Exclude dimensions that are on the view

```sql
{ fixed [Dimension] : sum([Measure]) }
```







