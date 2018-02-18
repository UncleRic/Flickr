Flickr
======

Flickr is a popular on-line image repository.  This is a simple photo-access application.

<b> Note: </b> This is a ***work-in-progress***. <br/>
This code is written in Objective-C per Code Challenge.<br/>
My <em>preference</em> is Swift 4.0.
<p>
<b>Modus Operandi</b><br/>
There are two (2) different reads from the server:<br/>
<ul>
<li>Initial Raw-Data</li>
<li>Per Collection Item</li>
</ul>
<p>
Both access the server via their respective [NSURLSession sharedSession] objects.
NSURLSession handles is own backend thread and comes with a callback block.
<p>
The <b>initial Raw-Data</b> retrieval populates instance variables on the main thread
for use as a <em>data source</em> by the UICollectionView via the 'per-collection item' in real time.
<p>
The <b>per collection-item</b> retrieval uses a callback block that is defined & implemented within the host UIViewController where the
UICollectionView's Cell/Index is populated with the respective image;
in real time.
<p>
<b>Probable Enhancement:</b>
<br/>
<ul>
<li>Re-write in Swift 4+.</li>
</ul>
