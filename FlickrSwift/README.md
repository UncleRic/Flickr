FlickrSwift
===========

This is the Swift version of Flickr, which was written in the classic Objective-C language.
<p>
You'll notice that there are no header files. <br/>

Swift uses 'let' objects for constant values; and
'var' objects for dynamic variables.
<br />
Swift introduces closures vs Objective-C's blocks.
<p>
Swift doesn't have pragmas versus Objective-C.  
Instead, I use the '// MARK:' directive and a class extension to organize the code.
<br/>
Swift has the class extension versus Objective-C's
class category.
<p>
I placed UICollectionViewDataSource methods into its own class extension; which
is an optional design pattern; as I would have done using categories in Objective-C.
<p>
The code of this Swift version is noticably <em>smaller</em> than its Objective-C
counterpart.
