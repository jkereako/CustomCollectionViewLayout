# Description
Lays out a UICollectionView as if it were an Excel spreadsheet. The top row and
the left column are sticky when scrolling. Because it behaves like a
spreadsheet, this implies that the column width of each cell are determined by
the column size, likewise the height of each cell is determined by the row
height.

This was forked from [Brightec's CustomCollectionViewLayout][fork]

# Difference from original
Brightec's version does everything in the `prepareLayout` method. I rewrote the
class and split the logic among UICollectionViewLayout's delegate methods.
Additionally, I added some caching behavior to reduce calculation time.

I also created a delegate for the SpreadsheetLayout. The delegate simply asks
for the column size and row height.

<img src="https://raw.githubusercontent.com/jkereako/SpreadsheetLayout/master/Images/screen.png" alt="KENO" width="320" height="568" />

[fork]: https://github.com/brightec/CustomCollectionViewLayout
