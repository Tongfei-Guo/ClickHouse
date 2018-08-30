<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1529377566136" ID="ID_118476249" MODIFIED="1533616736167" TEXT="ClickHouse">
<node CREATED="1529377590609" ID="ID_1577304766" MODIFIED="1533616737417" POSITION="right" TEXT="dbms">
<node CREATED="1529377607934" ID="ID_312710297" MODIFIED="1533616739143" TEXT="src">
<node CREATED="1530676004733" ID="ID_1892574328" LINK="#ID_1531562824" MODIFIED="1530676010727" TEXT="Columns"/>
<node CREATED="1529562197070" FOLDED="true" ID="ID_1624219091" MODIFIED="1534161041138" TEXT="Common">
<node CREATED="1530410316880" FOLDED="true" ID="ID_975847024" LINK="ClickHouse/dbms/src/Common/Allocator.h" MODIFIED="1533616736069" TEXT="Allocator.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_421158226" MODIFIED="1533616736068" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_84620039" MODIFIED="1533551799246" TEXT="description">
<node CREATED="1530516856539" ID="ID_1375855026" MODIFIED="1530517033730" TEXT="for allocating memory and update CurrentMemoryTracker.&#xa;implementation detail: using malloc / calloc with requested memory under 64MB, using mmap for above 64MB, why though?">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530013560221" ID="ID_1938613153" MODIFIED="1530513805211" TEXT="members"/>
<node CREATED="1530013563312" FOLDED="true" ID="ID_1173887598" MODIFIED="1533551799248" TEXT="concepts">
<node CREATED="1530513825293" ID="ID_62868052" LINK="https://en.wikipedia.org/wiki/Data_structure_alignment" MODIFIED="1530513831637" TEXT="memory alignment"/>
<node CREATED="1532587098806" ID="ID_1856548517" LINK="https://stackoverflow.com/questions/1739296/malloc-vs-mmap-in-c" MODIFIED="1532587106512" TEXT="mmap allocate memory"/>
<node CREATED="1532617726110" FOLDED="true" ID="ID_1277787690" LINK="https://stackoverflow.com/questions/8752546/how-does-malloc-understand-alignment" MODIFIED="1533551799247" TEXT="malloc alignment">
<node CREATED="1532617738411" ID="ID_1915343496" MODIFIED="1532618136213" TEXT="malloc seems to be aligned based on number of bytes allocated. For example, if I do void *p1 = malloc(1); void *p2 = malloc(1), they are 32 bytes apart, but *p1 = malloc(25); void *p2 = malloc(1) would be 64 bytes apart, on Ubuntu-64, g++-7"/>
</node>
<node CREATED="1532617841841" ID="ID_1539488941" LINK="http://man7.org/linux/man-pages/man3/posix_memalign.3.html" MODIFIED="1532617872968" TEXT="posix_memalign"/>
<node CREATED="1532618696275" ID="ID_1523588427" LINK="https://linux.die.net/man/2/munmap" MODIFIED="1532618701269" TEXT="munmap"/>
<node CREATED="1532621486591" ID="ID_833709530" LINK="https://linux.die.net/man/3/realloc" MODIFIED="1532621502256" TEXT="realloc"/>
<node CREATED="1532628695486" FOLDED="true" ID="ID_237078540" LINK="http://man7.org/linux/man-pages/man2/mremap.2.html" MODIFIED="1533551799248" TEXT="mremap">
<node CREATED="1532628699246" FOLDED="true" ID="ID_1598504419" MODIFIED="1533551799248" TEXT="why use mremap to implement realloc is fast?">
<node CREATED="1532628722825" ID="ID_1416808744" LINK="https://github.com/gperftools/gperftools/issues/55" MODIFIED="1532628730924" TEXT="link1"/>
<node CREATED="1532628762467" ID="ID_1661702966" LINK="https://stackoverflow.com/questions/11621606/faster-way-to-move-memory-page-than-mremap/11638774" MODIFIED="1532628766444" TEXT="link2"/>
<node CREATED="1532628770313" ID="ID_71720661" MODIFIED="1532628921741">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      follow link 1 : there are 2 ways to do malloc, in tcmalloc it does it as following
    </p>
    <p>
      malloc()
    </p>
    <p>
      memcpy()
    </p>
    <p>
      while if the requested size if huge, we can use mremap, which basic just shift mapping from virtual memory page to physical page, and save the time for memcpy()
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
</node>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1838279873" MODIFIED="1533551799263" TEXT="functions">
<node CREATED="1532586589308" FOLDED="true" ID="ID_61871433" MODIFIED="1533551799254" TEXT="void * alloc(size_t size, size_t alignment = 0)">
<node CREATED="1532617875906" ID="ID_454155916" LINK="#ID_1915343496" MODIFIED="1532618146519" STYLE="fork" TEXT="if requested size is greater than threadshold = 64MB, then use anonymous mmap to allocate memory, mmap use default page-aligned (4k alignment), so in this case, if &quot;alignment&quot; is greater than 4k, throw.&#xa;if requested size is less than 64MB, use malloc(calloc) if &quot;alignment&quot; is less than MMAP_MIN_ALIGNMENT=4K, which has some default alignment mechanism (see link). Otherwise, use posix_memalign to allocate memory with given &quot;alignment&quot;"/>
</node>
<node CREATED="1532586598543" FOLDED="true" ID="ID_793500491" MODIFIED="1533551799262" TEXT="void free(void * buf, size_t size)">
<node CREATED="1532618722106" ID="ID_235214674" MODIFIED="1532618784230" TEXT="if requested size is greater than threadshold, use munmap. Otherwise, use free (for malloc and calloc allocated memory)"/>
</node>
<node CREATED="1532586613219" FOLDED="true" ID="ID_1348999240" MODIFIED="1533551799262" TEXT="void * realloc(void * buf, size_t old_size, size_t new_size, size_t alignment = 0)">
<node CREATED="1532618788322" ID="ID_1900243215" MODIFIED="1532629219807">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      case1 (old_size = new_size) : do nothing
    </p>
    <p>
      case2 (old_size, new_size &lt; threshold) : call c realloc
    </p>
    <p>
      case3 (old_size, new_size &gt;= threshold) : call mremap
    </p>
    <p>
      case4 (old_size &gt;=threshold, new_size &lt;threshold) : call malloc to allocate new_size bytes, then memcpy, then munmap old mmap.
    </p>
    <p>
      case5 (old_size &lt;threshold, new_size &gt;=threshold) : mmap to allocate new_size bytes, then memcpy, then free old malloc memory
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1530014254828" ID="ID_177404979" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530410320226" ID="ID_23782791" LINK="ClickHouse/dbms/src/Common/Allocator.cpp" MODIFIED="1530523709233" TEXT="Allocator.cpp"/>
<node CREATED="1530267252869" FOLDED="true" ID="ID_344082896" LINK="ClickHouse/dbms/src/Common/Arena.h" MODIFIED="1533616736079" TEXT="Arena.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_786590814" MODIFIED="1533616736075" TEXT="properties">
<node CREATED="1530013557169" ID="ID_1476400479" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1888721742" MODIFIED="1530912173713" TEXT="members">
<node CREATED="1530519105127" FOLDED="true" ID="ID_1600705487" MODIFIED="1530912173712" TEXT="size_t">
<node CREATED="1530519135081" ID="ID_1932767658" MODIFIED="1530519236316" TEXT="growth_factor : the factor by which the size of Chunk grows, default value = 2"/>
</node>
<node CREATED="1530519120800" FOLDED="true" ID="ID_1669761718" MODIFIED="1530912173712" TEXT="size_t">
<node CREATED="1530519155462" ID="ID_196872042" MODIFIED="1530519163023" TEXT="linear_growth_threshod"/>
</node>
<node CREATED="1530519124996" FOLDED="true" ID="ID_666250508" MODIFIED="1530912173712" TEXT="Chunk *">
<node CREATED="1530519245815" ID="ID_1807201880" MODIFIED="1530519258839" TEXT="head : the first Chunk in arena"/>
</node>
<node CREATED="1530519131576" FOLDED="true" ID="ID_597647631" MODIFIED="1530912173712" TEXT="size_t">
<node CREATED="1530519259853" ID="ID_1814559175" MODIFIED="1530519315138" TEXT="size_in_bytes: total number of bytes chunks of the arena"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_576541397" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1851215643" MODIFIED="1530912173715" TEXT="functions">
<node CREATED="1530521078499" ID="ID_339410847" MODIFIED="1530521079966" TEXT="roundUpToPageSize"/>
<node CREATED="1530521080726" FOLDED="true" ID="ID_1529083451" MODIFIED="1530912173713" TEXT="nextSize">
<node CREATED="1530521314906" ID="ID_1285052879" MODIFIED="1530521389351" TEXT="calculate size of the next Chunk in the arena"/>
</node>
<node CREATED="1530521310784" FOLDED="true" ID="ID_1214664553" MODIFIED="1530912173713" TEXT="addChunk">
<node CREATED="1530521427692" ID="ID_718259483" MODIFIED="1530521442513" TEXT="add a new chunk by calling nextSize to determine its size"/>
</node>
<node CREATED="1530521443976" FOLDED="true" ID="ID_1198570246" MODIFIED="1530912173714" TEXT="alloc">
<node CREATED="1530521512815" ID="ID_417703472" MODIFIED="1530521625963" TEXT="allocate size bytes, if there is not"/>
</node>
<node CREATED="1530522652016" FOLDED="true" ID="ID_1343473532" MODIFIED="1530912173714" TEXT="char * allocContinue(size_t size, char const *&amp; begin)">
<node CREATED="1530522653564" ID="ID_79463327" MODIFIED="1530522785428" TEXT="allocate size bytes at end or keep add chunks until the newly added chunk is large enough to fit the original data and extra size bytes. "/>
</node>
<node CREATED="1530521983597" FOLDED="true" ID="ID_742559906" MODIFIED="1530912173714" TEXT="realloc(const char * old_data, size_t old_size, size_t new_size)">
<node CREATED="1530521984928" ID="ID_274324108" MODIFIED="1530522051266" TEXT="allocate new_size bytes at end, old_data is left alone (will be free when the whole arena is free)"/>
</node>
<node CREATED="1530522055630" FOLDED="true" ID="ID_1636531444" MODIFIED="1530912173714" TEXT="insert">
<node CREATED="1530522081842" ID="ID_1117814793" MODIFIED="1530522086585" TEXT="allocate space and insert at end"/>
</node>
</node>
<node CREATED="1530014254828" FOLDED="true" ID="ID_96401430" MODIFIED="1530912173718" TEXT="classes">
<node CREATED="1530520758062" FOLDED="true" ID="ID_804905048" MODIFIED="1530912173718" TEXT="Chunk">
<node CREATED="1530014332949" FOLDED="true" ID="ID_42937610" MODIFIED="1530912173718" TEXT="properties">
<node CREATED="1530013557169" ID="ID_700058148" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_585019007" MODIFIED="1530912173716" TEXT="members">
<node CREATED="1530520789130" FOLDED="true" ID="ID_1910102359" MODIFIED="1530912173715" TEXT="char *">
<node CREATED="1530520815546" ID="ID_950380705" MODIFIED="1530520870802" TEXT="begin : beginning of memory location in the arena"/>
</node>
<node CREATED="1530520789130" FOLDED="true" ID="ID_1617055136" MODIFIED="1530912173715" TEXT="char *">
<node CREATED="1530520843122" ID="ID_451879804" MODIFIED="1530520884512" TEXT="pos : position of currently allocated bytes"/>
</node>
<node CREATED="1530520789130" FOLDED="true" ID="ID_1034423277" MODIFIED="1530912173716" TEXT="char *">
<node CREATED="1530520853852" ID="ID_310595772" MODIFIED="1530520893283" TEXT="end : end of chunk"/>
</node>
<node CREATED="1530520809777" FOLDED="true" ID="ID_719549925" MODIFIED="1530912173716" TEXT="Chunk *">
<node CREATED="1530520856452" ID="ID_1955735754" MODIFIED="1530520935352" TEXT="prev : previous chunk, in arena, chunks are single-linked list"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1429219319" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1102057450" MODIFIED="1530912173717" TEXT="functions">
<node CREATED="1530520958197" FOLDED="true" ID="ID_1267814576" MODIFIED="1530912173716" TEXT="ctor, dtor">
<node CREATED="1530520966832" ID="ID_990192877" MODIFIED="1530521008507" TEXT="initialize and allocate / destruct and deallocate"/>
</node>
<node CREATED="1530521012073" FOLDED="true" ID="ID_1087832954" MODIFIED="1530912173717" TEXT="size">
<node CREATED="1530521017240" ID="ID_1966774036" MODIFIED="1530521022725" TEXT="size of the chunk"/>
</node>
<node CREATED="1530521023573" FOLDED="true" ID="ID_1121630802" MODIFIED="1530912173717" TEXT="remaining">
<node CREATED="1530521026903" ID="ID_1844204303" MODIFIED="1530521048073" TEXT="remaining bytes that can still be allocated within this chunk"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_79954247" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1530857167523" FOLDED="true" ID="ID_1126954633" LINK="ClickHouse/dbms/src/Common/ConcurrentBoundedQueue.h" MODIFIED="1533616736081" TEXT="ConcurrentBoundedQueue.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1482350517" MODIFIED="1533616736080" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_267232598" MODIFIED="1530912173719" TEXT="description">
<node CREATED="1530857226871" ID="ID_1441165458" MODIFIED="1530857268968" TEXT=" A very simple thread-safe queue of limited size. &#xa;1. If you try to pop an item from an empty queue, the thread is blocked until the queue becomes nonempty.&#xa;2. If you try to push an element into an overflowed queue, the thread is blocked until space appears in the queue. "/>
</node>
<node CREATED="1530013560221" ID="ID_1789752873" MODIFIED="1530696720033" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_47681775" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_1981038358" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_338200801" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1529562224190" ID="ID_1408895283" LINK="ClickHouse/dbms/src/Common/COWPtr.h" MODIFIED="1534139749828" TEXT="COWPtr.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_938498885" MODIFIED="1533616736082" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1578730461" MODIFIED="1533551799266" TEXT="description">
<node CREATED="1530065136871" ID="ID_119834610" MODIFIED="1530081735999" TEXT="a copy-on-write template class pointer that does copy upon attempting to modify the underlying object by calling its mutate() method to create a mutable pointer">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530013560221" ID="ID_1983035509" MODIFIED="1530013562255" TEXT="members"/>
<node CREATED="1530013563312" FOLDED="true" ID="ID_513284411" MODIFIED="1533551799266" TEXT="concepts">
<node CREATED="1530064527173" ID="ID_223257405" LINK="https://stackoverflow.com/questions/40035282/c-typedef-typename-classnametemplate/40035372" MODIFIED="1530064546702" TEXT="typename classname::template"/>
<node CREATED="1530065031184" ID="ID_664512206" LINK="https://blogs.msdn.microsoft.com/slippman/2004/08/11/why-c-supports-both-class-and-typename-for-type-parameters/" MODIFIED="1530065072145" TEXT="typename template::type"/>
</node>
<node CREATED="1530014251553" FOLDED="true" ID="ID_14458493" MODIFIED="1533551799267" TEXT="functions">
<node CREATED="1530081790800" FOLDED="true" ID="ID_239962989" MODIFIED="1533551799266" TEXT="mutate">
<node CREATED="1530081799872" ID="ID_158195904" MODIFIED="1530081913424" TEXT="check if use_count() is greater than 1 (if shared), if so, make a mutable copy from it and returnm, otherwise it&apos;s the sole owner of the underlying object (be it a mutable or immutable pointer), so we just can cast it to a mutable pointer can return"/>
</node>
</node>
<node CREATED="1530014254828" FOLDED="true" ID="ID_1059102078" MODIFIED="1533551799267" TEXT="classes">
<node CREATED="1530014444146" ID="ID_477587863" MODIFIED="1530014472365" TEXT="mutable_ptr"/>
<node CREATED="1530014473118" ID="ID_494711730" MODIFIED="1530014474904" TEXT="immutable_ptr"/>
</node>
</node>
<node CREATED="1530013883774" ID="ID_605860566" MODIFIED="1534139749828" TEXT="COWPtr&lt;IColumn&gt;">
<node CREATED="1529562027990" ID="ID_1531562824" MODIFIED="1534139749828" TEXT="Columns">
<node CREATED="1529481458962" ID="ID_1486715561" LINK="ClickHouse/dbms/src/Columns/IColumn.h" MODIFIED="1534139749828" TEXT="IColumn.h">
<node CREATED="1530070033954" FOLDED="true" ID="ID_1700808145" MODIFIED="1533616736083" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_632498998" MODIFIED="1532519418342" TEXT="description">
<node CREATED="1530065136871" ID="ID_402381774" MODIFIED="1530079417126" TEXT="a column prototype for other more specific column types to inherit from using CRTP"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1561085078" MODIFIED="1530912173722" TEXT="members">
<node CREATED="1530079427056" ID="ID_1569737862" MODIFIED="1530079430498" TEXT="no members"/>
</node>
<node CREATED="1530013563312" FOLDED="true" ID="ID_1291905408" MODIFIED="1533551799269" TEXT="concepts">
<node CREATED="1529481477376" FOLDED="true" ID="ID_1374148346" LINK="https://www.fluentcpp.com/2017/05/12/curiously-recurring-template-pattern/" MODIFIED="1533551799268" TEXT="CRTP (Curiously Recurring Template Pattern)">
<node CREATED="1530263349331" ID="ID_358618060" LINK="https://stackoverflow.com/questions/8336220/how-can-a-class-inherit-from-a-template-based-on-itself" MODIFIED="1530263362999" TEXT="further explanation on why CRTP works"/>
</node>
</node>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1267497067" MODIFIED="1533551799269" TEXT="functions">
<node CREATED="1530178601006" FOLDED="true" ID="ID_1009708147" MODIFIED="1530912173723" TEXT="virtual byteSize">
<node CREATED="1530178604902" ID="ID_981746181" MODIFIED="1530178642096" TEXT="size of column data in memory (may be approximate) - for profiling. Zero, if could not be determined.(from comment)"/>
</node>
<node CREATED="1530065303903" FOLDED="true" ID="ID_397651375" MODIFIED="1530912173723" TEXT="virtual clone">
<node CREATED="1530065321814" ID="ID_1433393022" MODIFIED="1530065344499" TEXT="used by COWPtr to clone a immutable ptr"/>
</node>
<node CREATED="1530254360489" FOLDED="true" ID="ID_1270207149" MODIFIED="1530912173723" TEXT="virtual convertToFullColumnIfConst">
<node CREATED="1530254364933" ID="ID_94339063" MODIFIED="1530254404977" TEXT="If column isn&apos;t constant, returns nullptr (or itself).&#xa;If column is constant, transforms constant to full column (if column type allows such tranform) and return it."/>
</node>
<node CREATED="1530071078442" FOLDED="true" ID="ID_1439094982" MODIFIED="1530912173724" TEXT="virtual Field operator[]">
<node CREATED="1530071158750" ID="ID_1089766720" MODIFIED="1530071212050" TEXT="return a row in the column as a Field"/>
</node>
<node CREATED="1530695827453" FOLDED="true" ID="ID_45752941" MODIFIED="1530912173724" TEXT="virtual getExtremes = 0">
<node CREATED="1530695831653" ID="ID_31538286" MODIFIED="1530695900581" TEXT="Computes minimum and maximum element of the column, for numeric types, data types, string types, and array types"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_829392990" MODIFIED="1530528795837" TEXT="classes"/>
<node CREATED="1530528789660" FOLDED="true" ID="ID_408273906" MODIFIED="1530912173725" TEXT="typedef">
<node CREATED="1530528801287" FOLDED="true" ID="ID_196599894" MODIFIED="1530912173725" TEXT="Filter">
<node CREATED="1530528805613" ID="ID_1676530480" MODIFIED="1530528813315" TEXT="PaddedPODArray&lt;UInt8&gt;"/>
</node>
<node CREATED="1530528814216" FOLDED="true" ID="ID_180922051" MODIFIED="1530912173725" TEXT="Permutation">
<node CREATED="1530528825955" ID="ID_1679183918" MODIFIED="1530528826792" TEXT="PaddedPODArray&lt;size_t&gt;"/>
</node>
</node>
</node>
<node CREATED="1530070109109" ID="ID_1324882847" MODIFIED="1534139749843" TEXT="COWPtrHelper&lt;IColumn, Derived&gt;">
<font NAME="SansSerif" SIZE="13"/>
<node CREATED="1530070033954" FOLDED="true" ID="ID_928427460" MODIFIED="1530696740097" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1289420687" MODIFIED="1530912173725" TEXT="description">
<node CREATED="1530065136871" ID="ID_104606475" MODIFIED="1530080602872" TEXT="a helper class that brings out some of the interface to public">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530013560221" ID="ID_1522195731" MODIFIED="1530013562255" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_612685832" MODIFIED="1530065225199" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_193256146" MODIFIED="1530912173726" TEXT="functions">
<node CREATED="1530181004607" FOLDED="true" ID="ID_1725619756" MODIFIED="1530912173726" TEXT="derived">
<node CREATED="1530181016883" ID="ID_894907717" MODIFIED="1530181049171" TEXT="static_cast to Derived type"/>
</node>
<node CREATED="1530181014283" ID="ID_929519693" MODIFIED="1530181015989" TEXT="create"/>
<node CREATED="1530181091616" FOLDED="true" ID="ID_1681348279" MODIFIED="1530912173726" TEXT="clone">
<node CREATED="1530181093364" ID="ID_1384736739" MODIFIED="1530181099614" TEXT="create a mutable "/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1947339689" MODIFIED="1530065234423" TEXT="classes"/>
</node>
<node CREATED="1530585638799" ID="ID_1778704913" LINK="ClickHouse/dbms/src/Columns/ColumnArray.h" MODIFIED="1534139749843" TEXT="ColumnArray.h">
<node CREATED="1530070033954" ID="ID_363520971" MODIFIED="1534139749843" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1454601390" MODIFIED="1533616736084" TEXT="description">
<node CREATED="1530600805410" ID="ID_1464919303" MODIFIED="1530600893747" TEXT="A column of array values.  In memory, it is represented as one data column, whose size is equal to the sum of the sizes of all arrays, and one offset column, which stores offset of each element in the array (similar to ColumnString)"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1290321726" MODIFIED="1533616736084" TEXT="members">
<node CREATED="1530587000238" FOLDED="true" ID="ID_404611147" MODIFIED="1533551799272" TEXT="ColumnPtr">
<node CREATED="1530587002903" ID="ID_83803010" MODIFIED="1533526191297" TEXT="data, stores a ColumnVec for example"/>
</node>
<node CREATED="1530587001493" FOLDED="true" ID="ID_1755391756" MODIFIED="1533551799272" TEXT="ColumnPtr">
<node CREATED="1530587007961" ID="ID_938951540" MODIFIED="1533526200099" TEXT="offsets, stores a ColumnVec for example "/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1147329553" MODIFIED="1530065225199" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_815552347" MODIFIED="1534139749859" TEXT="functions">
<node CREATED="1530588466232" FOLDED="true" ID="ID_1413897759" MODIFIED="1533551799273" TEXT="getData">
<node CREATED="1530588467572" ID="ID_897104498" MODIFIED="1530588491972" TEXT="calls assumeMutableRef to get a IColumn &amp;"/>
</node>
<node CREATED="1530597317705" FOLDED="true" ID="ID_787859857" MODIFIED="1532511284014" TEXT="cloneResized">
<node CREATED="1530597330704" ID="ID_226381726" MODIFIED="1530597343209" TEXT="clone current vector with empty paddings "/>
</node>
<node CREATED="1530597526708" FOLDED="true" ID="ID_1760332137" MODIFIED="1532511282134" TEXT="sizeAt / offsetAt">
<node CREATED="1530597540941" ID="ID_94854735" MODIFIED="1530597566171" TEXT="return size / offset of n-th array in the column"/>
</node>
<node CREATED="1530597528371" FOLDED="true" ID="ID_927630756" MODIFIED="1533605426758" TEXT="operator[]">
<node CREATED="1530598585388" ID="ID_157831246" MODIFIED="1533527166956" TEXT="return n-th array in a vector&lt;Field&gt;, because its an array (each element in the column is an array)"/>
</node>
<node CREATED="1530600450441" FOLDED="true" ID="ID_1285428799" MODIFIED="1533551799273" TEXT="get">
<node CREATED="1530600451550" ID="ID_1524601110" MODIFIED="1530600556451" TEXT="similar functionality to operator[], in its definition: res = Array(size), direct calls to  &#xa;template &lt;typename T&gt;  std::enable_if_t&lt;!std::is_same_v&lt;std::decay_t&lt;T&gt;, Field&gt;, Field &amp;&gt;  &#xa;operator= (T &amp;&amp; rhs)"/>
</node>
<node CREATED="1533553930269" ID="ID_946240568" MODIFIED="1534139786051" TEXT="static Ptr create(const ColumnPtr &amp; nested_column, const ColumnPtr &amp; offsets_column)">
<node CREATED="1533553953882" ID="ID_1241805856" LINK="illustration%20of%20ColumnArray_create.png" MODIFIED="1533605690988" TEXT="it assumes that nested_column and offsets_column are mutable, and move them into a new column array, see link for illustration"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_99385540" MODIFIED="1530065234423" TEXT="classes"/>
<node CREATED="1530587452312" FOLDED="true" ID="ID_1404689874" MODIFIED="1533616736086" TEXT="typedef">
<node CREATED="1530587454733" FOLDED="true" ID="ID_1391623464" MODIFIED="1532503390873" TEXT="ColumnOffsets">
<node CREATED="1530587463577" ID="ID_611630034" MODIFIED="1530587467595" TEXT="ColumnVector&lt;Offset&gt;"/>
</node>
<node CREATED="1530597914292" FOLDED="true" ID="ID_1400210120" LINK="#ID_1771382363" MODIFIED="1532503392664" TEXT="Array">
<node CREATED="1530597958675" ID="ID_803106554" MODIFIED="1530597959441" TEXT="std::vector&lt;Field&gt; "/>
</node>
</node>
</node>
</node>
<node CREATED="1530585643497" ID="ID_355662383" LINK="ClickHouse/dbms/src/Columns/ColumnArray.cpp" MODIFIED="1530585683542" TEXT="ColumnArray.cpp"/>
<node CREATED="1530155382935" FOLDED="true" ID="ID_1061035412" LINK="ClickHouse/dbms/src/Columns/ColumnConst.h" MODIFIED="1533551799274" TEXT="ColumnConst.h">
<node CREATED="1530070033954" FOLDED="true" ID="ID_1595306224" MODIFIED="1532504560079" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_317845702" MODIFIED="1530912173732" TEXT="description">
<node CREATED="1530065136871" ID="ID_120869957" MODIFIED="1530157663831" TEXT="ColumnConst contains another column with single element, but looks like a column with arbitary amount of same elements. (according to comment), from the look of its interface, it stores could store nested ColumnConst, and the inner most ColumnConst stores 1 element of some type, and insert(), etc only increase its size by 1 but do not have any actual data">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_102258888" MODIFIED="1530912173732" TEXT="members">
<node CREATED="1530155727812" FOLDED="true" ID="ID_1699603601" MODIFIED="1530912173732" TEXT="ColumnPtr">
<node CREATED="1530257402167" ID="ID_236205716" MODIFIED="1530257518869" TEXT="data : points to 1 sample IColumn-derived type, for instance, it could points to a ColumnConst"/>
</node>
<node CREATED="1530070549743" FOLDED="true" ID="ID_1298292060" MODIFIED="1530912173732" TEXT="size_t">
<node CREATED="1530070714023" ID="ID_577480277" MODIFIED="1530257602345" TEXT="s : number of element(column) stored. It could be later &quot;materialize&quot; by make s copy of data, and assign it to a newly create column, by storing it this way, it saves storage. See &quot;materializeBlock.h&quot;"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_550865913" MODIFIED="1530065225199" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1872163570" MODIFIED="1530912173734" TEXT="functions">
<node CREATED="1530157143090" FOLDED="true" ID="ID_1780273830" MODIFIED="1530912173733" TEXT="ColumnConst(const ColumnPtr &amp; data_, size_t s)">
<node CREATED="1530157148257" ID="ID_1629436499" MODIFIED="1530157212588" TEXT="for nested ColumnConst, find the innermost columnconst (i.e. squash const of const), and check it&apos;s size is 1."/>
</node>
<node CREATED="1530254510678" FOLDED="true" ID="ID_730448822" MODIFIED="1530912173733" TEXT="convertToFullColumn">
<node CREATED="1530257986128" ID="ID_305592245" LINK="convertToFullColumn()%20illustration.png" MODIFIED="1530259433254" TEXT="create a PODArray with Offsets(1, s), which is similar to vector&lt;Unit64&gt; {s}, then pass it to data-&gt;replicate"/>
</node>
<node CREATED="1530254431485" FOLDED="true" ID="ID_1501228867" LINK="#ID_1270207149" MODIFIED="1530912173733" TEXT="virtual convertToFullColumnIfConst override">
<node CREATED="1530254446483" ID="ID_755390338" LINK="#ID_730448822" MODIFIED="1530254519017" TEXT="direct calls to convertToFullColumn"/>
</node>
<node CREATED="1530071105327" ID="ID_1154016027" LINK="#ID_1439094982" MODIFIED="1530071138191" TEXT="virtual Field operator[] "/>
</node>
<node CREATED="1530014254828" ID="ID_1482528590" MODIFIED="1530065234423" TEXT="classes"/>
</node>
</node>
<node CREATED="1530155387597" ID="ID_160517399" LINK="ClickHouse/dbms/src/Columns/ColumnConst.cpp" MODIFIED="1530155424364" TEXT="ColumnConst.cpp"/>
<node CREATED="1530070214879" FOLDED="true" ID="ID_280302373" LINK="ClickHouse/dbms/src/Columns/ColumnFixedString.h" MODIFIED="1533551799274" TEXT="ColumnFixedString.h">
<node CREATED="1530070033954" FOLDED="true" ID="ID_730378692" MODIFIED="1532511302551" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1962338815" MODIFIED="1533551799274" TEXT="description">
<node CREATED="1530065136871" ID="ID_1760110908" MODIFIED="1530080763382" TEXT="a column that stores strings of fixed length, memory storage employs PaddedPODArray, a STL vector like container"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1531604154" MODIFIED="1533551799274" TEXT="members">
<node CREATED="1530070381767" FOLDED="true" ID="ID_842298818" MODIFIED="1530912173735" TEXT="PaddedPODArray&lt;UInt8&gt;(Chars_t)">
<node CREATED="1530070594063" ID="ID_402778072" MODIFIED="1530070706589" TEXT="each entry stores a character in the string, all strings are stored contiguously with fixed length, no trailing zero byte between 2 adjacent strings"/>
</node>
<node CREATED="1530070549743" FOLDED="true" ID="ID_625661012" MODIFIED="1530912173735" TEXT="size_t">
<node CREATED="1530070714023" ID="ID_941068449" MODIFIED="1530070726079" TEXT="total number of strings in this column"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_565313442" MODIFIED="1530065225199" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_336501595" MODIFIED="1533551799274" TEXT="functions">
<node CREATED="1530071105327" ID="ID_1651097306" LINK="#ID_1439094982" MODIFIED="1530071138191" TEXT="virtual Field operator[] "/>
</node>
<node CREATED="1530014254828" ID="ID_1209299717" MODIFIED="1530065234423" TEXT="classes"/>
</node>
</node>
<node CREATED="1530070225527" ID="ID_395709402" LINK="ClickHouse/dbms/src/Columns/ColumnFixedString.cpp" MODIFIED="1530070270201" TEXT="ColumnFixedString.cpp"/>
<node CREATED="1530070228109" FOLDED="true" ID="ID_1282390595" LINK="ClickHouse/dbms/src/Columns/ColumnString.h" MODIFIED="1533551799275" TEXT="ColumnString.h">
<node CREATED="1530070033954" FOLDED="true" ID="ID_1893778167" MODIFIED="1532503328945" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1848169613" MODIFIED="1533551799275" TEXT="description">
<node CREATED="1530065136871" ID="ID_1285941977" MODIFIED="1530080786531" TEXT="a column that stores strings of variable length, memory storage employs PaddedPODArray, a STL vector like container"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1671733064" MODIFIED="1533551799275" TEXT="members">
<node CREATED="1530070428206" FOLDED="true" ID="ID_376340402" MODIFIED="1530912173737" TEXT="PaddedPODArray&lt;UInt8&gt;(Chars_t) ">
<node CREATED="1530070744607" ID="ID_1734310750" MODIFIED="1530070794262" TEXT="each entry stores a character in the string, all strings are stored contiguously with variable length, has trailing zero byte between 2 adjacent strings"/>
</node>
<node CREATED="1530070499006" FOLDED="true" ID="ID_1690018878" MODIFIED="1530912173737" TEXT="PaddedPODArray&lt;Unit64&gt;(Offsets)">
<node CREATED="1530070799551" ID="ID_1119631493" MODIFIED="1530080982353" TEXT="length is equal to the number of strings stored in this column, offsets[i - 1] is the position where the n-th string starts in Chars_t"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1237193598" MODIFIED="1530065225199" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_259754859" MODIFIED="1533551799275" TEXT="functions">
<node CREATED="1530071105327" ID="ID_600148330" LINK="#ID_1439094982" MODIFIED="1530071138191" TEXT="virtual Field operator[] "/>
<node CREATED="1530695827453" ID="ID_1938152649" LINK="#ID_45752941" MODIFIED="1530695930253" TEXT="virtual getExtremes override"/>
</node>
<node CREATED="1530014254828" FOLDED="true" ID="ID_1831975068" MODIFIED="1533551799275" TEXT="classes">
<node CREATED="1530695645639" FOLDED="true" ID="ID_620759816" MODIFIED="1530912173739" TEXT="less">
<node CREATED="1530695651766" FOLDED="true" ID="ID_502613237" MODIFIED="1530912173738" TEXT="definition">
<node CREATED="1530695661845" ID="ID_294860396" MODIFIED="1530695675276" TEXT="compares 2 string as strcmp does"/>
</node>
<node CREATED="1530695676554" FOLDED="true" ID="ID_1110507627" MODIFIED="1530912173738" TEXT="concepts">
<node CREATED="1530695681053" ID="ID_579402836" LINK="https://stackoverflow.com/questions/13095513/what-is-the-difference-between-memcmp-strcmp-and-strncmp-in-c" MODIFIED="1530695737389" TEXT="it uses memcmp instead of strcmp, because it&apos;s faster, see link, search for &quot;memcmp can be a lot faster&quot;"/>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1530070240932" ID="ID_473780511" LINK="ClickHouse/dbms/src/Columns/ColumnString.cpp" MODIFIED="1530070289753" TEXT="ColumnString.cpp"/>
<node CREATED="1533538805187" FOLDED="true" ID="ID_1992841700" LINK="ClickHouse/dbms/src/Columns/ColumnTuple.h" MODIFIED="1533616736090" TEXT="ColumnTuple.h">
<node CREATED="1533539300152" FOLDED="true" ID="ID_1423448449" MODIFIED="1533608078856" TEXT="properties">
<node CREATED="1533539303441" FOLDED="true" ID="ID_1459091551" MODIFIED="1533616736089" TEXT="description">
<node CREATED="1533608015759" ID="ID_647773137" MODIFIED="1533608068118" TEXT="each columntuple stores a number of columns, simple as that"/>
</node>
<node CREATED="1533539307860" FOLDED="true" ID="ID_45423716" MODIFIED="1533616736090" TEXT="members">
<node CREATED="1533539329898" FOLDED="true" ID="ID_263038693" MODIFIED="1533616736089" TEXT="Columns">
<node CREATED="1533539376106" ID="ID_339163009" MODIFIED="1533539378168" TEXT="columns : "/>
</node>
</node>
<node CREATED="1533539310009" ID="ID_1493856482" MODIFIED="1533539314092" TEXT="concepts"/>
<node CREATED="1533539314558" ID="ID_477710520" MODIFIED="1533539316769" TEXT="functions"/>
<node CREATED="1533539318033" ID="ID_162594226" MODIFIED="1533539319793" TEXT="classes"/>
</node>
</node>
<node CREATED="1533538813484" ID="ID_898584157" LINK="ClickHouse/dbms/src/Columns/ColumnVector.cpp" MODIFIED="1533539293623" TEXT="ColumnTuple.cpp"/>
<node CREATED="1530263545615" FOLDED="true" ID="ID_1879091572" LINK="ClickHouse/dbms/src/Columns/ColumnVector.h" MODIFIED="1533551799279" TEXT="ColumnVector.h">
<node CREATED="1530070033954" FOLDED="true" ID="ID_262059746" MODIFIED="1532511293751" TEXT="properties">
<node CREATED="1530013557169" ID="ID_238426046" MODIFIED="1530156208121" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_164105777" MODIFIED="1533551799278" TEXT="members">
<node CREATED="1530263799986" FOLDED="true" ID="ID_401665756" MODIFIED="1530912173740" TEXT="PaddedPODArray&lt;T&gt;">
<node CREATED="1530263803522" ID="ID_1965957114" MODIFIED="1530263840878" TEXT="data : like in ColumnString, this stores the actual data"/>
</node>
</node>
<node CREATED="1530013563312" FOLDED="true" ID="ID_632399342" MODIFIED="1533551799278" TEXT="concepts">
<node CREATED="1530530233727" ID="ID_1712748164" LINK="https://en.cppreference.com/w/cpp/algorithm/partial_sort" MODIFIED="1530530245320" TEXT="std::partial_sort"/>
</node>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1068606412" MODIFIED="1533551799278" TEXT="functions">
<node CREATED="1530524126114" FOLDED="true" ID="ID_691922031" MODIFIED="1530912173741" TEXT="virtual serializeValueIntoArena override">
<node CREATED="1530524130037" ID="ID_1427413815" MODIFIED="1530524178915" TEXT="put element from ColumnVector at position n into arena"/>
</node>
<node CREATED="1530524132776" FOLDED="true" ID="ID_805211547" MODIFIED="1530912173741" TEXT="virtual deserializeAndInsertFromArena override">
<node CREATED="1530524180262" ID="ID_914754424" MODIFIED="1530524207848" TEXT="retrieve element from Arena (actually a pointer)"/>
</node>
<node CREATED="1530530603588" FOLDED="true" ID="ID_1114885796" MODIFIED="1530912173741" TEXT="virtual getPermutation override">
<node CREATED="1530530606820" ID="ID_1684233428" MODIFIED="1530530670302" TEXT="partial sort / sort the vector in some way"/>
</node>
<node CREATED="1530530671285" FOLDED="true" ID="ID_1219017750" MODIFIED="1530912173742" TEXT="virtual cloneResized override">
<node CREATED="1530531247723" ID="ID_1872061201" MODIFIED="1530531256449" TEXT="clone current vector with zero paddings"/>
</node>
<node CREATED="1530532080599" FOLDED="true" ID="ID_349317215" MODIFIED="1530912173742" TEXT="virtual insertRangeFrom(const IColumn &amp; src, size_t start, size_t length) override">
<node CREATED="1530532095329" ID="ID_110707735" MODIFIED="1530532123580" TEXT="insert from src to current vector length bytes starting from start"/>
</node>
<node CREATED="1530532124811" FOLDED="true" ID="ID_869743042" MODIFIED="1530912173742" TEXT="virtual filter override">
<node CREATED="1530532643498" ID="ID_1719025750" MODIFIED="1530532691456" TEXT="filter out these entries which do not match filter (where filter&apos;s corresponding entries are 0s), do not understand the optimization">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530532693135" FOLDED="true" ID="ID_740108752" MODIFIED="1530912173742" TEXT="virtual permute override">
<node CREATED="1530532875479" ID="ID_1239710310" MODIFIED="1530532885916" TEXT="permutate data with specific order"/>
</node>
<node CREATED="1530533332767" FOLDED="true" ID="ID_160384962" MODIFIED="1530912173743" TEXT="virtual replicate override">
<node CREATED="1530533333941" ID="ID_1629698962" MODIFIED="1530533388002" TEXT="Copies each element according offsets parameter. (i-th element should be copied offsets[i] - offsets[i - 1] times.)   (It is necessary in ARRAY JOIN operation.)"/>
</node>
<node CREATED="1530533478228" ID="ID_149054793" MODIFIED="1530533577785" TEXT="virtual gather override">
<icon BUILTIN="help"/>
<icon BUILTIN="pencil"/>
</node>
<node CREATED="1530533579119" FOLDED="true" ID="ID_759416433" MODIFIED="1530912173743" TEXT="virtual getExtremes override">
<node CREATED="1530534867668" ID="ID_1259483662" MODIFIED="1530534875025" TEXT="return max and min through reference"/>
</node>
</node>
<node CREATED="1530014254828" FOLDED="true" ID="ID_1789759617" MODIFIED="1530912173749" TEXT="classes">
<node CREATED="1530263662130" FOLDED="true" ID="ID_882771646" MODIFIED="1530912173745" TEXT="CompareHelper">
<node CREATED="1530014251553" FOLDED="true" ID="ID_535085684" MODIFIED="1530912173745" TEXT="functions">
<node CREATED="1530264551180" FOLDED="true" ID="ID_213825333" MODIFIED="1530912173744" TEXT="less">
<node CREATED="1530264561132" ID="ID_797075410" MODIFIED="1530264567259" TEXT="return a &lt; b"/>
</node>
<node CREATED="1530264553519" FOLDED="true" ID="ID_540084668" MODIFIED="1530912173744" TEXT="greater">
<node CREATED="1530264561132" ID="ID_588881967" MODIFIED="1530264573532" TEXT="return a &gt; b"/>
</node>
<node CREATED="1530264556645" FOLDED="true" ID="ID_1952212745" MODIFIED="1530912173744" TEXT="compare">
<node CREATED="1530264561132" ID="ID_370445689" MODIFIED="1530264590166" TEXT="return -1, 0, 1 accordingly"/>
</node>
</node>
</node>
<node CREATED="1530263664115" FOLDED="true" ID="ID_308094771" MODIFIED="1530912173746" TEXT="FloatCompareHelper">
<node CREATED="1530013557169" ID="ID_799248068" MODIFIED="1530156208121" TEXT="description"/>
<node CREATED="1530013560221" ID="ID_586935217" MODIFIED="1530156208122" TEXT="members"/>
<node CREATED="1530013563312" FOLDED="true" ID="ID_1631457529" MODIFIED="1530912173745" TEXT="concepts">
<node CREATED="1530264491341" ID="ID_16362632" LINK="https://en.cppreference.com/w/cpp/numeric/math/isnan" MODIFIED="1530264506537" TEXT="isnan"/>
<node CREATED="1530265154824" FOLDED="true" ID="ID_1403873706" LINK="http://www.cppblog.com/baby-fly/archive/2011/01/27/139432.html" MODIFIED="1530912173745" TEXT="likely">
<node CREATED="1530267695439" ID="ID_803453338" LINK="#ID_1551063807" MODIFIED="1530267773360" TEXT="here likely is defined as the same macro as likely in C, shown in the header file"/>
</node>
</node>
<node CREATED="1530014251553" FOLDED="true" ID="ID_413165653" MODIFIED="1530912173746" TEXT="functions">
<node CREATED="1530265559990" FOLDED="true" ID="ID_286467376" MODIFIED="1530912173746" TEXT="less / greater / compare">
<node CREATED="1530265566912" ID="ID_231250465" MODIFIED="1530265577394" TEXT="similar to CompareHelper with checking for nan"/>
</node>
</node>
</node>
<node CREATED="1530263617678" FOLDED="true" ID="ID_327443578" MODIFIED="1530912173748" TEXT="ColumnVector&lt;T&gt;::less">
<node CREATED="1530266498107" FOLDED="true" ID="ID_1609834102" MODIFIED="1530912173747" TEXT="members">
<node CREATED="1530266521625" FOLDED="true" ID="ID_362964214" MODIFIED="1530912173747" TEXT="ColumnVector&lt;T&gt;">
<node CREATED="1530266544171" ID="ID_215529371" MODIFIED="1530266646176" TEXT="parent "/>
</node>
<node CREATED="1530266538179" FOLDED="true" ID="ID_761330408" MODIFIED="1530912173747" TEXT="int">
<node CREATED="1530266551098" ID="ID_1594469151" MODIFIED="1530266557875" TEXT="hint"/>
</node>
</node>
<node CREATED="1530266508172" FOLDED="true" ID="ID_708201619" MODIFIED="1530912173748" TEXT="functions">
<node CREATED="1530266596342" FOLDED="true" ID="ID_1864946861" MODIFIED="1530912173747" TEXT="bool operator()(size_t lhs, size_t rhs)">
<node CREATED="1530266598651" ID="ID_1966325961" MODIFIED="1530266636183" TEXT="compares the relation of 2 elements from parent indicated by index lhs and rhs"/>
</node>
</node>
</node>
<node CREATED="1530263622244" FOLDED="true" ID="ID_1055248724" MODIFIED="1530912173748" TEXT="ColumnVector&lt;T&gt;::greater">
<node CREATED="1530266659325" ID="ID_1513326619" LINK="#ID_327443578" MODIFIED="1530266673030" TEXT="similar to ColumnVector&lt;T&gt;::less"/>
</node>
</node>
</node>
</node>
<node CREATED="1530263551115" ID="ID_1675008943" LINK="ClickHouse/dbms/src/Columns/ColumnVector.cpp" MODIFIED="1530263580443" TEXT="ColumnVector.cpp"/>
</node>
</node>
<node CREATED="1529892160745" ID="ID_1322652713" LINK="ClickHouse/dbms/src/Columns/IColumn.cpp" MODIFIED="1529892185865" TEXT="IColumn.cpp"/>
</node>
</node>
</node>
<node CREATED="1530496403842" ID="ID_1064853690" LINK="ClickHouse/dbms/src/Common/CurrentMetrics.h" MODIFIED="1534159115241" TEXT="CurrentMetrics.h">
<node CREATED="1530014332949" ID="ID_58943658" MODIFIED="1534159115241" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1031178478" MODIFIED="1534159115225" TEXT="description">
<node CREATED="1530499408141" ID="ID_1971219504" MODIFIED="1530499641329">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      count number of simultaneously happening processes or current value of some metric.
    </p>
    <p>
      1. it defines a bunch of macros, Query, Merge, etc. with the value starting from 0 to 1, ...
    </p>
    <p>
      2. defines array &quot;values&quot; to 0s.
    </p>
    <p>
      3. defines a bunch of operations to change &quot;values&quot;
    </p>
    <p>
      4. define a class Increment.
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1140606582" MODIFIED="1530912173754" TEXT="members">
<node CREATED="1530496480953" FOLDED="true" ID="ID_1905942343" MODIFIED="1530912173753" TEXT="extern std::atomic&lt;Value&gt; values[]">
<icon BUILTIN="help"/>
<node CREATED="1530496537299" ID="ID_1174260438" MODIFIED="1530496542688" TEXT="where is it defined?"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1911023839" MODIFIED="1534159115241" TEXT="concepts">
<node CREATED="1530496735916" ID="ID_1784841544" LINK="https://blog.csdn.net/hgl868/article/details/7058906" MODIFIED="1534159115241" TEXT="__COUNTER__">
<node CREATED="1530496766485" ID="ID_816938639" LINK="https://stackoverflow.com/questions/6503586/what-does-in-a-define-mean" MODIFIED="1530496880049" TEXT="macro, see link. In the link, ## is used for token concatenation"/>
</node>
<node CREATED="1530499342070" ID="ID_1497835461" LINK="https://www.geeksforgeeks.org/and-operators-in-c/" MODIFIED="1530499377981" TEXT="# stringizing operator"/>
</node>
<node CREATED="1530014251553" FOLDED="true" ID="ID_880716808" MODIFIED="1530912173757" TEXT="functions">
<node CREATED="1530499659134" FOLDED="true" ID="ID_971945518" MODIFIED="1530912173755" TEXT="end">
<node CREATED="1530499661104" ID="ID_833954714" MODIFIED="1530499683780" TEXT="return a number that&apos;s one past the last defined macro."/>
</node>
<node CREATED="1530499684603" FOLDED="true" ID="ID_355057387" MODIFIED="1530912173756" TEXT="set">
<node CREATED="1530499692303" ID="ID_565643235" MODIFIED="1530499718124" TEXT="set value[Metric(index)] to some value"/>
</node>
<node CREATED="1530499723497" FOLDED="true" ID="ID_593889831" MODIFIED="1530912173756" TEXT="add / sub">
<node CREATED="1530499733630" ID="ID_516567592" MODIFIED="1530499740609" TEXT="change value[Metric(index)] by some value"/>
</node>
</node>
<node CREATED="1530014254828" FOLDED="true" ID="ID_107107312" MODIFIED="1530912173758" TEXT="classes">
<node CREATED="1530499741736" FOLDED="true" ID="ID_867771868" MODIFIED="1530912173758" TEXT="Increment">
<node CREATED="1530499749734" FOLDED="true" ID="ID_154659840" MODIFIED="1530912173757" TEXT="description">
<node CREATED="1530499759347" ID="ID_227335923" MODIFIED="1530499760830" TEXT="For lifetime of object, add amout for specified metric. Then subtract."/>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1530496411129" ID="ID_629598084" LINK="ClickHouse/dbms/src/Common/CurrentMetrics.cpp" MODIFIED="1530496431506" TEXT="CurrentMetrics.cpp"/>
<node CREATED="1529562234932" FOLDED="true" ID="ID_1627697573" LINK="ClickHouse/dbms/src/Common/Exception.h" MODIFIED="1533616736098" TEXT="Exception.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_1616439927" MODIFIED="1533616736097" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1657736816" MODIFIED="1530912173760" TEXT="description">
<node CREATED="1530065136871" ID="ID_1996845193" MODIFIED="1530081278953" TEXT="exception class inherits from Poco::Exception, typical usage is Exception(const std::string &amp; msg, int code = 0), which throws an exception and gives an error code"/>
</node>
<node CREATED="1530013560221" ID="ID_904966732" MODIFIED="1530013562255" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_171013287" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_1871112574" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" FOLDED="true" ID="ID_1216962781" MODIFIED="1530912173761" TEXT="classes">
<icon BUILTIN="pencil"/>
<node CREATED="1530081335744" FOLDED="true" ID="ID_66293472" MODIFIED="1530912173760" TEXT="Exception">
<node CREATED="1530081355921" ID="ID_1885709230" MODIFIED="1530081356764" TEXT="ErrnoException"/>
</node>
<node CREATED="1530081378667" ID="ID_268904543" MODIFIED="1530081380148" TEXT="ExecutionStatus"/>
</node>
</node>
</node>
<node CREATED="1529995072301" ID="ID_149997942" LINK="ClickHouse/dbms/src/Common/Exception.cpp" MODIFIED="1529995108886" TEXT="Exception.cpp"/>
<node CREATED="1530758558403" FOLDED="true" ID="ID_1338140204" LINK="ClickHouse/dbms/src/Common/getFQDNOrHostName.h" MODIFIED="1533616736099" TEXT="getFQDNOrHostName.h">
<node CREATED="1530014350060" FOLDED="true" ID="ID_69080595" MODIFIED="1533616736098" TEXT="properties">
<node CREATED="1530013182602" FOLDED="true" ID="ID_427775379" MODIFIED="1530912173763" TEXT="description">
<node CREATED="1530758679039" ID="ID_326915041" MODIFIED="1530758683867" TEXT="get host name"/>
</node>
<node CREATED="1530013202034" ID="ID_1390498993" MODIFIED="1530696720036" TEXT="members"/>
<node CREATED="1529917903274" ID="ID_6380358" MODIFIED="1530696720037" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_460173245" MODIFIED="1530912173764" TEXT="functions">
<node CREATED="1530758618894" FOLDED="true" ID="ID_1400214493" MODIFIED="1530912173764" TEXT="getFQDNOrHostName">
<node CREATED="1530758635638" ID="ID_469256131" MODIFIED="1530758640533" TEXT="direct calls to getFQDNOrHostNameImpl"/>
</node>
<node CREATED="1530758634362" FOLDED="true" ID="ID_168861751" MODIFIED="1530912173764" TEXT="getFQDNOrHostNameImpl">
<node CREATED="1530758641347" ID="ID_1739036632" MODIFIED="1530758675595" TEXT="return host name"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1528904062" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530758561335" ID="ID_1689889414" LINK="ClickHouse/dbms/src/Common/getFQDNOrHostName.cpp" MODIFIED="1530758592583" TEXT="getFQDNOrHostName.cpp"/>
<node CREATED="1530416097292" FOLDED="true" ID="ID_1448854174" LINK="ClickHouse/dbms/src/Common/MemoryTracker.h" MODIFIED="1533616736101" TEXT="MemoryTracker.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1352377370" MODIFIED="1533616736100" TEXT="properties">
<icon BUILTIN="help"/>
<icon BUILTIN="pencil"/>
<node CREATED="1530013557169" FOLDED="true" ID="ID_1698261025" MODIFIED="1530912173766" TEXT="description">
<node CREATED="1530501031848" ID="ID_1766872532" MODIFIED="1530501045470" TEXT="Tracks memory consumption. It throws an exception if amount of consumed memory become greater than certain limit. (The same memory tracker could be simultaneously used in different threads.)"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_574744865" MODIFIED="1530912173769" TEXT="members">
<node CREATED="1530501056214" FOLDED="true" ID="ID_1983299344" MODIFIED="1530912173767" TEXT="std::atomic&lt;Int64&gt;">
<node CREATED="1530501068189" ID="ID_1799742533" MODIFIED="1530501070742" TEXT="amount"/>
</node>
<node CREATED="1530501056214" FOLDED="true" ID="ID_600198461" MODIFIED="1530912173767" TEXT="std::atomic&lt;Int64&gt;">
<node CREATED="1530501071731" ID="ID_1990349890" MODIFIED="1530501076565" TEXT="peak"/>
</node>
<node CREATED="1530501056214" FOLDED="true" ID="ID_226450561" MODIFIED="1530912173767" TEXT="std::atomic&lt;Int64&gt;">
<node CREATED="1530501077974" ID="ID_1693354379" MODIFIED="1530501079155" TEXT="limit"/>
</node>
<node CREATED="1530501083811" FOLDED="true" ID="ID_446464257" MODIFIED="1530912173768" TEXT="double">
<node CREATED="1530501086404" ID="ID_303044519" MODIFIED="1530501094319" TEXT="fault_probability"/>
</node>
<node CREATED="1530501421018" FOLDED="true" ID="ID_1653134318" MODIFIED="1530912173768" TEXT="std::atomic&lt;MemoryTracker *&gt;">
<node CREATED="1530501422677" ID="ID_304829806" MODIFIED="1530501425075" TEXT="next"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_652227747" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_358028401" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_28382496" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530416098823" ID="ID_1382347143" LINK="ClickHouse/dbms/src/Common/MemoryTracker.cpp" MODIFIED="1530416139531" TEXT="MemoryTracker.cpp"/>
<node CREATED="1530533724686" ID="ID_229393190" LINK="ClickHouse/dbms/src/Common/NaNUtils.h" MODIFIED="1530533768481" TEXT="NaNUtils.h"/>
<node CREATED="1530067683653" FOLDED="true" ID="ID_1170555121" LINK="ClickHouse/dbms/src/Common/PODArray.h" MODIFIED="1533616736109" TEXT="PODArray.h">
<node CREATED="1530070074569" FOLDED="true" ID="ID_1053225195" MODIFIED="1533616736108" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1973045249" MODIFIED="1530912173770" TEXT="description">
<node CREATED="1530068410799" ID="ID_248691854" MODIFIED="1530068431278" TEXT="a more efficient STL vector like container"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_158769273" MODIFIED="1530912173772" TEXT="members">
<node CREATED="1530079007080" FOLDED="true" ID="ID_521523209" MODIFIED="1530912173771" TEXT="char *">
<node CREATED="1530079029408" ID="ID_1873251472" MODIFIED="1530079064780" TEXT="equivalent to &quot;start&quot; pointer in STL vector"/>
</node>
<node CREATED="1530079018217" FOLDED="true" ID="ID_1073244606" MODIFIED="1530912173771" TEXT="char *">
<node CREATED="1530079067862" ID="ID_218379545" MODIFIED="1530079073261" TEXT="equivalent to &quot;end&quot; pointer in STL vector"/>
</node>
<node CREATED="1530079019928" FOLDED="true" ID="ID_826413390" MODIFIED="1530912173772" TEXT="char *">
<node CREATED="1530079069378" ID="ID_1776106838" MODIFIED="1530079076063" TEXT="equivalent to &quot;capacity&quot; pointer in STL vector"/>
</node>
</node>
<node CREATED="1530013563312" FOLDED="true" ID="ID_1969951975" MODIFIED="1530912173773" TEXT="concepts">
<node CREATED="1530067716446" ID="ID_1432094528" LINK="https://stackoverflow.com/questions/18544849/how-to-use-reinterpret-cast-in-c/18545072" MODIFIED="1530067744169" TEXT="reinterpret_cast"/>
</node>
<node CREATED="1530014251553" ID="ID_1052526114" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1303244252" MODIFIED="1530067768559" TEXT="classes"/>
<node CREATED="1530079162072" FOLDED="true" ID="ID_923384031" MODIFIED="1530912173774" TEXT="template specialization">
<node CREATED="1530079171640" FOLDED="true" ID="ID_377495531" MODIFIED="1530912173773" TEXT="PaddedPODArray">
<node CREATED="1530079186696" ID="ID_64051803" MODIFIED="1530081027437" TEXT="set pad_right_ to 15">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530079182209" ID="ID_1696464422" MODIFIED="1530079183948" TEXT="PODArrayWithStackMemory "/>
</node>
</node>
</node>
<node CREATED="1530517258211" FOLDED="true" ID="ID_1572988102" LINK="ClickHouse/dbms/src/Common/ProfileEvents.h" MODIFIED="1533616736110" TEXT="ProfileEvents.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1569637982" MODIFIED="1533616736110" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_116844351" MODIFIED="1530912173775" TEXT="description">
<node CREATED="1530517285931" ID="ID_1245482295" MODIFIED="1530517399878">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Implements global counters for various events happening in the application, such as Query,FileOpen, ReadBufferFromFileDescriptorRead,etc. ( for high level profiling.)
    </p>
    <p>
      implementation detail: very similar to CurrentMetrics.h
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1530013560221" ID="ID_1530174130" MODIFIED="1530517282626" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_508189871" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_95850720" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_20907862" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530517270084" ID="ID_1939375204" LINK="ClickHouse/dbms/src/Common/ProfileEvents.cpp" MODIFIED="1530673047514" TEXT="ProfileEvents.cpp"/>
<node CREATED="1529995025837" ID="ID_795038278" LINK="ClickHouse/dbms/src/Common/RWLockFIFO.h" MODIFIED="1529995058313" TEXT="RWLockFIFO.h"/>
<node CREATED="1529995038637" ID="ID_1571190494" LINK="ClickHouse/dbms/src/Common/RWLockFIFO.cpp" MODIFIED="1529995066756" TEXT="RWLockFIFO.cpp"/>
<node CREATED="1529562319381" FOLDED="true" ID="ID_337679727" LINK="ClickHouse/dbms/src/Common/Stopwatch.h" MODIFIED="1533616736111" TEXT="Stopwatch.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_713295681" MODIFIED="1533616736111" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_982006020" MODIFIED="1530912173777" TEXT="description">
<node CREATED="1530065136871" ID="ID_422075324" MODIFIED="1530082083696" TEXT="stopwatch similar to std::chrono::system_lock">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530013560221" ID="ID_1622404446" MODIFIED="1530013562255" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_1762085376" MODIFIED="1530083398209" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_392855171" MODIFIED="1530083120941" TEXT="functions"/>
<node CREATED="1530014254828" FOLDED="true" ID="ID_1285200902" MODIFIED="1530912173777" TEXT="classes">
<node CREATED="1530081546704" ID="ID_1698474227" MODIFIED="1530081554429" TEXT="Stopwatch"/>
<node CREATED="1530081554982" ID="ID_15832669" MODIFIED="1530081556804" TEXT="AtomicStopwatch"/>
</node>
</node>
</node>
<node CREATED="1530156053128" FOLDED="true" ID="ID_1352597378" LINK="ClickHouse/dbms/src/Common/typeid_cast.h" MODIFIED="1533616736112" TEXT="typeid_cast.h">
<node CREATED="1530070033954" FOLDED="true" ID="ID_1980081995" MODIFIED="1533616736112" TEXT="properties">
<node CREATED="1530172632563" FOLDED="true" ID="ID_1221778330" MODIFIED="1530912173779" TEXT="description">
<node CREATED="1530173098135" ID="ID_557013345" MODIFIED="1530173127781" TEXT="somewhat similar to dynamic_cast in terms of behaviour with polymorphic objects"/>
</node>
<node CREATED="1530013563312" FOLDED="true" ID="ID_1347588232" MODIFIED="1530912173779" TEXT="concepts">
<node CREATED="1530173080414" ID="ID_958877755" LINK="https://en.cppreference.com/w/cpp/language/typeid" MODIFIED="1530173091675" TEXT="typeid"/>
<node CREATED="1529378172725" ID="ID_1174078667" LINK="http://en.cppreference.com/w/cpp/types/enable_if" MODIFIED="1529378185955" TEXT="enable_if_t"/>
<node CREATED="1530156524101" ID="ID_558606927" LINK="https://en.cppreference.com/w/cpp/types/is_reference" MODIFIED="1530156606098" TEXT="is_reference_v"/>
</node>
</node>
</node>
</node>
<node CREATED="1529377612872" FOLDED="true" ID="ID_1847615450" MODIFIED="1534161039597" TEXT="Core">
<node CREATED="1529562355949" FOLDED="true" ID="ID_755249646" LINK="ClickHouse/dbms/src/Core/Block.h" MODIFIED="1533616736115" TEXT="Block.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_1087921142" MODIFIED="1533616736115" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_451685442" MODIFIED="1530912173782" TEXT="description">
<node CREATED="1530242063734" ID="ID_804606801" MODIFIED="1530242103135" TEXT="stores a vector&lt;ColumnWithTypeAndName) and some metadata, to represent a block and support operations"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_315897069" MODIFIED="1533551799282" TEXT="members">
<node CREATED="1530176082686" FOLDED="true" ID="ID_1269851466" LINK="#ID_473245467" MODIFIED="1532512965451" TEXT="std::vector&lt;ColumnWithTypeAndName&gt; (Container)">
<node CREATED="1530176740764" ID="ID_1010381560" MODIFIED="1530176748078" TEXT="stores a vector of columns"/>
</node>
<node CREATED="1530176170991" FOLDED="true" ID="ID_896252618" MODIFIED="1530912173783" TEXT="std::map&lt;String, size_t&gt; (IndexByName)">
<node CREATED="1530176761541" ID="ID_865929898" MODIFIED="1530177061090" TEXT="a map that maps from column name to its index in the block"/>
</node>
<node CREATED="1530176736331" ID="ID_859431312" MODIFIED="1530176737224" TEXT="BlockInfo"/>
</node>
<node CREATED="1530013563312" ID="ID_827964910" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_440371640" MODIFIED="1530917811680" TEXT="functions">
<node CREATED="1530177188112" FOLDED="true" ID="ID_1105455476" MODIFIED="1530912173783" TEXT="ctor">
<node CREATED="1530177192312" ID="ID_534719050" LINK="#ID_1217976495" MODIFIED="1530177229653" TEXT="calls initializeIndexByName() to initialize IndexByName"/>
</node>
<node CREATED="1530253853644" FOLDED="true" ID="ID_891088414" MODIFIED="1530912173784" TEXT="operator bool() / operator !()">
<node CREATED="1530253863079" ID="ID_424757910" MODIFIED="1530254054012" TEXT="check if Container is not empty/ empty"/>
</node>
<node CREATED="1530177202318" ID="ID_1217976495" MODIFIED="1530177203800" TEXT="initializeIndexByName"/>
<node CREATED="1530177232887" FOLDED="true" ID="ID_48560940" MODIFIED="1530917755161" TEXT="insert">
<node CREATED="1530177632715" ID="ID_1454764883" MODIFIED="1530177850721" TEXT="range check, then modify IndexByName accordingly, then use emplace to insert a new column"/>
</node>
<node CREATED="1530177287211" FOLDED="true" ID="ID_624578994" MODIFIED="1530912173785" TEXT="insertUnique">
<node CREATED="1530177697035" ID="ID_795610607" MODIFIED="1530177705566" TEXT="insert if unique, otherwise do nothing"/>
</node>
<node CREATED="1530177288928" FOLDED="true" ID="ID_1332312286" MODIFIED="1530912173785" TEXT="erase">
<node CREATED="1530177861357" ID="ID_276029048" MODIFIED="1530177874476" TEXT="range check, then modify IndexByName accordingly, then use erase to erase a specific column"/>
</node>
<node CREATED="1530178112599" FOLDED="true" ID="ID_831072589" MODIFIED="1530912173786" TEXT="safeGetByPosition / getByName">
<node CREATED="1530178124265" ID="ID_814830655" MODIFIED="1530178147778" TEXT="error check, then return column at given index in the block"/>
</node>
<node CREATED="1530178289253" FOLDED="true" ID="ID_1206276703" MODIFIED="1530912173786" TEXT="has">
<node CREATED="1530178297004" ID="ID_261015886" MODIFIED="1530178319386" TEXT="whether a column with some name exist in the block"/>
</node>
<node CREATED="1530178320608" FOLDED="true" ID="ID_853847437" MODIFIED="1530912173787" TEXT="getPositionByName">
<node CREATED="1530178328088" ID="ID_239470948" MODIFIED="1530178353968" TEXT="error check, then return the position of column with some name"/>
</node>
<node CREATED="1530178355996" FOLDED="true" ID="ID_1394465422" MODIFIED="1530912173787" TEXT="checkNumberOfRows">
<node CREATED="1530178468252" ID="ID_1299233198" MODIFIED="1530178494116" TEXT="check number of rows in the block, throw exception if the row number of 2 columns do not match"/>
</node>
<node CREATED="1530178523773" FOLDED="true" ID="ID_542574832" MODIFIED="1530912173787" TEXT="rows">
<node CREATED="1530178541174" ID="ID_1185594131" MODIFIED="1530178558023" TEXT="return the row of the first non-null column"/>
</node>
<node CREATED="1530178744641" FOLDED="true" ID="ID_1350881431" MODIFIED="1530912173788" TEXT="bytes / allocatedBytes">
<node CREATED="1530180213215" ID="ID_425184535" MODIFIED="1530180277035" TEXT="total number of bytes taken/allocated by the columns"/>
</node>
<node CREATED="1530180253643" ID="ID_669380514" MODIFIED="1530180532231" TEXT="dumpNames / dumpStructure"/>
<node CREATED="1530238724178" FOLDED="true" ID="ID_1066395574" MODIFIED="1530912173788" TEXT="cloneEmpty \ cloneEmptyColumns">
<node CREATED="1530238747004" ID="ID_1157838636" MODIFIED="1530238778493" TEXT="return a block \ vector&lt;IColumn&gt; of empty columns"/>
</node>
<node CREATED="1530238781675" FOLDED="true" ID="ID_1921591356" MODIFIED="1530912173789" TEXT="getColumns \ mutateColumns">
<node CREATED="1530238798584" ID="ID_825441690" MODIFIED="1530238891458" TEXT="convert block to immutable\ mutable vector&lt;IColumn&gt;"/>
</node>
<node CREATED="1530241966533" FOLDED="true" ID="ID_1972316362" MODIFIED="1530912173789" TEXT="setColumns">
<node CREATED="1530241969400" ID="ID_797302148" MODIFIED="1530241990300" TEXT="change column in the block to given &amp;columns"/>
</node>
<node CREATED="1530241991642" FOLDED="true" ID="ID_39384572" MODIFIED="1530912173789" TEXT="cloneWithColumns">
<node CREATED="1530696470906" ID="ID_1701117115" MODIFIED="1530696526489" TEXT="clone rhs(MutableColumns type) with same the DataType and name for each column as current block"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_709415605" MODIFIED="1530079245976" TEXT="classes"/>
<node CREATED="1530177086313" FOLDED="true" ID="ID_1957926423" MODIFIED="1530912173791" TEXT="typedef">
<node CREATED="1530177089584" FOLDED="true" ID="ID_296097473" MODIFIED="1530912173790" TEXT="Blocks">
<node CREATED="1530177092330" ID="ID_114333690" MODIFIED="1530177101837" TEXT="std::vector&lt;Block&gt;"/>
</node>
<node CREATED="1530177102692" FOLDED="true" ID="ID_1681188382" MODIFIED="1530912173791" TEXT="BlocksList">
<node CREATED="1530177112387" ID="ID_1438525891" MODIFIED="1530177119024" TEXT="std::list&lt;Block&gt;"/>
</node>
</node>
</node>
</node>
<node CREATED="1529898805374" ID="ID_1598249396" LINK="ClickHouse/dbms/src/Core/Block.cpp" MODIFIED="1529898824028" TEXT="Block.cpp"/>
<node CREATED="1530176289554" FOLDED="true" ID="ID_1078356563" LINK="ClickHouse/dbms/src/Core/BlockInfo.h" MODIFIED="1533616736116" TEXT="BlockInfo.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_908671282" MODIFIED="1533616736116" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_961099673" MODIFIED="1530912173793" TEXT="description">
<node CREATED="1530242501910" ID="ID_1856381207" MODIFIED="1530242506784" TEXT="">
<icon BUILTIN="help"/>
<icon BUILTIN="pencil"/>
</node>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1770232169" MODIFIED="1530916930415" TEXT="members">
<node CREATED="1530176529341" FOLDED="true" ID="ID_1922189603" MODIFIED="1530912173793" TEXT="bool">
<node CREATED="1530176570397" ID="ID_935831344" MODIFIED="1530176610497" TEXT="is_overflows: ">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530176553791" FOLDED="true" ID="ID_126097638" MODIFIED="1530912173794" TEXT="Int32">
<node CREATED="1530176604068" ID="ID_723252243" MODIFIED="1530176610497" TEXT="bucket_num:">
<icon BUILTIN="help"/>
</node>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1895860138" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_571449958" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_748240429" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530176304777" ID="ID_750928098" LINK="ClickHouse/dbms/src/Core/BlockInfo.cpp" MODIFIED="1530176319099" TEXT="BlockInfo.cpp"/>
<node CREATED="1529898914109" FOLDED="true" ID="ID_473245467" LINK="ClickHouse/dbms/src/Core/ColumnWithTypeAndName.h" MODIFIED="1533616736117" TEXT="ColumnWithTypeAndName.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_1296326573" MODIFIED="1533616736117" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_36701140" MODIFIED="1533551799283" TEXT="description">
<node CREATED="1530175652994" ID="ID_1681295616" MODIFIED="1530175684022" TEXT="Stores an IColumn and its metadata : name and data type"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_662299045" MODIFIED="1533551799284" TEXT="members">
<node CREATED="1530175105766" FOLDED="true" ID="ID_1897313896" MODIFIED="1533551799283" TEXT="ColumnPtr">
<node CREATED="1530175184722" ID="ID_864180296" MODIFIED="1530175192992" TEXT="the actual column"/>
</node>
<node CREATED="1530175112312" FOLDED="true" ID="ID_1964581197" MODIFIED="1533551799283" TEXT="DataTypePtr">
<node CREATED="1530175194342" ID="ID_926637173" LINK="#ID_590430758" MODIFIED="1530175535587" TEXT="data type of the column ( difference between IColumn data type and IDataType, see link)"/>
</node>
<node CREATED="1530175118608" FOLDED="true" ID="ID_1429820848" MODIFIED="1533551799284" TEXT="String">
<node CREATED="1530175120116" ID="ID_504346317" MODIFIED="1530175164272" TEXT="name of the column (seems that name is not stored in IColumn, so IColumn only provides data structure but no metadata">
<icon BUILTIN="help"/>
</node>
</node>
</node>
<node CREATED="1530013563312" ID="ID_696699056" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1301194792" MODIFIED="1533551799284" TEXT="functions">
<node CREATED="1530182303372" FOLDED="true" ID="ID_1972130335" MODIFIED="1530912173798" TEXT="cloneEmpty">
<node CREATED="1530182493374" ID="ID_1216047435" MODIFIED="1530238495977" TEXT="if ColumnPtr is not null, clone a ColumnWithTypeAndName type with same name and type but empty column by calling ColumnPtr-&gt;cloneEmpty(). ColumnPtr is of type immutable_ptr&lt;IColumn&gt;, so it&apos;s calling IColumn.cloneEmpty()."/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1496626157" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1529898916647" ID="ID_13522810" LINK="ClickHouse/dbms/src/Core/ColumnWithTypeAndName.cpp" MODIFIED="1530675429850" TEXT="ColumnWithTypeAndName.cpp"/>
<node CREATED="1530175895005" FOLDED="true" ID="ID_1065833997" LINK="ClickHouse/dbms/src/Core/ColumnsWithTypeAndName.h" MODIFIED="1533616736118" TEXT="ColumnsWithTypeAndName.cpp">
<node CREATED="1530175934707" FOLDED="true" ID="ID_754248900" MODIFIED="1533616736117" TEXT="typedef">
<node CREATED="1530175939215" FOLDED="true" ID="ID_1615555477" MODIFIED="1530912173800" TEXT="ColumnsWithTypeAndName">
<node CREATED="1530175952129" ID="ID_1696527098" MODIFIED="1530175953245" TEXT="std::vector&lt;ColumnWithTypeAndName&gt;"/>
</node>
</node>
</node>
<node CREATED="1530085994397" ID="ID_1106906408" LINK="ClickHouse/dbms/src/Core/Defines.h" MODIFIED="1534140189898" TEXT="Defines.h">
<node CREATED="1530086040273" ID="ID_967684354" MODIFIED="1534140189898" TEXT="#define MAY_ALIAS __attribute__((__may_alias__))">
<node CREATED="1530086960888" ID="ID_1540653636" MODIFIED="1530099328541" TEXT="basically, may_alias allows change value at a memory address through a pointer of different type. Tried to test it on g++-5 and 7, seems that strict aliasing rule is not used. Maybe it&apos;s only for gcc 4.3 and before?">
<icon BUILTIN="help"/>
</node>
<node CREATED="1530086043593" ID="ID_870587989" LINK="https://www.ibm.com/support/knowledgecenter/en/SSXVZZ_16.1.0/com.ibm.xlcpp161.lelinux.doc/language_ref/type_attr_may_alias.html" MODIFIED="1530086946460" TEXT="article1"/>
<node CREATED="1530086948011" ID="ID_727712307" LINK="https://gcc.gnu.org/onlinedocs/gcc-4.0.4/gcc/Type-Attributes.html" MODIFIED="1530086957931" TEXT="article2"/>
</node>
<node CREATED="1530086086873" ID="ID_1117107246" MODIFIED="1530086086873" TEXT=""/>
</node>
<node CREATED="1529377618712" FOLDED="true" ID="ID_36782198" LINK="ClickHouse/dbms/src/Core/Field.h" MODIFIED="1533616736120" TEXT="Field.h">
<node CREATED="1530070050967" FOLDED="true" ID="ID_493027063" MODIFIED="1533616736119" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1536834550" MODIFIED="1533551799284" TEXT="description">
<node CREATED="1530084663311" ID="ID_425109612" MODIFIED="1530084682023" TEXT="Field represent a single row(entry) in a column"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1492338580" MODIFIED="1533551799284" TEXT="members">
<node CREATED="1530083865030" FOLDED="true" ID="ID_1539150179" MODIFIED="1530912173802" TEXT=" std::aligned_union_t&lt;DBMS_MIN_FIELD_SIZE - sizeof(Types::Which), Null, UInt64, UInt128, Int64, Float64, String, Array, Tuple&gt;">
<node CREATED="1530084574017" ID="ID_1349534177" MODIFIED="1530084778293" TEXT="somewhat similar to union, storing the actual (non-reference) data in the Field">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530082332912" FOLDED="true" ID="ID_470849403" MODIFIED="1530918013943" TEXT="Types::Which">
<node CREATED="1530084891178" ID="ID_412059485" MODIFIED="1530084912363" TEXT="stores the type of the field"/>
</node>
</node>
<node CREATED="1530013563312" FOLDED="true" ID="ID_40664654" MODIFIED="1530917828536" TEXT="concepts">
<node CREATED="1529377654660" ID="ID_1141678332" LINK="https://foonathan.net/blog/2016/10/19/strong-typedefs.html" MODIFIED="1529377700058" TEXT="STRONG_TYPEDEF: define strong type"/>
<node CREATED="1529378118722" FOLDED="true" ID="ID_351401718" LINK="http://en.cppreference.com/w/cpp/types/decay" MODIFIED="1530912173803" TEXT="decay_t">
<node CREATED="1530085311298" ID="ID_972199205" MODIFIED="1530085312929" TEXT="Applies lvalue-to-rvalue, array-to-pointer, and function-to-pointer implicit conversions to the type T, removes cv-qualifiers, and defines the resulting type as the member typedef type"/>
</node>
<node CREATED="1529378147607" ID="ID_1537183746" LINK="https://en.cppreference.com/w/cpp/types/is_same" MODIFIED="1529378169447" TEXT="is_same_v"/>
<node CREATED="1529378172725" ID="ID_518168736" LINK="http://en.cppreference.com/w/cpp/types/enable_if" MODIFIED="1529378185955" TEXT="enable_if_t"/>
<node CREATED="1530100482867" ID="ID_636728657" LINK="https://stackoverflow.com/questions/8463368/template-dot-template-construction-usage" MODIFIED="1530100508026" TEXT=".(dot) template construct"/>
</node>
<node CREATED="1529377646416" FOLDED="true" ID="ID_1439561360" MODIFIED="1533551799285" TEXT="functions">
<node CREATED="1530100975146" ID="ID_1176070077" MODIFIED="1530100988791" TEXT="ctor, dtor, etc."/>
<node CREATED="1530084916295" FOLDED="true" ID="ID_977588121" MODIFIED="1530912173804" TEXT="getType">
<node CREATED="1530084929912" ID="ID_430672162" MODIFIED="1530084951760" TEXT="&quot;return which;&quot; : return type"/>
</node>
<node CREATED="1530084955131" FOLDED="true" ID="ID_772960806" MODIFIED="1530912173805" TEXT="getTypeName">
<node CREATED="1530084964402" ID="ID_1637914123" MODIFIED="1530084975785" TEXT="return type in string format"/>
</node>
<node CREATED="1530085628084" FOLDED="true" ID="ID_1527377023" MODIFIED="1530912173805" TEXT="get&lt;T&gt;/ tryGet&lt;T&gt;/ safeGet&lt;T&gt;">
<node CREATED="1530085653328" ID="ID_454852320" MODIFIED="1530085784483" TEXT="return a (const) reference to the actual value stored in Field, without/with type consistent checking"/>
</node>
<node CREATED="1530085836130" ID="ID_793452666" MODIFIED="1530085841436" TEXT="relational operators"/>
<node CREATED="1530101093162" FOLDED="true" ID="ID_1069229049" MODIFIED="1530918112824" TEXT="createConcrete / create">
<node CREATED="1530101170312" ID="ID_847191136" MODIFIED="1530101237404" TEXT="placement new to create data stored in storage"/>
</node>
<node CREATED="1530101161395" FOLDED="true" ID="ID_362252287" MODIFIED="1530918112208" TEXT="assignConcrete / assign">
<node CREATED="1530101239968" ID="ID_187154846" MODIFIED="1530101260479" TEXT="assign from one field to another"/>
</node>
<node CREATED="1530100994101" FOLDED="true" ID="ID_211004169" MODIFIED="1530912173806" TEXT="destroy">
<node CREATED="1530100999703" ID="ID_1028586298" MODIFIED="1530101089438" TEXT="free resource for more complicated type such as string, array, etc."/>
</node>
</node>
<node CREATED="1530014254828" FOLDED="true" ID="ID_1047715363" MODIFIED="1533551799285" TEXT="classes">
<node CREATED="1530082339081" FOLDED="true" ID="ID_748811865" MODIFIED="1530912173808" TEXT="Types">
<node CREATED="1530082376345" FOLDED="true" ID="ID_1420081950" MODIFIED="1530912173807" TEXT="enum Which">
<node CREATED="1530082385128" ID="ID_1852349447" MODIFIED="1530082392191" TEXT="Null    = 0"/>
<node CREATED="1530082393135" ID="ID_75178984" MODIFIED="1530082399740" TEXT="UInt64  = 1"/>
<node CREATED="1530082406349" ID="ID_288863797" MODIFIED="1530082407114" TEXT="Int64   = 2"/>
<node CREATED="1530082407628" ID="ID_50076667" MODIFIED="1530082415054" TEXT="Float64 = 3"/>
<node CREATED="1530082415408" ID="ID_1179735686" MODIFIED="1530082423044" TEXT="UInt128 = 4"/>
<node CREATED="1530082424027" ID="ID_1284102866" MODIFIED="1530082431167" TEXT="String  = 16"/>
<node CREATED="1530082431656" ID="ID_869122006" MODIFIED="1530082438076" TEXT=" Array   = 17"/>
<node CREATED="1530082447541" ID="ID_1152807176" MODIFIED="1530082448716" TEXT="Tuple   = 18"/>
</node>
<node CREATED="1530082460982" ID="ID_1197968883" MODIFIED="1530082469699" TEXT="static const int MIN_NON_POD = 16"/>
<node CREATED="1530082489101" FOLDED="true" ID="ID_183466906" MODIFIED="1530912173808" TEXT="static const char * toString(Which which)">
<node CREATED="1530082493040" ID="ID_212543652" MODIFIED="1530082514020" TEXT="function that converts the enum class to c-string"/>
</node>
</node>
</node>
<node CREATED="1530597863584" FOLDED="true" ID="ID_1846253820" MODIFIED="1533551799285" TEXT="typedef">
<node CREATED="1530597866112" FOLDED="true" ID="ID_1771382363" MODIFIED="1530912173809" TEXT="Array">
<node CREATED="1530597867812" ID="ID_420486244" MODIFIED="1530597881024" TEXT="std::vector&lt;Field&gt;"/>
</node>
<node CREATED="1530597881743" FOLDED="true" ID="ID_466903158" MODIFIED="1530912173810" TEXT="TupleBackend">
<node CREATED="1530597885374" ID="ID_1860747738" MODIFIED="1530597886083" TEXT="std::vector&lt;Field&gt;"/>
</node>
</node>
</node>
</node>
<node CREATED="1530069346900" ID="ID_1731176039" LINK="ClickHouse/dbms/src/Core/Field.cpp" MODIFIED="1530069364257" TEXT="Field.cpp"/>
<node CREATED="1529562422308" FOLDED="true" ID="ID_1573554173" LINK="ClickHouse/dbms/src/Core/Names.h" MODIFIED="1533616736121" TEXT="Names.h">
<node CREATED="1530175934707" FOLDED="true" ID="ID_563822851" MODIFIED="1533616736120" TEXT="typedef">
<node CREATED="1530175939215" FOLDED="true" ID="ID_1935283282" MODIFIED="1530912173811" TEXT="Names">
<node CREATED="1530175952129" ID="ID_1273721448" MODIFIED="1530176008384" TEXT="std::vector&lt;std::string&gt;"/>
</node>
<node CREATED="1530175939215" FOLDED="true" ID="ID_397157006" MODIFIED="1530912173812" TEXT="NameSet">
<node CREATED="1530175952129" ID="ID_195643860" MODIFIED="1530176030944" TEXT="std::unordered_set&lt;std::string&gt;"/>
</node>
<node CREATED="1530175939215" FOLDED="true" ID="ID_1718946757" MODIFIED="1530912173812" TEXT="NameToNameMap">
<node CREATED="1530175952129" ID="ID_1437148027" MODIFIED="1530176048632" TEXT="std::unordered_map&lt;std::string, std::string&gt;"/>
</node>
</node>
</node>
<node CREATED="1529562426314" FOLDED="true" ID="ID_1901916028" LINK="ClickHouse/dbms/src/Core/NamesAndTypes.h" MODIFIED="1534140180873" TEXT="NamesAndTypes.h">
<node CREATED="1530174886150" FOLDED="true" ID="ID_133485924" MODIFIED="1534140180858" TEXT="NameAndTypePair">
<node CREATED="1530014296023" FOLDED="true" ID="ID_1446616331" MODIFIED="1534140180858" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_782355935" MODIFIED="1530912173813" TEXT="description">
<node CREATED="1530175001568" ID="ID_994488151" MODIFIED="1530242479606" TEXT="stores a pair of column name and its data type"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_666931070" MODIFIED="1530912173814" TEXT="members">
<node CREATED="1530174169505" FOLDED="true" ID="ID_1246753753" MODIFIED="1530912173814" TEXT="String">
<node CREATED="1530175007427" ID="ID_385481480" MODIFIED="1530175007427" TEXT=""/>
</node>
<node CREATED="1530174172301" ID="ID_1263709920" MODIFIED="1530174177957" TEXT="DataTypePtr"/>
</node>
<node CREATED="1530013563312" FOLDED="true" ID="ID_493109255" MODIFIED="1534140180858" TEXT="concepts">
<node CREATED="1530174717478" ID="ID_219736576" LINK="https://en.cppreference.com/w/cpp/utility/tuple/forward_as_tuple" MODIFIED="1530174754528" TEXT="forward_as_tuple">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530014251553" ID="ID_1433971134" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1650939741" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530174895316" FOLDED="true" ID="ID_1418305593" MODIFIED="1533616736122" TEXT="std::list&lt;NameAndTypePair&gt;">
<node CREATED="1530174909450" ID="ID_1974531897" MODIFIED="1530174918712" TEXT="NamesAndTypesList"/>
</node>
<node CREATED="1530174925586" FOLDED="true" ID="ID_909268322" MODIFIED="1533616736122" TEXT="NamesAndTypes">
<node CREATED="1530174932304" ID="ID_39412787" MODIFIED="1530174939584" TEXT="std::vector&lt;NameAndTypePair&gt;"/>
</node>
</node>
<node CREATED="1529898996960" ID="ID_1302776144" LINK="ClickHouse/dbms/src/Core/NamesAndTypes.cpp" MODIFIED="1529899020788" TEXT="NamesAndTypes.cpp"/>
<node CREATED="1529917675041" FOLDED="true" ID="ID_1339887266" LINK="ClickHouse/dbms/src/Core/QueryProcessingStage.h" MODIFIED="1533616736123" TEXT="QueryProcessingStage.h">
<node CREATED="1532705294217" FOLDED="true" ID="ID_1319497320" MODIFIED="1533616736123" TEXT="properties">
<node CREATED="1532705300889" FOLDED="true" ID="ID_960509604" MODIFIED="1533551799285" TEXT="description">
<node CREATED="1532705318824" ID="ID_1231767096" MODIFIED="1532705319138" TEXT="Up to what stage the SELECT query is executed or needs to be executed."/>
</node>
<node CREATED="1532705308828" FOLDED="true" ID="ID_963496501" MODIFIED="1533551799286" TEXT="members">
<node CREATED="1532705370509" FOLDED="true" ID="ID_1431682749" MODIFIED="1533551799285" TEXT="enum Enum">
<node CREATED="1532705376273" ID="ID_1826043078" MODIFIED="1532705377741" TEXT="FetchColumns = 0"/>
<node CREATED="1532705382073" ID="ID_546575493" MODIFIED="1532705383307" TEXT="WithMergeableState = 1"/>
<node CREATED="1532705386901" ID="ID_1277129353" MODIFIED="1532705388182" TEXT="Complete = 2"/>
</node>
</node>
</node>
</node>
<node CREATED="1530687933558" FOLDED="true" ID="ID_543849553" LINK="ClickHouse/dbms/src/Core/SortDescription.h" MODIFIED="1533616736124" TEXT="SortColumnDescription.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1925999012" MODIFIED="1533616736124" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1378221585" MODIFIED="1533551799286" TEXT="description">
<node CREATED="1530688425330" ID="ID_237583098" MODIFIED="1530688428750" TEXT="description of the sorting rule by one column."/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1698764060" MODIFIED="1533551799287" TEXT="members">
<node CREATED="1530688221687" FOLDED="true" ID="ID_1896476496" MODIFIED="1533551799286" TEXT="string">
<node CREATED="1530688224943" ID="ID_547542970" MODIFIED="1530688265102" TEXT="column_name : name of the column (in the block) to be sorted"/>
</node>
<node CREATED="1530688267293" FOLDED="true" ID="ID_1993763194" MODIFIED="1533551799286" TEXT="size_t">
<node CREATED="1530688270003" ID="ID_965525886" MODIFIED="1530688285280" TEXT="column_number : column number (used if no name is given)."/>
</node>
<node CREATED="1530688286718" FOLDED="true" ID="ID_722372444" MODIFIED="1533551799287" TEXT="int">
<node CREATED="1530688289997" ID="ID_1971910703" MODIFIED="1530688301297" TEXT="direction : 1 - ascending, -1 - descending."/>
</node>
<node CREATED="1530688302166" FOLDED="true" ID="ID_701318690" MODIFIED="1533551799287" TEXT="int">
<node CREATED="1530688309566" ID="ID_1315495642" MODIFIED="1530688330139" TEXT="nulls_direction : 1 - NULLs and NaNs are greater, -1 - less."/>
</node>
<node CREATED="1530688386567" FOLDED="true" ID="ID_1460448568" MODIFIED="1533551799287" TEXT="shared_ptr&lt;Collator&gt;">
<node CREATED="1530688387756" ID="ID_832817464" MODIFIED="1530688403054" TEXT="collator : ">
<icon BUILTIN="pencil"/>
<icon BUILTIN="help"/>
</node>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1385505136" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_858120628" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1008967028" MODIFIED="1530079245976" TEXT="classes"/>
<node CREATED="1530688439625" FOLDED="true" ID="ID_679022839" MODIFIED="1533551799287" TEXT="typedef">
<node CREATED="1530688443243" FOLDED="true" ID="ID_1825983621" MODIFIED="1533551799287" TEXT="SortDescription">
<node CREATED="1530688449470" MODIFIED="1530688449470" TEXT="std::vector&lt;SortColumnDescription&gt;"/>
</node>
</node>
</node>
</node>
<node CREATED="1530687945485" ID="ID_73343029" LINK="ClickHouse/dbms/src/Core/SortDescription.cpp" MODIFIED="1530687950310" TEXT="SortColumnDescription.cpp"/>
<node CREATED="1529985689849" FOLDED="true" ID="ID_1969262497" LINK="ClickHouse/dbms/src/Core/Types.h" MODIFIED="1533616736126" TEXT="Types.h">
<node CREATED="1530069623570" FOLDED="true" ID="ID_645931831" MODIFIED="1533616736125" TEXT="typedef">
<node CREATED="1530069668839" FOLDED="true" ID="ID_975236333" MODIFIED="1530912173821" TEXT="UInt8">
<node CREATED="1530069695638" ID="ID_1588762210" MODIFIED="1530069725837" TEXT="Poco::Uint8 = unsigned char"/>
</node>
<node CREATED="1530069678032" FOLDED="true" ID="ID_499830197" MODIFIED="1530912173822" TEXT="UInt16">
<node CREATED="1530069695638" ID="ID_426629748" MODIFIED="1530069747953" TEXT="Poco::Uint16 = unsigned short"/>
</node>
<node CREATED="1530069679080" FOLDED="true" ID="ID_20468621" MODIFIED="1530912173822" TEXT="UInt32">
<node CREATED="1530069695638" ID="ID_186581633" MODIFIED="1530069760065" TEXT="Poco::Uint32 = unsigned int"/>
</node>
<node CREATED="1530069683012" FOLDED="true" ID="ID_464651233" MODIFIED="1530912173822" TEXT="UInt64">
<node CREATED="1530069695638" ID="ID_976305975" MODIFIED="1530069763225" TEXT="Poco::Uint64 = unsigned long"/>
</node>
<node CREATED="1530069668839" FOLDED="true" ID="ID_820508649" MODIFIED="1530912173823" TEXT="Int8">
<node CREATED="1530069695638" ID="ID_1421283544" MODIFIED="1530069849043" TEXT="Poco::Int8 = signed char"/>
</node>
<node CREATED="1530069678032" FOLDED="true" ID="ID_1746970100" MODIFIED="1530912173823" TEXT="Int16">
<node CREATED="1530069695638" ID="ID_178780817" MODIFIED="1530069856796" TEXT="Poco::Int16 = signed short"/>
</node>
<node CREATED="1530069679080" FOLDED="true" ID="ID_1926620621" MODIFIED="1530912173823" TEXT="Int32">
<node CREATED="1530069695638" ID="ID_1040941833" MODIFIED="1530069866179" TEXT="Poco::Int32 = signed int"/>
</node>
<node CREATED="1530069683012" FOLDED="true" ID="ID_1456226302" MODIFIED="1530912173824" TEXT="Int64">
<node CREATED="1530069695638" ID="ID_887065679" MODIFIED="1530069867547" TEXT="Poco::Int64 = signed long"/>
</node>
<node CREATED="1530069876142" FOLDED="true" ID="ID_1678120889" MODIFIED="1530912173824" TEXT="Float32">
<node CREATED="1530069889183" ID="ID_86523074" MODIFIED="1530069891793" TEXT="float"/>
</node>
<node CREATED="1530069878299" FOLDED="true" ID="ID_1400251265" MODIFIED="1530912173824" TEXT="Float64">
<node CREATED="1530069889183" ID="ID_1725909170" MODIFIED="1530069897329" TEXT="double"/>
</node>
<node CREATED="1530069880722" FOLDED="true" ID="ID_821332845" MODIFIED="1530912173827" TEXT="String">
<node CREATED="1530069889183" ID="ID_501936" MODIFIED="1530069902555" TEXT="string"/>
</node>
</node>
</node>
</node>
<node CREATED="1529481433195" FOLDED="true" ID="ID_1157513871" MODIFIED="1533616736135" TEXT="DataStreams">
<node CREATED="1529562519781" FOLDED="true" ID="ID_641437755" LINK="ClickHouse/dbms/src/DataStreams/BlockStreamProfileInfo.h" MODIFIED="1533616736127" TEXT="BlockStreamProfileInfo.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1560098406" MODIFIED="1533616736127" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1045182666" MODIFIED="1533551799288" TEXT="description">
<node CREATED="1530672259727" ID="ID_737895994" MODIFIED="1532502173891" TEXT="provides auxiliary info on IProfileBlockInputStream that it&apos;s associated with, such as # of rows, cols, etc">
<icon BUILTIN="help"/>
<icon BUILTIN="pencil"/>
</node>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_512223181" MODIFIED="1533551799290" TEXT="members">
<node CREATED="1530013696581" FOLDED="true" ID="ID_783473733" MODIFIED="1533551799288" TEXT="IProfilingBlockInputStream *">
<node CREATED="1530672447522" ID="ID_842047029" MODIFIED="1530672503540" TEXT=" parent : nfo about stream object this profile info refers to"/>
</node>
<node CREATED="1530672430877" FOLDED="true" ID="ID_1917414176" MODIFIED="1533551799289" TEXT="bool">
<node CREATED="1530672495414" ID="ID_423446234" MODIFIED="1530672515527" TEXT="started : if the profile has been started"/>
</node>
<node CREATED="1530672433375" FOLDED="true" ID="ID_687052869" MODIFIED="1533551799289" TEXT="Stopwatch">
<node CREATED="1530672516406" ID="ID_561120401" MODIFIED="1530672534534" TEXT="total_stopwatch"/>
</node>
<node CREATED="1530672419975" FOLDED="true" ID="ID_471257497" MODIFIED="1533551799289" TEXT="size_t">
<node CREATED="1530672539460" ID="ID_284702721" MODIFIED="1530672540394" TEXT="rows"/>
</node>
<node CREATED="1530672423342" FOLDED="true" ID="ID_1314682771" MODIFIED="1533551799289" TEXT="size_t">
<node CREATED="1530672541161" ID="ID_233316357" MODIFIED="1530672543887" TEXT="blocks"/>
</node>
<node CREATED="1530672424444" FOLDED="true" ID="ID_304408864" MODIFIED="1533551799289" TEXT="size_t">
<node CREATED="1530672545468" ID="ID_1137805302" MODIFIED="1530672548053" TEXT="bytes"/>
</node>
<node CREATED="1530685817675" FOLDED="true" ID="ID_814679125" MODIFIED="1533551799289" TEXT="mutable bool">
<node CREATED="1530685841556" ID="ID_1169933861" MODIFIED="1530685845175" TEXT="applied_limit"/>
</node>
<node CREATED="1530685817675" FOLDED="true" ID="ID_1728166476" MODIFIED="1533551799289" TEXT="mutable size_t">
<node CREATED="1530685846337" ID="ID_594713792" MODIFIED="1530685855879" TEXT="rows_before_limit"/>
</node>
<node CREATED="1530685817675" FOLDED="true" ID="ID_354731807" MODIFIED="1533551799290" TEXT="mutable bool">
<node CREATED="1530685857050" ID="ID_1395569182" MODIFIED="1530685864875" TEXT="calculated_rows_before_limit"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1827127204" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_322242753" MODIFIED="1533551799290" TEXT="functions">
<node CREATED="1530672574723" FOLDED="true" ID="ID_768096729" MODIFIED="1533551799290" TEXT="collectInfosForStreamsWithName">
<node CREATED="1530672583030" ID="ID_1494686603" MODIFIED="1530672583569" TEXT="Run DFS to collect BlockStreamProfileInfo for the nearest sources in all sub-levels in the tree named `name`."/>
</node>
<node CREATED="1530672589190" FOLDED="true" ID="ID_474853632" MODIFIED="1533551799290" TEXT="read / write">
<node CREATED="1530685787052" ID="ID_1069316564" MODIFIED="1530685957851" TEXT="read / write rows, blocks, etc from/to buffer"/>
</node>
<node CREATED="1530685958928" FOLDED="true" ID="ID_269057825" MODIFIED="1533551799290" TEXT="setFrom">
<node CREATED="1530686015503" ID="ID_1888885556" MODIFIED="1530686032409" TEXT="set current profileinfo to rhs"/>
</node>
<node CREATED="1530686033294" ID="ID_506441579" MODIFIED="1530686033294" TEXT=""/>
</node>
<node CREATED="1530014254828" ID="ID_644613900" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1529891126915" ID="ID_1826176400" LINK="ClickHouse/dbms/src/DataStreams/BlockStreamProfileInfo.cpp" MODIFIED="1530675303791" TEXT="BlockStreamProfileInfo.cpp"/>
<node CREATED="1529562563983" FOLDED="true" ID="ID_1325910993" LINK="ClickHouse/dbms/src/DataStreams/IBlockInputStream.h" MODIFIED="1533616736129" TEXT="IBlockInputStream.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1936840133" MODIFIED="1533616736128" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1297975573" MODIFIED="1533551799291" TEXT="description">
<node CREATED="1530674708741" ID="ID_1391997488" MODIFIED="1530675168560" TEXT="provides interface for other input stream to inherit from"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1564371031" MODIFIED="1533551799291" TEXT="members">
<node CREATED="1530673292160" FOLDED="true" ID="ID_256098225" MODIFIED="1531250191904" TEXT="std::vector&lt;std::shared_ptr&lt;IBlockInputStream&gt;&gt; ( BlockInputStreams)">
<node CREATED="1530673331125" ID="ID_175202039" MODIFIED="1530673336533" TEXT="children"/>
</node>
<node CREATED="1530673339267" FOLDED="true" ID="ID_841044341" MODIFIED="1530912173836" TEXT="std::shared_mutex">
<node CREATED="1530673345977" ID="ID_786986144" MODIFIED="1530673348527" TEXT="children_mutex"/>
</node>
<node CREATED="1530673364441" FOLDED="true" ID="ID_91831829" MODIFIED="1530912173837" TEXT="TableStructureReadLocks">
<node CREATED="1530673376729" ID="ID_940812581" MODIFIED="1530673378628" TEXT="table_locks"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_882523487" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_860815977" MODIFIED="1533551799291" TEXT="functions">
<node CREATED="1530673580887" FOLDED="true" ID="ID_768067292" MODIFIED="1530912173838" TEXT="getHeader">
<node CREATED="1530890030383" ID="ID_1901917670" LINK="#ID_147541043" MODIFIED="1530890141799">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      return header block,&#160;(it is also called &quot;sample block&quot;). Header block contains column names, data types, columns of size 0. Constant columns must have corresponding values. (It is guaranteed that method &quot;read&quot; returns blocks of exactly that structure.). See link to OneBlockInputStream.h for its getHeader() for implementation.
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1530673588574" ID="ID_1092898435" MODIFIED="1530673589035" TEXT="read"/>
<node CREATED="1530673593865" ID="ID_893731334" MODIFIED="1530673594254" TEXT="readPrefix"/>
<node CREATED="1530673594799" ID="ID_610296474" MODIFIED="1530673598921" TEXT="readSuffix"/>
<node CREATED="1530673671623" FOLDED="true" ID="ID_1206622080" MODIFIED="1530912173839" TEXT="getName">
<node CREATED="1530673990714" ID="ID_1026902812" MODIFIED="1530674021463" TEXT="return a string storing the name of the stream (e.g. limit block returns &quot;limit&quot;)"/>
</node>
<node CREATED="1530673675444" FOLDED="true" ID="ID_316933853" MODIFIED="1530912173839" TEXT="isSortedOutput">
<node CREATED="1530673684097" ID="ID_467063378" MODIFIED="1530673684484" TEXT="If this stream generates data in order by some keys, return true."/>
</node>
<node CREATED="1530673678795" FOLDED="true" ID="ID_1316167434" MODIFIED="1530912173840" TEXT="SortDescription">
<node CREATED="1530673685729" ID="ID_1748084162" MODIFIED="1530673692569" TEXT=" In case of isSortedOutput, return corresponding SortDescription"/>
</node>
<node CREATED="1530673693239" FOLDED="true" ID="ID_395233698" MODIFIED="1530912173840" TEXT="dumpTree">
<node CREATED="1530674665514" ID="ID_1017680164" MODIFIED="1530674683064" TEXT="more verbose version of getTreeID with hierarchical indentation"/>
</node>
<node CREATED="1530673724836" FOLDED="true" ID="ID_1137703463" MODIFIED="1530912173840" TEXT="checkDepth">
<node CREATED="1530674103136" ID="ID_428857103" MODIFIED="1530674110141" TEXT="direct calls to checkDepthImpl"/>
</node>
<node CREATED="1530674059670" FOLDED="true" ID="ID_1024860280" MODIFIED="1530912173841" TEXT="getTreeID">
<node CREATED="1530674067301" ID="ID_770124537" MODIFIED="1530674087776" TEXT="return a string storing the hierarchy of the tree structure at current stream level"/>
</node>
<node CREATED="1530674111481" FOLDED="true" ID="ID_532738265" MODIFIED="1530912173841" TEXT="checkDepthImpl">
<node CREATED="1530674263551" ID="ID_1805916842" MODIFIED="1530674291466" TEXT="find the depth of the tree subject to limit under max_depth"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_96080507" MODIFIED="1530079245976" TEXT="classes"/>
<node CREATED="1530260715175" FOLDED="true" ID="ID_114123975" MODIFIED="1530912173842" TEXT="typedef">
<node CREATED="1530260719807" FOLDED="true" ID="ID_1173413653" MODIFIED="1530912173842" TEXT="ProgressCallback">
<node CREATED="1530260726968" ID="ID_285759833" MODIFIED="1530260728167" TEXT="std::function&lt;void(const Progress &amp; progress)&gt;"/>
</node>
</node>
</node>
<node CREATED="1529890966350" FOLDED="true" ID="ID_879238537" LINK="ClickHouse/dbms/src/DataStreams/IProfilingBlockInputStream.h" MODIFIED="1533616736129" TEXT="IProfilingBlockInputStream.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1487700025" MODIFIED="1532502188302" TEXT="properties">
<node CREATED="1530013557169" ID="ID_127308781" MODIFIED="1530675323559" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_624894287" MODIFIED="1533551799293" TEXT="members">
<node CREATED="1530675381033" FOLDED="true" ID="ID_735470407" LINK="#ID_641437755" MODIFIED="1533551799291" TEXT="BlockStreamProfileInfo">
<node CREATED="1530675582336" ID="ID_1781908379" MODIFIED="1530675586789" TEXT="info : "/>
</node>
<node CREATED="1530675459030" FOLDED="true" ID="ID_1013982101" MODIFIED="1533551799291" TEXT="std::atomic&lt;bool&gt;">
<node CREATED="1530675590425" ID="ID_1996148240" MODIFIED="1530675592235" TEXT="is_cancelled : "/>
</node>
<node CREATED="1530675465330" FOLDED="true" ID="ID_1820683230" MODIFIED="1533551799291" TEXT="std::atomic&lt;bool&gt;">
<node CREATED="1530675593017" ID="ID_293036073" MODIFIED="1530675598943" TEXT="is_killed : "/>
</node>
<node CREATED="1530675465486" FOLDED="true" ID="ID_1385520294" MODIFIED="1533551799292" TEXT="std::function&lt;void(const Progress &amp; progress)&gt; ( ProgressCallback)">
<node CREATED="1530675602829" ID="ID_902866200" MODIFIED="1530675604343" TEXT="progress_callback : "/>
</node>
<node CREATED="1530675526626" FOLDED="true" ID="ID_1511891392" MODIFIED="1533551799292" TEXT="ProcessListElement *">
<node CREATED="1530675607461" ID="ID_1895104137" MODIFIED="1530675609303" TEXT="process_list_elem : "/>
</node>
<node CREATED="1530675540422" FOLDED="true" ID="ID_1586369657" MODIFIED="1533551799292" TEXT="Block">
<node CREATED="1530675613203" ID="ID_409767236" MODIFIED="1530675615496" TEXT="totals : "/>
</node>
<node CREATED="1530675542571" FOLDED="true" ID="ID_963420631" MODIFIED="1533551799292" TEXT="Block">
<node CREATED="1530675620503" ID="ID_970797041" MODIFIED="1530675625726" TEXT="extremes : "/>
</node>
<node CREATED="1530675552949" FOLDED="true" ID="ID_656718917" MODIFIED="1533551799292" TEXT="bool">
<node CREATED="1530675644770" ID="ID_1071707858" MODIFIED="1530675646994" TEXT="enabled_extremes : "/>
</node>
<node CREATED="1530675554234" FOLDED="true" ID="ID_704165871" MODIFIED="1533551799292" TEXT="bool">
<node CREATED="1530675652307" ID="ID_716669781" MODIFIED="1530675654341" TEXT="limit_exceeded_need_break : "/>
</node>
<node CREATED="1530675560467" FOLDED="true" ID="ID_1456417887" MODIFIED="1533551799292" TEXT="LocalLimits">
<node CREATED="1530675662163" ID="ID_1337547382" MODIFIED="1530675664414" TEXT="limits : "/>
</node>
<node CREATED="1530675567302" FOLDED="true" ID="ID_1936677250" MODIFIED="1533551799292" TEXT="QuotaForIntervals *">
<node CREATED="1530675670541" ID="ID_1453635093" MODIFIED="1530675672776" TEXT="quota : "/>
</node>
<node CREATED="1530675571604" FOLDED="true" ID="ID_1632871343" MODIFIED="1533551799293" TEXT="double">
<node CREATED="1530675673973" ID="ID_1901001795" MODIFIED="1530675675941" TEXT="prev_elapsed : "/>
</node>
<node CREATED="1530675573399" FOLDED="true" ID="ID_132103455" MODIFIED="1533551799293" TEXT="size_t">
<node CREATED="1530675680728" ID="ID_964657767" MODIFIED="1530687201725" TEXT="total_rows_approx : The approximate total number of rows to read. For progress bar."/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1046496815" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1377164874" MODIFIED="1533551799295" TEXT="functions">
<node CREATED="1530691611932" ID="ID_1568007317" MODIFIED="1530691629806" TEXT="virtual read() override final"/>
<node CREATED="1530691630581" FOLDED="true" ID="ID_552137861" MODIFIED="1533551799293" TEXT="virtual readPrefix() override">
<node CREATED="1530697614255" ID="ID_196759398" MODIFIED="1530697663616" TEXT="run readPrefixImpl with DFS in prefix order"/>
</node>
<node CREATED="1530691652016" FOLDED="true" ID="ID_1259444486" MODIFIED="1533551799293" TEXT="virtual readSuffix() override">
<node CREATED="1530697632367" ID="ID_1362566989" MODIFIED="1530697669096" TEXT="run readSuffixImpl with DFS in postfix order"/>
</node>
<node CREATED="1530691659959" ID="ID_396102382" MODIFIED="1530691696942" TEXT="getProfileInfo"/>
<node CREATED="1530691712214" FOLDED="true" ID="ID_1695658771" MODIFIED="1533551799293" TEXT="getTotals">
<node CREATED="1530693126273" ID="ID_1698928060" MODIFIED="1530693169328" TEXT="run DFS to find the first child stream(including self) with a non-empty totals"/>
</node>
<node CREATED="1530691716192" FOLDED="true" ID="ID_108384944" MODIFIED="1533551799293" TEXT="getExtremes">
<node CREATED="1530693238575" ID="ID_195835390" MODIFIED="1530693243448" TEXT="run DFS to find the first child stream(including self) with a non-empty extremes "/>
</node>
<node CREATED="1530691727470" FOLDED="true" ID="ID_1341473250" MODIFIED="1533551799294" TEXT="setProgressCallback">
<node CREATED="1530692427999" ID="ID_1377184576" MODIFIED="1530692469774" TEXT="set progress_callback or current stream and all child streams to rhs"/>
</node>
<node CREATED="1530691737375" FOLDED="true" ID="ID_562047657" MODIFIED="1533551799294" TEXT="progress">
<node CREATED="1530755557499" ID="ID_1432098259" MODIFIED="1530755564428" TEXT="direct calls to progressImpl"/>
</node>
<node CREATED="1530691742705" FOLDED="true" ID="ID_1761389033" MODIFIED="1533551799294" TEXT="progressImpl">
<node CREATED="1530777284304" ID="ID_830846347" MODIFIED="1530777527952">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      1.&#160;check if rows and bytes from process_list_elem.progress_in has exceed limits.
    </p>
    <p>
      2. check if execution speed is less than min_execution_speed or estimated execution time will exceed max_execution_time.
    </p>
    <p>
      either case, it will throw
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1530691747234" FOLDED="true" ID="ID_1065083932" MODIFIED="1533551799294" TEXT="setProcessListElement">
<node CREATED="1530692602112" ID="ID_832286820" MODIFIED="1530692615124" TEXT="set process_list_elem or current stream and all child streams to rhs"/>
</node>
<node CREATED="1530691779029" ID="ID_1051659766" MODIFIED="1530691779331" TEXT="addTotalRowsApprox"/>
<node CREATED="1530691785840" FOLDED="true" ID="ID_1992151837" MODIFIED="1533551799294" TEXT="cancel">
<node CREATED="1530693801695" ID="ID_1386309523" MODIFIED="1530694030949">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      1. set is_killed to true
    </p>
    <p>
      2. if is_cancalled is not true, set it to true, and&#160;repeat step 1, 2 for all child streams. Otherwise, do nothing
    </p>
    <p>
      (running DFS)
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1530691792179" FOLDED="true" ID="ID_1384301493" MODIFIED="1533551799294" TEXT="isCancelled">
<node CREATED="1530692349327" ID="ID_92166896" MODIFIED="1530692354460" TEXT="return is_cancalled"/>
</node>
<node CREATED="1530691795401" FOLDED="true" ID="ID_563938458" MODIFIED="1533551799294" TEXT="isCancelledOrThrowIfKilled">
<node CREATED="1530692362726" ID="ID_1116225454" MODIFIED="1530692409497" TEXT="if not cancalled, return false. if is_killed, throw. Otherwise, return true"/>
</node>
<node CREATED="1530691821864" ID="ID_957415838" MODIFIED="1530691822189" TEXT="setLimits"/>
<node CREATED="1530691826245" ID="ID_673074958" MODIFIED="1530691826818" TEXT="getLimits"/>
<node CREATED="1530691837887" FOLDED="true" ID="ID_221917365" MODIFIED="1533551799294" TEXT="setQuota">
<node CREATED="1530775186707" ID="ID_376002927" MODIFIED="1530775198788" TEXT="update quota and check"/>
</node>
<node CREATED="1530691846095" ID="ID_1152376113" MODIFIED="1530691846342" TEXT="enableExtremes"/>
<node CREATED="1530691869023" ID="ID_726500435" MODIFIED="1530691869349" TEXT="readImpl"/>
<node CREATED="1530691872926" ID="ID_1182780613" MODIFIED="1530691873371" TEXT="readPrefixImpl"/>
<node CREATED="1530691876588" ID="ID_1894596712" MODIFIED="1530691876849" TEXT="readSuffixImpl"/>
<node CREATED="1530691880922" FOLDED="true" ID="ID_1700762889" MODIFIED="1533551799295" TEXT="updateExtremes">
<node CREATED="1530697261627" ID="ID_1506509887" MODIFIED="1530697327136" TEXT="fill in extremes if it&apos;s empty, otherwise update extremes with value in rhs(Block type)"/>
</node>
<node CREATED="1531319684053" FOLDED="true" ID="ID_930871171" MODIFIED="1533551799295" TEXT="handleOverflowMode">
<node CREATED="1531319685835" ID="ID_1198710835" MODIFIED="1531319742908" TEXT="takes in an overflow mode, an error message and an error code, throw or return according to the mode value"/>
</node>
<node CREATED="1530691914715" FOLDED="true" ID="ID_173506873" MODIFIED="1533551799295" TEXT="checkTimeLimit">
<node CREATED="1530694071172" ID="ID_1695436930" MODIFIED="1530694595025">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      1. above it defines non-member function handleOverflowMode, which throw or abort depends on mode
    </p>
    <p>
      2. check if time_elapsed from info.total_stopwatch has exceeded max_execution_time, if so, throw.
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1530691915881" ID="ID_1032009661" MODIFIED="1530691922988" TEXT="checkQuota"/>
</node>
<node CREATED="1530014254828" FOLDED="true" ID="ID_1737029232" MODIFIED="1533551799295" TEXT="classes">
<node CREATED="1530685178511" FOLDED="true" ID="ID_546507958" MODIFIED="1533551799295" TEXT="enum LimitsMode">
<node CREATED="1530685180227" ID="ID_1047723854" MODIFIED="1530685186358" TEXT="LIMITS_CURRENT"/>
<node CREATED="1530685187428" ID="ID_1151006848" MODIFIED="1530685187826" TEXT="LIMITS_CURRENT"/>
</node>
<node CREATED="1530691815262" ID="ID_1263049163" MODIFIED="1530691816099" TEXT="LocalLimits"/>
</node>
</node>
<node CREATED="1530905257870" FOLDED="true" ID="ID_263443042" LINK="ClickHouse/dbms/src/DataStreams/BlocksListBlockInputStream.h" MODIFIED="1533551799296" TEXT="BlocksListBlockInputStream.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1732135006" MODIFIED="1531250148201" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1400385964" MODIFIED="1533551799295" TEXT="description">
<node CREATED="1530905356091" ID="ID_869077013" MODIFIED="1530905710624" TEXT="A stream of blocks from which you can read block one by one until it has reached the end of the blocks(similar to OneBLockInputStream, it should be the leaf node in the inputStream tree?)">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1506566743" MODIFIED="1533551799296" TEXT="members">
<node CREATED="1530905715873" FOLDED="true" ID="ID_289925401" MODIFIED="1533551799295" TEXT="std::list&lt;Block&gt;(BlocksList)">
<node CREATED="1530905728191" ID="ID_1818720958" MODIFIED="1530905931290" TEXT="list : stores the actual data blocks to be read from this stream"/>
</node>
<node CREATED="1530905721165" FOLDED="true" ID="ID_1452093734" MODIFIED="1533551799296" TEXT="BlocksList::iterator">
<node CREATED="1530905781778" ID="ID_1431627081" MODIFIED="1530905934732" TEXT="it : current position in the list from which the next block will be read from, it&apos;s initialized with begin() of the list"/>
</node>
<node CREATED="1530905725482" FOLDED="true" ID="ID_58080607" MODIFIED="1533551799296" TEXT="const BlocksList::iterator">
<node CREATED="1530905808593" ID="ID_1777066386" MODIFIED="1530905937180" TEXT="end : end() of the list"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1626838884" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1261667727" MODIFIED="1533551799296" TEXT="functions">
<node CREATED="1530905816901" ID="ID_941091445" MODIFIED="1530905819910" TEXT="ctor"/>
<node CREATED="1530905820649" FOLDED="true" ID="ID_1267210716" MODIFIED="1533551799296" TEXT="getName()">
<node CREATED="1530905826743" ID="ID_629540681" MODIFIED="1530905835283" TEXT="return &quot;BlocksList&quot;"/>
</node>
<node CREATED="1530905841444" FOLDED="true" ID="ID_467023413" MODIFIED="1533551799296" TEXT="readImpl">
<node CREATED="1530905868241" ID="ID_1669351625" MODIFIED="1530905974083" TEXT="if it == end, return an empty block. Otherwise, return the block pointed by it, and increment it"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_658751397" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530777827338" FOLDED="true" ID="ID_1950545844" LINK="ClickHouse/dbms/src/DataStreams/MaterializingBlockInputStream.h" MODIFIED="1533551799298" TEXT="MaterializingBlockInputStream.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_751647499" MODIFIED="1531250131356" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1800890556" MODIFIED="1533551799297" TEXT="description">
<node CREATED="1531249851155" ID="ID_1293942014" MODIFIED="1531249876472" TEXT="materialize a const block"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1822102701" MODIFIED="1533551799297" TEXT="members">
<node CREATED="1531249847140" ID="ID_1067180236" MODIFIED="1531249850396" TEXT="no members"/>
</node>
<node CREATED="1530013563312" ID="ID_1415092335" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_554026635" MODIFIED="1533551799297" TEXT="functions">
<node CREATED="1530778803627" FOLDED="true" ID="ID_1813804674" MODIFIED="1533551799297" TEXT="ctor">
<node CREATED="1530778805404" ID="ID_1132152571" MODIFIED="1530778849514" TEXT="takes a BlockInputStreamPtr as input, push_back to children"/>
</node>
<node CREATED="1530778851452" FOLDED="true" ID="ID_1092934630" MODIFIED="1533551799297" TEXT="getName">
<node CREATED="1530778873918" ID="ID_713195521" MODIFIED="1530778877968" TEXT="return &quot;Materializing&quot;"/>
</node>
<node CREATED="1530778878871" FOLDED="true" ID="ID_1219126702" MODIFIED="1533551799297" TEXT="getHeader">
<node CREATED="1530778942693" ID="ID_499108845" MODIFIED="1530778960797" TEXT="materializeBlock on children.back()-&gt;getHeader()"/>
</node>
<node CREATED="1530778931703" FOLDED="true" ID="ID_114288996" MODIFIED="1533551799297" TEXT="readImpl">
<node CREATED="1530778942693" ID="ID_712270234" MODIFIED="1530778970491" TEXT="materializeBlock on children.back()-&gt;read()"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_225958033" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530777831889" ID="ID_781334659" LINK="ClickHouse/dbms/src/DataStreams/BlockStreamProfileInfo.cpp" MODIFIED="1530777850802" TEXT="MaterializingBlockInputStream.cpp"/>
<node CREATED="1530889880642" FOLDED="true" ID="ID_147541043" LINK="ClickHouse/dbms/src/DataStreams/OneBlockInputStream.h" MODIFIED="1533551799299" TEXT="OneBlockInputStream.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_848783086" MODIFIED="1532501857873" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1839983898" MODIFIED="1533551799298" TEXT="description">
<node CREATED="1530905356091" ID="ID_486939371" MODIFIED="1530905538727" TEXT="A input stream that stores only one block, and it could only be read once(should be the leaf node in the inputStream tree?)">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_606962734" MODIFIED="1533551799298" TEXT="members">
<node CREATED="1530905285207" FOLDED="true" ID="ID_899931708" MODIFIED="1533551799298" TEXT="Block">
<node CREATED="1530905302180" ID="ID_590979111" MODIFIED="1530905355229" TEXT="block : stores the actual data block to be read from this stream"/>
</node>
<node CREATED="1530905287620" FOLDED="true" ID="ID_523109879" MODIFIED="1533551799298" TEXT="bool">
<node CREATED="1530905292690" ID="ID_72767393" MODIFIED="1530905297287" TEXT="has_been_read = false : "/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_827820448" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_693152234" MODIFIED="1533551799299" TEXT="functions">
<node CREATED="1530905455128" ID="ID_597468547" MODIFIED="1530905456393" TEXT="ctor"/>
<node CREATED="1530905456921" FOLDED="true" ID="ID_749637333" MODIFIED="1533551799298" TEXT="getName">
<node CREATED="1530905458200" ID="ID_1745257854" MODIFIED="1530905464545" TEXT="return &quot;One&quot;"/>
</node>
<node CREATED="1530905470702" FOLDED="true" ID="ID_568485040" MODIFIED="1533551799299" TEXT="getHeader()">
<node CREATED="1531249602163" ID="ID_1333727841" MODIFIED="1531249632129" TEXT="create a header block based on &quot;block&quot; member"/>
</node>
<node CREATED="1530905481137" FOLDED="true" ID="ID_402359998" MODIFIED="1533551799299" TEXT="readImpl">
<node CREATED="1530905482656" ID="ID_588049221" MODIFIED="1530905516633" TEXT="if has_been_read is true, return an empty block. Otherwise, return block and set has_been_read to true"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1258943455" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530778702698" FOLDED="true" ID="ID_915823633" LINK="ClickHouse/dbms/src/DataStreams/PartialSortingBlockInputStream.h" MODIFIED="1533551799300" TEXT="PartialSortingBlockInputStream.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1470343610" MODIFIED="1532501855473" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1979143862" MODIFIED="1533551799299" TEXT="description">
<node CREATED="1531249233615" ID="ID_702634653" MODIFIED="1531249349211" TEXT="it assumes that there is only one child in children, and this stream does partial sorting which sort only &quot;limit&quot; number of element in each column in a block">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1313359708" MODIFIED="1533551799300" TEXT="members">
<node CREATED="1531248605892" FOLDED="true" ID="ID_784954179" LINK="#ID_1825983621" MODIFIED="1533551799299" TEXT="SortDescription">
<node CREATED="1531248611941" ID="ID_1460398989" MODIFIED="1531248617715" TEXT="description : "/>
</node>
<node CREATED="1531248608909" FOLDED="true" ID="ID_652035233" MODIFIED="1533551799300" TEXT="size_t">
<node CREATED="1531248705636" ID="ID_1418242090" MODIFIED="1531248707633" TEXT="limit : "/>
</node>
</node>
<node CREATED="1530013563312" FOLDED="true" ID="ID_1312299513" MODIFIED="1533551799300" TEXT="concepts">
<node CREATED="1531248734582" FOLDED="true" ID="ID_1488324857" MODIFIED="1533551799300" TEXT="ctor">
<node CREATED="1531249224034" ID="ID_1376992294" MODIFIED="1531249230046" TEXT="push_back input into children"/>
</node>
<node CREATED="1531248742096" FOLDED="true" ID="ID_1580317250" MODIFIED="1533551799300" TEXT="getName">
<node CREATED="1531248755852" ID="ID_1901216351" MODIFIED="1531248763856" TEXT="return &quot;ParitalSorting&quot;"/>
</node>
<node CREATED="1531248745046" FOLDED="true" ID="ID_246025501" MODIFIED="1533551799300" TEXT="getHeader">
<node CREATED="1531248875025" ID="ID_555790920" MODIFIED="1531248882284" TEXT="return header block of first child"/>
</node>
<node CREATED="1531248754284" FOLDED="true" ID="ID_875476567" MODIFIED="1533551799300" TEXT="readImpl">
<node CREATED="1531249118898" ID="ID_1481494309" LINK="#ID_1293316999" MODIFIED="1531249209524" TEXT="call read on the last child to retrieve a block, then call SortBlock to sort this block"/>
</node>
</node>
<node CREATED="1530014251553" ID="ID_1561283462" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1457017147" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530778704692" ID="ID_463090535" LINK="ClickHouse/dbms/src/DataStreams/PartialSortingBlockInputStream.cpp" MODIFIED="1530778722922" TEXT="PartialSortingBlockInputStream.cpp"/>
<node CREATED="1530785315734" FOLDED="true" ID="ID_1253625548" LINK="ClickHouse/dbms/src/DataStreams/UnionBlockInputStream.h" MODIFIED="1533551799305" TEXT="UnionBlockInputStream.h">
<node CREATED="1530785322213" FOLDED="true" ID="ID_61701117" MODIFIED="1531248426764" TEXT="OutputData&lt;StreamUnionMode::Basic&gt;">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1914788693" MODIFIED="1530912173868" TEXT="properties">
<node CREATED="1530013557169" ID="ID_1145245189" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1090686978" MODIFIED="1530912173868" TEXT="members">
<node CREATED="1530855885816" FOLDED="true" ID="ID_135826361" MODIFIED="1530912173867" TEXT="Block">
<node CREATED="1530855952742" ID="ID_1199641576" MODIFIED="1530855954092" TEXT="block"/>
</node>
<node CREATED="1530855893628" FOLDED="true" ID="ID_1588209754" MODIFIED="1530912173867" TEXT="std::exception_ptr">
<node CREATED="1530855944593" ID="ID_418729743" MODIFIED="1530855945891" TEXT="exception"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1527213732" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_1265002739" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_383029676" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530785335563" FOLDED="true" ID="ID_1838959128" MODIFIED="1530912173871" TEXT="OutputData&lt;StreamUnionMode::ExtraInfo&gt;">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1832828050" MODIFIED="1530857318976" TEXT="properties">
<node CREATED="1530013557169" ID="ID_793975396" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1940930890" MODIFIED="1530912173871" TEXT="members">
<node CREATED="1530855885816" FOLDED="true" ID="ID_399045450" MODIFIED="1530912173869" TEXT="Block">
<node CREATED="1530855934451" ID="ID_1779850519" MODIFIED="1530855935169" TEXT="block"/>
</node>
<node CREATED="1530855911292" FOLDED="true" ID="ID_848507263" MODIFIED="1530912173870" TEXT="BlockExtraInfo">
<node CREATED="1530855938275" ID="ID_183246649" MODIFIED="1530855938869" TEXT="extra_info"/>
</node>
<node CREATED="1530855893628" FOLDED="true" ID="ID_372574624" MODIFIED="1530912173870" TEXT="std::exception_ptr">
<node CREATED="1530855944593" ID="ID_70141177" MODIFIED="1530855945891" TEXT="exception"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_324067341" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_319748337" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1638967756" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530857085438" FOLDED="true" ID="ID_591297670" MODIFIED="1533551799305" TEXT="UnionBlockInputStream&lt;mode&gt;">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1091153197" MODIFIED="1531248422730" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1624271735" MODIFIED="1533551799301" TEXT="description">
<node CREATED="1531248412501" ID="ID_1079406389" MODIFIED="1531248420300" TEXT="Merges several sources into one. Blocks from different sources are interleaved with each other in an arbitrary way."/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_883088112" MODIFIED="1533551799302" TEXT="members">
<node CREATED="1530857418549" FOLDED="true" ID="ID_1361565270" MODIFIED="1533551799301" TEXT="OutputQueue">
<node CREATED="1530857428872" ID="ID_536942524" MODIFIED="1530907110872" TEXT="output_queue : The queue of the finished blocks ( that has been processed by ParallelInputsProcessor). (Also, you can put an exception instead of a block. When data is run out, an empty block is inserted into the queue.)"/>
</node>
<node CREATED="1530857446225" FOLDED="true" ID="ID_1701328477" MODIFIED="1533551799301" TEXT="Handler">
<node CREATED="1530857447104" ID="ID_1075356563" MODIFIED="1530857448346" TEXT="handler"/>
</node>
<node CREATED="1530857455554" FOLDED="true" ID="ID_359284936" LINK="#ID_857109511" MODIFIED="1533551799301" TEXT="ParallelInputsProcessor&lt;Handler, mode&gt;">
<node CREATED="1530857456881" ID="ID_1174970773" MODIFIED="1530857460282" TEXT="processor"/>
</node>
<node CREATED="1530857468257" FOLDED="true" ID="ID_350483105" MODIFIED="1533551799301" TEXT="ExceptionCallback">
<node CREATED="1530857472195" ID="ID_728219686" MODIFIED="1530857472610" TEXT="exception_callback"/>
</node>
<node CREATED="1530857473305" FOLDED="true" ID="ID_630634071" MODIFIED="1533551799301" TEXT="Payload">
<node CREATED="1530857481269" ID="ID_1760384179" MODIFIED="1530857481667" TEXT="received_payload"/>
</node>
<node CREATED="1530889221086" FOLDED="true" ID="ID_470847316" MODIFIED="1533551799302" TEXT="bool">
<node CREATED="1530889226826" ID="ID_1633199535" MODIFIED="1530889227145" TEXT="started"/>
</node>
<node CREATED="1530889222259" FOLDED="true" ID="ID_1194014316" MODIFIED="1533551799302" TEXT="bool">
<node CREATED="1530889227879" ID="ID_473558342" MODIFIED="1530889233507" TEXT="all_read"/>
</node>
<node CREATED="1530889234147" FOLDED="true" ID="ID_1813501831" MODIFIED="1533551799302" TEXT="Logger * ">
<node CREATED="1530889243231" ID="ID_964943769" MODIFIED="1530889244609" TEXT="log"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_769187317" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1986518936" MODIFIED="1533551799303" TEXT="functions">
<node CREATED="1530889326308" FOLDED="true" ID="ID_948417675" MODIFIED="1533551799302" TEXT="ctor">
<node CREATED="1530889708172" ID="ID_1128962249" MODIFIED="1530889757003" TEXT="put BlockInputStreams into children, then check all children are of the same structure (same header block?)"/>
</node>
<node CREATED="1530889335064" ID="ID_1813572705" MODIFIED="1530889336279" TEXT="dtor"/>
<node CREATED="1530889333253" FOLDED="true" ID="ID_187255141" MODIFIED="1533551799302" TEXT="getName">
<node CREATED="1530889646240" ID="ID_1858834826" MODIFIED="1530889650689" TEXT="return &quot;Union&quot;"/>
</node>
<node CREATED="1530889340925" FOLDED="true" ID="ID_928999911" MODIFIED="1533551799302" TEXT="cancel">
<node CREATED="1531122394304" ID="ID_109762040" LINK="#ID_629602790" MODIFIED="1531122471636" TEXT="set is_killed to given value, and calls processor&apos;s cancel"/>
</node>
<node CREATED="1530889345159" FOLDED="true" ID="ID_1367656911" MODIFIED="1533551799302" TEXT="getBlockExtraInfo">
<node CREATED="1530889346652" ID="ID_1239932596" MODIFIED="1530889356359" TEXT="direct calls to doGetBlockExtraInfo"/>
</node>
<node CREATED="1530889357143" FOLDED="true" ID="ID_1182145157" MODIFIED="1533551799303" TEXT="doGetBlockExtraInfo">
<node CREATED="1531248181517" ID="ID_116609599" MODIFIED="1531248206292" TEXT="return received_payload.extra_info"/>
</node>
<node CREATED="1530890237710" FOLDED="true" ID="ID_614123782" MODIFIED="1533551799303" TEXT="getHeader">
<node CREATED="1530890238948" ID="ID_1467193295" MODIFIED="1530890246939" TEXT="return header block of its first children"/>
</node>
<node CREATED="1530889361484" FOLDED="true" ID="ID_246038351" MODIFIED="1533551799303" TEXT="finalize">
<node CREATED="1531125148943" ID="ID_1430868764" MODIFIED="1531126046345" TEXT="finalize() is called when either all_read is true, or is_called is true. It&apos;s implementation detail goes as following:&#xa;1. check if started is true, if not, return.&#xa;2. if all_read is false, read all elements in output_queue, append all exceptions together, and then set all_read to true.&#xa;3. call processor.wait(), which wait all threads to join.&#xa;4. throw the appended exceptions.&#xa;"/>
</node>
<node CREATED="1530889366988" FOLDED="true" ID="ID_893150900" MODIFIED="1533551799303" TEXT="readPrefix">
<node CREATED="1531234950618" MODIFIED="1531234950618" TEXT="Do nothing, to make the preparation for the query execution in parallel, in ParallelInputsProcessor."/>
</node>
<node CREATED="1530889370668" FOLDED="true" ID="ID_1154392239" MODIFIED="1533551799303" TEXT="readImpl">
<node CREATED="1531236622094" ID="ID_228371980" MODIFIED="1531247906949" TEXT="Implementation details go as following:&#xa;1. if all_read is true, return current received_payload.block&#xa;2. if started is false, set it to true, then call processor.process()&#xa;3. then, it reads a block from output_queue into received_payload, if that block is i) an exception block, call exception_callback(), then rethrow. ii). an empty block, set all_read to true, and return the empty block iii). an normal block, then just return the block"/>
</node>
<node CREATED="1530889375227" FOLDED="true" ID="ID_671572880" MODIFIED="1533551799303" TEXT="readSuffix">
<node CREATED="1531247962675" ID="ID_740643671" MODIFIED="1531248071955">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      1. throw exception if neither all_read is true or is_cancalled is true
    </p>
    <p>
      2. call finalize()
    </p>
    <p>
      3. call readSuffix on all children
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1530014254828" FOLDED="true" ID="ID_1589923281" MODIFIED="1533551799305" TEXT="classes">
<node CREATED="1530889388667" FOLDED="true" ID="ID_1983307235" MODIFIED="1533551799304" TEXT="Handler">
<node CREATED="1530014332949" FOLDED="true" ID="ID_555374579" MODIFIED="1533551799304" TEXT="properties">
<node CREATED="1530013557169" ID="ID_296222668" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1802183458" MODIFIED="1533551799304" TEXT="members">
<node CREATED="1530889565315" FOLDED="true" ID="ID_500753010" MODIFIED="1533551799303" TEXT="Self &amp;">
<node CREATED="1530889568034" ID="ID_822920802" MODIFIED="1530889569054" TEXT="parent"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1711837899" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_60190264" MODIFIED="1533551799304" TEXT="functions">
<node CREATED="1530889582347" FOLDED="true" ID="ID_1952985732" MODIFIED="1533551799304" TEXT="onBlock">
<node CREATED="1530891065823" ID="ID_694515550" MODIFIED="1530891254600" TEXT="push a given block OutputData&lt;mode&gt; onto output_queue"/>
</node>
<node CREATED="1530889587857" FOLDED="true" ID="ID_705739038" MODIFIED="1533551799304" TEXT="onFinish">
<node CREATED="1530891065823" ID="ID_254161915" MODIFIED="1530891257276" TEXT="push a empty block OutputData&lt;mode&gt; onto output_queue"/>
</node>
<node CREATED="1530889590939" FOLDED="true" ID="ID_1277651765" MODIFIED="1533551799304" TEXT="onFinishThread">
<node CREATED="1530891112979" ID="ID_691579342" MODIFIED="1530891209430" TEXT="do nothing">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530889594380" FOLDED="true" ID="ID_897252890" MODIFIED="1533551799304" TEXT="onException">
<node CREATED="1530891219983" ID="ID_205995348" MODIFIED="1530891268625" TEXT="push a exception OutputData&lt;mode&gt; onto output_queue"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1772712154" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
</node>
<node CREATED="1530857087083" FOLDED="true" ID="ID_416402170" MODIFIED="1533551799305" TEXT="typedef">
<node CREATED="1530889430202" FOLDED="true" ID="ID_754983197" MODIFIED="1533551799305" TEXT="Self">
<node CREATED="1530889432479" ID="ID_1138023870" MODIFIED="1530889433101" TEXT="UnionBlockInputStream&lt;mode&gt;"/>
</node>
<node CREATED="1530857090466" FOLDED="true" ID="ID_713260824" MODIFIED="1533551799305" TEXT="Payload">
<node CREATED="1530857119998" ID="ID_1094601247" MODIFIED="1530857120812" TEXT="OutputData&lt;mode&gt;"/>
</node>
<node CREATED="1530857127095" FOLDED="true" ID="ID_1362846854" MODIFIED="1533551799305" TEXT="OutputQueue">
<node CREATED="1530857137863" ID="ID_1213800467" LINK="#ID_1126954633" MODIFIED="1530857308737" TEXT="ConcurrentBoundedQueue&lt;Payload&gt;"/>
</node>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1529890990043" ID="ID_214087255" LINK="ClickHouse/dbms/src/DataStreams/IProfilingBlockInputStream.cpp" MODIFIED="1529891841475" TEXT="IProfilingBlockInputStream.cpp"/>
</node>
<node CREATED="1529890882797" ID="ID_755434164" LINK="ClickHouse/dbms/src/DataStreams/IBlockInputStream.cpp" MODIFIED="1529891690084" TEXT="IBlockInputStream.cpp"/>
<node CREATED="1529562570019" FOLDED="true" ID="ID_580736226" LINK="ClickHouse/dbms/src/DataStreams/IBlockOutputStream.h" MODIFIED="1533616736132" TEXT="IBlockOutputStream.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_958466092" MODIFIED="1533616736130" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1766239736" MODIFIED="1533551799306" TEXT="description">
<node CREATED="1530242700316" ID="ID_901403977" MODIFIED="1530242704765" TEXT="Interface of stream for writing data (into table, filesystem, network, terminal, etc.)"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1282266155" MODIFIED="1533551799307" TEXT="members">
<node CREATED="1530013696581" FOLDED="true" ID="ID_623692591" MODIFIED="1533551799306" TEXT="TableStructureReadLocks">
<node CREATED="1530251075327" ID="ID_1231317593" MODIFIED="1530251079977" TEXT="table_locks : ">
<icon BUILTIN="pencil"/>
</node>
</node>
</node>
<node CREATED="1530013563312" ID="ID_28854107" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_983004225" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1428222454" MODIFIED="1530079245976" TEXT="classes"/>
</node>
<node CREATED="1529891623929" FOLDED="true" ID="ID_1162359784" LINK="ClickHouse/dbms/src/DataStreams/AddingDefaultBlockOutputStream.h" MODIFIED="1533616736130" TEXT="AddingDefaultBlockOutputStream.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1883558682" MODIFIED="1533551799308" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_730276979" MODIFIED="1533551799307" TEXT="description">
<node CREATED="1532502860264" ID="ID_872293150" MODIFIED="1532502860868" TEXT="Adds missing columns to the block with default values."/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_749359481" MODIFIED="1533551799308" TEXT="members">
<node CREATED="1530603207854" FOLDED="true" ID="ID_642591783" MODIFIED="1533551799307" TEXT="BlockOutputStreamPtr">
<node CREATED="1530603323440" ID="ID_216374128" MODIFIED="1530603327067" TEXT="output : "/>
</node>
<node CREATED="1530603211639" FOLDED="true" ID="ID_1480252134" MODIFIED="1533551799307" TEXT="Block">
<node CREATED="1530603328127" ID="ID_1349570418" MODIFIED="1530603331489" TEXT="header : "/>
</node>
<node CREATED="1530603220021" FOLDED="true" ID="ID_1192750189" MODIFIED="1533551799307" TEXT="NamesAndTypesList">
<node CREATED="1530603334004" ID="ID_1088138257" MODIFIED="1530603363980" TEXT="required_columns : "/>
</node>
<node CREATED="1530603226990" FOLDED="true" ID="ID_1455207732" MODIFIED="1533551799307" TEXT="ColumnDefaults">
<node CREATED="1530603346711" ID="ID_1778578437" MODIFIED="1530603362394" TEXT="column_defaults : "/>
</node>
<node CREATED="1530603230231" FOLDED="true" ID="ID_794948631" MODIFIED="1533551799308" TEXT="Context">
<node CREATED="1530603353596" ID="ID_381137592" MODIFIED="1530603360555" TEXT="context : "/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_52113450" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_536327489" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1960669825" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1529891628171" ID="ID_801600549" LINK="ClickHouse/dbms/src/DataStreams/AddingDefaultBlockOutputStream.cpp" MODIFIED="1529891760165" TEXT="AddingDefaultBlockOutputStream.cpp"/>
<node CREATED="1530259681670" FOLDED="true" ID="ID_215881237" LINK="ClickHouse/dbms/src/DataStreams/MaterializingBlockOutputStream.h" MODIFIED="1533616736131" TEXT="MaterializingBlockOutputStream.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1935016595" MODIFIED="1531250304303" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1538306605" MODIFIED="1533551799308" TEXT="description">
<node CREATED="1530259739113" ID="ID_35156351" MODIFIED="1530259916948" TEXT="ColumnConst gets materialize after passing through this stream"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1149272630" MODIFIED="1533551799309" TEXT="members">
<node CREATED="1530259864092" FOLDED="true" ID="ID_1867454914" MODIFIED="1533551799309" TEXT="BlockOutputStreamPtr">
<node CREATED="1530259871195" ID="ID_1099381773" MODIFIED="1530259909617" TEXT="output : next layer of stream in the pipepline">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530259865514" FOLDED="true" ID="ID_1011971280" MODIFIED="1533551799309" TEXT="Block">
<node CREATED="1530259874498" ID="ID_544093564" MODIFIED="1530259891641" TEXT="header">
<icon BUILTIN="help"/>
<icon BUILTIN="pencil"/>
</node>
</node>
</node>
<node CREATED="1530013563312" ID="ID_802709025" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_963252042" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1487934983" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530601878531" FOLDED="true" ID="ID_758361992" LINK="ClickHouse/dbms/src/DataStreams/NativeBlockOutputStream.h" MODIFIED="1533616736131" TEXT="NativeBlockOutputStream.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_137336797" MODIFIED="1532502388329" TEXT="properties">
<node CREATED="1530013557169" ID="ID_1292001100" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" ID="ID_1881438785" MODIFIED="1530013562255" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_1518446107" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_1727054926" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1126086853" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530601880315" ID="ID_1939521065" LINK="ClickHouse/dbms/src/DataStreams/NativeBlockOutputStream.cpp" MODIFIED="1530601916163" TEXT="NativeBlockOutputStream.cpp"/>
</node>
<node CREATED="1530254092445" FOLDED="true" ID="ID_1410770718" LINK="ClickHouse/dbms/src/DataStreams/materializeBlock.h" MODIFIED="1533616736132" TEXT="materializeBlock.h">
<node CREATED="1530257919614" ID="ID_738288252" LINK="#ID_1501228867" MODIFIED="1530257961272" TEXT="materialize a block by materializing each column in the block, by calling convertToFullColumnIfConst()"/>
</node>
<node CREATED="1530254101160" ID="ID_1005160013" LINK="ClickHouse/dbms/src/DataStreams/materializeBlock.cpp" MODIFIED="1530256314918" TEXT="materializeBlock.cpp"/>
<node CREATED="1530892049611" FOLDED="true" ID="ID_857109511" LINK="ClickHouse/dbms/src/DataStreams/ParallelInputsProcessor.h" MODIFIED="1533616736133" TEXT="ParallelInputsProcessor.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1593800331" MODIFIED="1533616736133" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1652052368" MODIFIED="1533551799310" TEXT="description">
<node CREATED="1530909349092" ID="ID_1623955776" MODIFIED="1531121640235" TEXT="Allows to process multiple block input streams (sources) in parallel, using specified number of threads. Reads (pulls) blocks from any available source and passes it to specified handler, which put all blocks that has been processed in a FIFO queue in the case of UnionBlockInputStream handler"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1450307001" MODIFIED="1533551799311" TEXT="members">
<node CREATED="1530892081784" FOLDED="true" ID="ID_366707748" MODIFIED="1533551799310" TEXT="BlockInputStreams">
<node CREATED="1530892117584" ID="ID_1021608662" MODIFIED="1530892121484" TEXT="inputs"/>
</node>
<node CREATED="1530892083271" FOLDED="true" ID="ID_1813058320" MODIFIED="1533551799310" TEXT="BlockInputStreamPtr">
<node CREATED="1530892126382" ID="ID_67644136" MODIFIED="1530892126756" TEXT="additional_input_at_end"/>
</node>
<node CREATED="1530892085788" FOLDED="true" ID="ID_1518965381" MODIFIED="1533551799310" TEXT="unsigned">
<node CREATED="1530892131206" ID="ID_1567720682" MODIFIED="1530892131549" TEXT="max_threads"/>
</node>
<node CREATED="1530892098553" FOLDED="true" ID="ID_1554900618" MODIFIED="1533551799310" TEXT="Handler &amp;">
<node CREATED="1530892132619" ID="ID_294124054" MODIFIED="1530892139204" TEXT="handler"/>
</node>
<node CREATED="1530892115587" FOLDED="true" ID="ID_1266986534" MODIFIED="1533551799310" TEXT="std::vector&lt;std::thread&gt;">
<node CREATED="1530892140830" ID="ID_1909059636" MODIFIED="1530892144192" TEXT="threads"/>
</node>
<node CREATED="1530898485764" FOLDED="true" ID="ID_386764080" MODIFIED="1533551799311" TEXT="std::queue&lt;InputData&gt;(AvailableInputs)">
<node CREATED="1530898497515" ID="ID_1583866285" MODIFIED="1530898497810" TEXT="available_inputs"/>
</node>
<node CREATED="1530898498768" FOLDED="true" ID="ID_913418277" MODIFIED="1533551799311" TEXT="std::queue&lt;InputData&gt;(UnpreparedInputs)">
<node CREATED="1530898593490" ID="ID_1818591841" MODIFIED="1530898593865" TEXT="unprepared_inputs"/>
</node>
<node CREATED="1530898602418" FOLDED="true" ID="ID_1058952050" MODIFIED="1533551799311" TEXT=" std::mutex">
<node CREATED="1530898608939" ID="ID_50224807" MODIFIED="1530898609601" TEXT="available_inputs_mutex"/>
</node>
<node CREATED="1530898603704" FOLDED="true" ID="ID_354867432" MODIFIED="1533551799311" TEXT=" std::mutex">
<node CREATED="1530898593490" ID="ID_974084613" MODIFIED="1530898615497" TEXT="unprepared_inputs_mutex"/>
</node>
<node CREATED="1530898624198" FOLDED="true" ID="ID_706751357" MODIFIED="1533551799311" TEXT="std::atomic&lt;size_t&gt;">
<node CREATED="1530898737356" ID="ID_1456647858" MODIFIED="1530898737952" TEXT="active_threads"/>
</node>
<node CREATED="1530898662398" FOLDED="true" ID="ID_189027179" MODIFIED="1533551799311" TEXT="std::atomic&lt;bool&gt;">
<node CREATED="1530898684368" ID="ID_598577990" MODIFIED="1530898684966" TEXT="finish"/>
</node>
<node CREATED="1530898665052" FOLDED="true" ID="ID_1103264974" MODIFIED="1533551799311" TEXT="std::atomic&lt;bool&gt;">
<node CREATED="1530898690709" ID="ID_1885505251" MODIFIED="1530898730340" TEXT="joined_threads"/>
</node>
<node CREATED="1530898634701" FOLDED="true" ID="ID_1236349357" MODIFIED="1533551799311" TEXT="Logger *">
<node CREATED="1530898743295" ID="ID_1169029217" MODIFIED="1530898743758" TEXT="log "/>
</node>
</node>
<node CREATED="1530013563312" FOLDED="true" ID="ID_418436210" MODIFIED="1533551799312" TEXT="concepts">
<node CREATED="1530900220190" ID="ID_632391625" LINK="https://stackoverflow.com/questions/47532424/usage-of-this-pointer-in-stdbind?noredirect=1&amp;lq=1" MODIFIED="1530900238138" TEXT="bind(&amp;Class::function, this)"/>
<node CREATED="1530901646160" ID="ID_312880542" LINK="https://hackernoon.com/a-tour-of-c-17-if-constexpr-3ea62f62ff65" MODIFIED="1530901663997" TEXT="if constexpr"/>
<node CREATED="1530902201000" ID="ID_338556188" LINK="https://en.cppreference.com/w/cpp/thread/lock_guard" MODIFIED="1530902206408" TEXT="std::lock_guard"/>
</node>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1970497020" MODIFIED="1533551799313" TEXT="functions">
<node CREATED="1530899510764" FOLDED="true" ID="ID_1538053601" MODIFIED="1533551799312" TEXT="ctor">
<node CREATED="1530899676565" ID="ID_796279046" MODIFIED="1530899723961" TEXT="initialize unprepared_inputs[i] with the corresponding inputs[i] (BlockInputStreams type)"/>
</node>
<node CREATED="1530899739698" FOLDED="true" ID="ID_906709962" MODIFIED="1533551799312" TEXT="dtor">
<node CREATED="1530899740995" ID="ID_1495705922" MODIFIED="1530899745385" TEXT="call wait()"/>
</node>
<node CREATED="1530899499912" FOLDED="true" ID="ID_1097206259" MODIFIED="1533551799312" TEXT="process">
<node CREATED="1530899736523" ID="ID_1994195893" LINK="#ID_632391625" MODIFIED="1530900507872" TEXT="create max_threads number of threads, see link for usage of bind(&amp;Class::function, this)"/>
</node>
<node CREATED="1530899495210" FOLDED="true" ID="ID_629602790" MODIFIED="1533551799312" TEXT="cancel">
<node CREATED="1530900696719" ID="ID_428838450" MODIFIED="1530900742272" TEXT="cast elements in inputs (BlockInputStreams type) to IProfilingBlockInputStream *, and call cancel on them"/>
</node>
<node CREATED="1530899368067" FOLDED="true" ID="ID_1270221978" MODIFIED="1533551799312" TEXT="wait">
<node CREATED="1530899373361" ID="ID_1287616642" MODIFIED="1530899456999" TEXT="if all threads are joined, return. Otherwise, wait till all threads are joined, set threads to empty, and set joined_threads to be true"/>
</node>
<node CREATED="1530899368339" FOLDED="true" ID="ID_1049079863" MODIFIED="1533551799312" TEXT="getNumActiveThreads">
<node CREATED="1530899467146" ID="ID_1504310629" MODIFIED="1530899473897" TEXT="return active_threads"/>
</node>
<node CREATED="1530901754039" FOLDED="true" ID="ID_496324097" MODIFIED="1533551799312" TEXT="publishPayload">
<node CREATED="1530901755213" ID="ID_240943439" MODIFIED="1530901770113" TEXT="call handler.onBlock on given block"/>
</node>
<node CREATED="1530904643678" FOLDED="true" ID="ID_1072885611" MODIFIED="1533551799313" TEXT="thread">
<node CREATED="1530909845663" ID="ID_1116279905" MODIFIED="1530910578522" TEXT="Before any reading, calls &quot;readPrefix&quot; method of sources in parallel.  (As an example, &quot;readPrefix&quot; can prepare connections to remote servers,   *  and we want this work to be executed in parallel for different sources.&#xa;Implementation details is described below:&#xa;1. the following is in a while loop : if unprepared_inputs is empty, break. Otherwise, get the front() of unprepared_inputs, call readPrefix() on it, and put it into available_inputs&#xa;2. call loop()&#xa;3. if there is any exception in step 2 or step3, call handler.onException ( push an exception block onto output_queue)&#xa;4. call handler.onFinishThread(does nothing for UnionBlockInputStream&apos;s handler)&#xa;5. check if current thread is the last thread, if so , do the following: check if there is any additional_input_at_end, if so, process it by calling readPrefix() and read on it, if not, do nothing. Then call handler.onFinish(push an empty block onto output_queue)."/>
</node>
<node CREATED="1530901772830" FOLDED="true" ID="ID_507349159" MODIFIED="1533551799313" TEXT="loop">
<node CREATED="1530904654516" ID="ID_1868200796" MODIFIED="1530909841157">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Basically, what loop() does is to take a BlockInputStreamPtr from available_inputs, read a block from it, and push that block to handler(e.g. output_queue from UnionBlockInputStream), and repeat this until there is nothing left in available_inputs.
    </p>
    <p>
      implementation details is described below:
    </p>
    <p>
      the folllowing steps are in a while loop:
    </p>
    <p>
      1. if available_inputs is empty, break. Otherwise get the front() of available_inputs, denote it as input.
    </p>
    <p>
      2. call input.in-&gt;read ( which does the main work, for example, call OneBlockInputStream-&gt;read to retrieve a block), if the retrieved block is non-empty, means the source (i.e. input) still has block in it (or it just become empty, so that the next read will retrieve an empty block), and thus we put the source back into available_inputs queue for other threads to read from. Otherwise, if the retrieved block is empty, we check if available_inputs is empty, if so, there is nothing more to read from, then break.
    </p>
    <p>
      3. put the block read from step2 onto output_queue.
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1530014254828" FOLDED="true" ID="ID_824573631" MODIFIED="1533551799314" TEXT="classes">
<node CREATED="1530899230526" FOLDED="true" ID="ID_1349238837" MODIFIED="1533551799313" TEXT="ParallelInputsHandler">
<node CREATED="1530014332949" FOLDED="true" ID="ID_359464139" MODIFIED="1533551799313" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1567081638" MODIFIED="1533551799313" TEXT="description">
<node CREATED="1530900857666" ID="ID_1454946643" LINK="#ID_1983307235" MODIFIED="1530900918674" TEXT="Example of how a handler looks like, not actually used, see link for a concrete example"/>
</node>
<node CREATED="1530013560221" ID="ID_1508959984" MODIFIED="1530857319007" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_187423360" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_980688483" MODIFIED="1533551799313" TEXT="functions">
<node CREATED="1530889582347" ID="ID_22674075" MODIFIED="1530889582847" TEXT="onBlock"/>
<node CREATED="1530889587857" ID="ID_186313743" MODIFIED="1530889588158" TEXT="onFinish"/>
<node CREATED="1530889590939" ID="ID_1183088154" MODIFIED="1530889591274" TEXT="onFinishThread"/>
<node CREATED="1530889594380" ID="ID_1604851016" MODIFIED="1530889594682" TEXT="onException"/>
</node>
<node CREATED="1530014254828" ID="ID_968061198" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530898351154" FOLDED="true" ID="ID_1459008674" MODIFIED="1533551799314" TEXT="InputData">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1409566480" MODIFIED="1533551799314" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1856343186" MODIFIED="1533551799313" TEXT="description">
<node CREATED="1531121708714" ID="ID_590903452" MODIFIED="1531121756960" TEXT="represent a data source (of BlockInputStreamPtr type) with some labelling number for debug purpose"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1814682084" MODIFIED="1533551799314" TEXT="members">
<node CREATED="1530898373195" FOLDED="true" ID="ID_99966780" MODIFIED="1533551799314" TEXT="BlockInputStreamPtr">
<node CREATED="1530898374329" ID="ID_1110580789" MODIFIED="1530898376666" TEXT="in : "/>
</node>
<node CREATED="1530898389389" FOLDED="true" ID="ID_1778222372" MODIFIED="1533551799314" TEXT="size_t">
<node CREATED="1530898391185" ID="ID_1244517421" MODIFIED="1530898401462" TEXT="i : The source number (for debugging)."/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1433497074" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1091184308" MODIFIED="1533551799314" TEXT="functions">
<node CREATED="1530898419414" ID="ID_695356921" MODIFIED="1530898421231" TEXT="ctor"/>
</node>
<node CREATED="1530014254828" ID="ID_941325396" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1529663493319" FOLDED="true" ID="ID_1274704864" LINK="ClickHouse/dbms/src/DataStreams/SizeLimits.h" MODIFIED="1533616736134" TEXT="SizeLimits.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1682849243" MODIFIED="1533616736134" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_780826674" MODIFIED="1530912173915" TEXT="description">
<node CREATED="1530260354174" ID="ID_354071591" MODIFIED="1530260639625" TEXT="used for check if a query execution exceeds certain limits">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1632527027" MODIFIED="1530912173916" TEXT="members">
<node CREATED="1530260365943" FOLDED="true" ID="ID_285065036" MODIFIED="1530912173915" TEXT="UInt64">
<node CREATED="1530260436712" ID="ID_1708243108" MODIFIED="1530260451774" TEXT="max_rows : max number of rows"/>
</node>
<node CREATED="1530260367514" FOLDED="true" ID="ID_187264156" MODIFIED="1530912173916" TEXT="UInt64">
<node CREATED="1530260453251" ID="ID_1125095533" MODIFIED="1530260462392" TEXT="max_bytes: max number of bytes"/>
</node>
<node CREATED="1530260426735" FOLDED="true" ID="ID_1973734562" MODIFIED="1530912173916" TEXT="OverflowMode">
<node CREATED="1530260463254" ID="ID_809068857" MODIFIED="1530260504475" TEXT="mode corresponding to measures to take when limit is exceeded (i.e. throw, abort)"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1539012326" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_543885329" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" FOLDED="true" ID="ID_446707187" MODIFIED="1530912173917" TEXT="classes">
<node CREATED="1530260375923" FOLDED="true" ID="ID_1469656514" MODIFIED="1530912173916" TEXT="enum OverflowMode">
<node CREATED="1530260394702" ID="ID_1555367397" MODIFIED="1530260401903" TEXT="THROW = 0"/>
<node CREATED="1530260402424" ID="ID_1849004940" MODIFIED="1530260409417" TEXT="BREAK = 1"/>
<node CREATED="1530260410074" ID="ID_26566015" MODIFIED="1530260411815" TEXT="ANY = 2"/>
</node>
</node>
</node>
</node>
<node CREATED="1529891714431" ID="ID_482799184" LINK="ClickHouse/dbms/src/DataStreams/SizeLimits.cpp" MODIFIED="1529891737284" TEXT="SizeLimits.cpp"/>
</node>
<node CREATED="1529562681913" FOLDED="true" ID="ID_911703083" MODIFIED="1534161035946" TEXT="DataTypes">
<node CREATED="1529562694094" ID="ID_177243340" LINK="ClickHouse/dbms/src/DataTypes/IDataType.h" MODIFIED="1533876031825" TEXT="IDataType.h">
<node CREATED="1530014296023" ID="ID_167134000" MODIFIED="1533876033978" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_971247188" MODIFIED="1532517445477" TEXT="description">
<node CREATED="1530150408615" ID="ID_590430758" MODIFIED="1530175433576" TEXT="1. provide interface for binary serialization(write)/deserialization(read) for range of values in column - for writing to/ reading from disk/network.&#xa;&#xa;2. IDataType directly corresponds to data types in tables. For example, there are DataTypeUInt32, DataTypeDateTime, DataTypeString and so on. (refer to clickhouse documentation for full explanation on the difference between IDataType and the data type of IColumn.)"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1028423744" MODIFIED="1533876037940" TEXT="members">
<node CREATED="1530155162010" ID="ID_783566422" MODIFIED="1530155166093" TEXT="no member"/>
</node>
<node CREATED="1530013563312" ID="ID_1741415876" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_1154591031" MODIFIED="1533876039252" TEXT="functions">
<node CREATED="1530163734333" FOLDED="true" ID="ID_502904471" MODIFIED="1530912173919" TEXT="virtual getName">
<node CREATED="1530163737532" ID="ID_1511432055" MODIFIED="1530163902099" TEXT="return the (nested) names of underlying data type (i.e. UInt64 \ Array(String))"/>
</node>
<node CREATED="1530154709630" FOLDED="true" ID="ID_1282147770" MODIFIED="1533880845538" TEXT="serialize">
<node CREATED="1530154724258" FOLDED="true" ID="ID_1856101688" MODIFIED="1533880844633" TEXT="virtual serializeBinaryBulkWithMultipleStreams">
<node CREATED="1530601685326" ID="ID_1611900911" LINK="#ID_758361992" MODIFIED="1530601890369" TEXT="determine the output stream to write to from getter for different substream type , then call serializeBinaryBulk to write the data, see NativeBlockOutputStream::writeData for an example"/>
<node CREATED="1530154781439" ID="ID_1831951474" MODIFIED="1530164052890" TEXT="virtual serializeBinaryBulk"/>
</node>
<node CREATED="1530154804306" ID="ID_363727358" MODIFIED="1530164004780" TEXT="virtual serializeBinary"/>
<node CREATED="1530154816968" ID="ID_1361075800" MODIFIED="1530164010547" TEXT="virtual serializeTextEscaped"/>
<node CREATED="1530154829967" ID="ID_760119462" MODIFIED="1530164013843" TEXT="virtual serializeTextQuoted"/>
<node CREATED="1530154841682" ID="ID_620024983" MODIFIED="1530164016444" TEXT="virtual serializeTextCSV"/>
<node CREATED="1530154860470" ID="ID_1318421977" MODIFIED="1530164019077" TEXT="virtual serializeText"/>
<node CREATED="1530154865392" ID="ID_991423902" MODIFIED="1530164021526" TEXT="virtual serializeTextJSON"/>
<node CREATED="1530154880398" ID="ID_101687724" MODIFIED="1530164024184" TEXT="virtual serializeTextXML"/>
<node CREATED="1530584849198" ID="ID_1489369924" MODIFIED="1530584910555" TEXT="virtual serializeBinaryBulk"/>
</node>
<node CREATED="1530154715415" FOLDED="true" ID="ID_659741328" MODIFIED="1533880813082" TEXT="deserialize">
<node CREATED="1530154757907" FOLDED="true" ID="ID_675617438" MODIFIED="1533880811584" TEXT="virtual deserializeBinaryBulkWithMultipleStreams">
<node CREATED="1530601787651" ID="ID_1357107559" MODIFIED="1530601797072" TEXT="similar to serializeBinaryBulkWithMultipleStreams"/>
<node CREATED="1530154786232" ID="ID_457702022" MODIFIED="1530164059141" TEXT="virtual deserializeBinaryBulk"/>
</node>
<node CREATED="1530154808453" ID="ID_313254605" MODIFIED="1530164033225" TEXT="virtual deserializeBinary"/>
<node CREATED="1530154820893" ID="ID_1590479862" MODIFIED="1530164035986" TEXT="virtual deserializeTextEscaped"/>
<node CREATED="1530154832642" ID="ID_571775731" MODIFIED="1530164038323" TEXT="virtual deserializeTextQuoted"/>
<node CREATED="1530154844300" ID="ID_1428299140" MODIFIED="1530164040575" TEXT="virtual deserializeTextCSV"/>
<node CREATED="1530154869494" ID="ID_172469053" MODIFIED="1530164044381" TEXT="virtual deserializeTextJSON"/>
<node CREATED="1530584849198" ID="ID_1713956165" MODIFIED="1530584914366" TEXT="virtual deserializeBinaryBulk"/>
</node>
<node CREATED="1530155107471" FOLDED="true" ID="ID_1572685929" MODIFIED="1530912173920" TEXT="isParametric(), etc">
<node CREATED="1530155124570" ID="ID_1784937413" MODIFIED="1530155145559" TEXT="give info on the type"/>
</node>
<node CREATED="1533878512317" FOLDED="true" ID="ID_607696889" MODIFIED="1533880764146" TEXT="virtual void enumerateStreams(StreamCallback callback, SubstreamPath path)">
<node CREATED="1533878530312" ID="ID_801330892" LINK="#ID_1198729670" MODIFIED="1533878679645" TEXT="for this base class, all it does is &quot; callback(path)&quot;, but for some derived class such as DataTypeArray (see link), it&apos;s more complicated)"/>
</node>
<node CREATED="1533876041644" FOLDED="true" ID="ID_1661665214" MODIFIED="1533880766835" TEXT="String getFileNameForStream(const String &amp; column_name, const SubstreamPath &amp; path)">
<node CREATED="1533876911432" ID="ID_1328320169" LINK="#ID_1698126007" MODIFIED="1533876960506" TEXT="1. nested_table_name extractTableName on &quot;column_name&quot;"/>
<node CREATED="1533876941622" ID="ID_1192238108" MODIFIED="1533877078267" TEXT="2. if path.size() == 1  &amp;&amp;&#xa;path[0].type == IDataType::Substream::ArraySizes &amp;&amp; &#xa;nested_table_name != column_name;&#xa;then &quot;stream_name&quot; = nested_table_name&#xa;else &quot;stream_name&quot; = column_name"/>
<node CREATED="1533877081722" ID="ID_1041984004" MODIFIED="1533877137044" TEXT="3. add some suffixes to &quot;stream_name&quot; based on &quot;path&quot;"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1971951075" MODIFIED="1533876058052" TEXT="classes">
<node CREATED="1530101621502" FOLDED="true" ID="ID_405834001" MODIFIED="1533876062160" TEXT="Substream">
<node CREATED="1530101647369" FOLDED="true" ID="ID_128715907" MODIFIED="1530912173921" TEXT="enum Type">
<node CREATED="1530101649815" ID="ID_1770877196" MODIFIED="1530101656601" TEXT="ArrayElements"/>
<node CREATED="1530101661518" ID="ID_168379958" MODIFIED="1530101663117" TEXT="ArraySizes"/>
<node CREATED="1530101668752" ID="ID_62334799" MODIFIED="1530101670325" TEXT="NullableElements"/>
<node CREATED="1530101673420" ID="ID_987880785" MODIFIED="1530101674773" TEXT="NullMap"/>
<node CREATED="1530101677306" ID="ID_1894579034" MODIFIED="1530101678579" TEXT="TupleElement"/>
</node>
<node CREATED="1530101713421" ID="ID_870858417" MODIFIED="1530101717194" TEXT="String tuple_element_name"/>
</node>
</node>
<node CREATED="1530172241289" FOLDED="true" ID="ID_377171354" MODIFIED="1530912173922" TEXT="typedef">
<node CREATED="1530172245749" FOLDED="true" ID="ID_1413918538" MODIFIED="1530912173921" TEXT="SubstreamPath">
<node CREATED="1530172254552" ID="ID_1202245938" MODIFIED="1530174102276" TEXT="std::vector&lt;Substream&gt;"/>
</node>
<node CREATED="1530172268730" FOLDED="true" ID="ID_808373279" MODIFIED="1530912173921" TEXT="StreamCallback">
<node CREATED="1530172282330" ID="ID_403782236" MODIFIED="1530174107286" TEXT="std::function&lt;void(const SubstreamPath &amp;)&gt;"/>
</node>
<node CREATED="1530172285352" FOLDED="true" ID="ID_1964918108" MODIFIED="1530912173922" TEXT="OutputStreamGetter">
<node CREATED="1530172294378" ID="ID_1739951674" MODIFIED="1530174111049" TEXT="std::function&lt;WriteBuffer*(const SubstreamPath &amp;)&gt;"/>
</node>
<node CREATED="1530172308832" FOLDED="true" ID="ID_848000171" MODIFIED="1530912173922" TEXT="InputStreamGetter">
<node CREATED="1530172319700" ID="ID_1404557999" MODIFIED="1530174114729" TEXT="std::function&lt;ReadBuffer*(const SubstreamPath &amp;)&gt;"/>
</node>
</node>
</node>
<node CREATED="1530157931926" ID="ID_1198886853" LINK="ClickHouse/dbms/src/DataTypes/DataTypeArray.h" MODIFIED="1533878669070" TEXT="DataTypeArray.h">
<node CREATED="1530014296023" ID="ID_1511691032" MODIFIED="1533878669803" TEXT="properties">
<node CREATED="1530013557169" ID="ID_711516580" MODIFIED="1530081562328" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_975861347" MODIFIED="1533551799320" TEXT="members">
<node CREATED="1530163576623" FOLDED="true" ID="ID_94936225" MODIFIED="1533523072358" TEXT="DataTypePtr">
<node CREATED="1530163595388" ID="ID_1080185396" MODIFIED="1530163635819" TEXT="a IDataType pointer, that stores the element type of the array"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1218700701" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_1569036150" MODIFIED="1533878673385" TEXT="functions">
<node CREATED="1530163661193" ID="ID_298874062" LINK="#ID_502904471" MODIFIED="1530163980940" TEXT="virtual getName"/>
<node CREATED="1530154709630" ID="ID_518321093" MODIFIED="1533880817767" TEXT="serialize">
<node CREATED="1530154724258" ID="ID_244261559" MODIFIED="1533881212168" TEXT="void DataTypeArray::serializeBinaryBulkWithMultipleStreams(&#xa;    const IColumn &amp; column,&#xa;    OutputStreamGetter getter,&#xa;    size_t offset,&#xa;    size_t limit,&#xa;    bool position_independent_encoding,&#xa;    SubstreamPath path) const">
<node CREATED="1533880846872" ID="ID_1018745110" MODIFIED="1533881852930">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      1. push_back Substream::ArraySizes to &quot;path&quot;
    </p>
    <p>
      2. stream = getter(path) and serializeBinaryBulk column(ColumnArray type).offsets to &quot;stream&quot;
    </p>
    <p>
      3. set path.back() = Substream::ArrayElements and call
    </p>
    <p>
      &#160;nested-&gt;serializeBinaryBulkWithMultipleStreams(column_array.getData(), getter, nested_offset, nested_limit, position_independent_encoding, path)
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1530154781439" ID="ID_1091905294" MODIFIED="1530164052890" TEXT="virtual serializeBinaryBulk"/>
</node>
</node>
<node CREATED="1530154715415" ID="ID_1233670580" MODIFIED="1533880818453" TEXT="deserialize">
<node CREATED="1530154757907" ID="ID_1723960367" MODIFIED="1533881226718" TEXT="void DataTypeArray::deserializeBinaryBulkWithMultipleStreams(&#xa;    IColumn &amp; column,&#xa;    InputStreamGetter getter,&#xa;    size_t limit,&#xa;    double /*avg_value_size_hint*/,&#xa;    bool position_independent_encoding,&#xa;    SubstreamPath path) const">
<node CREATED="1533881864735" ID="ID_1998197715" LINK="#ID_244261559" MODIFIED="1533881900007" TEXT="similar to serializeBinaryBulkWithMultipleStreams"/>
<node CREATED="1530154786232" ID="ID_1190284596" MODIFIED="1530164059141" TEXT="virtual deserializeBinaryBulk"/>
</node>
</node>
<node CREATED="1533878675014" ID="ID_1198729670" MODIFIED="1533878675796" TEXT="virtual void enumerateStreams(StreamCallback callback, SubstreamPath path)">
<node CREATED="1533878920305" ID="ID_1117872858" MODIFIED="1533878933828">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      path.push_back(Substream::ArraySizes);
    </p>
    <p>
      callback(path);
    </p>
    <p>
      path.back() = Substream::ArrayElements;
    </p>
    <p>
      nested-&gt;enumerateStreams(callback, path);
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1530014254828" ID="ID_442416458" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530157933926" ID="ID_1557283273" LINK="ClickHouse/dbms/src/DataTypes/DataTypeArray.cpp" MODIFIED="1530157980002" TEXT="DataTypeArray.cpp"/>
<node CREATED="1530157882234" FOLDED="true" ID="ID_56468319" LINK="ClickHouse/dbms/src/DataTypes/DataTypeNumberBase.h" MODIFIED="1533616736137" TEXT="DataTypeNumberBase.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_300572629" MODIFIED="1530857318989" TEXT="properties">
<node CREATED="1530013557169" ID="ID_1063880871" MODIFIED="1530081562328" TEXT="description"/>
<node CREATED="1530013560221" ID="ID_501719905" MODIFIED="1530013562255" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_1054241111" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_783649635" MODIFIED="1530912173925" TEXT="functions">
<node CREATED="1530163661193" ID="ID_43812690" LINK="#ID_502904471" MODIFIED="1530163980940" TEXT="virtual getName"/>
</node>
<node CREATED="1530014254828" ID="ID_1520749652" MODIFIED="1530079245976" TEXT="classes"/>
</node>
<node CREATED="1530158011055" FOLDED="true" ID="ID_844337619" LINK="ClickHouse/dbms/src/DataTypes/DataTypesNumber.h" MODIFIED="1533551799321" TEXT="DataTypeNumber.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_193343910" MODIFIED="1533551799321" TEXT="properties">
<node CREATED="1530013557169" ID="ID_1652353974" MODIFIED="1530081562328" TEXT="description"/>
<node CREATED="1530013560221" ID="ID_202022231" MODIFIED="1530013562255" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_969598880" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1907982207" MODIFIED="1533551799321" TEXT="functions">
<node CREATED="1530163661193" ID="ID_1159825355" LINK="#ID_502904471" MODIFIED="1530163980940" TEXT="virtual getName"/>
<node CREATED="1530584935416" FOLDED="true" ID="ID_1590120725" MODIFIED="1530913425584" TEXT="virtual serializeBinaryBulk override ">
<node CREATED="1530584945007" ID="ID_168587868" MODIFIED="1530585037885" TEXT="serialize ( write) to buffer by writing the whole chunk of memory denoted by (offset, offset+limit) in one write operation"/>
</node>
<node CREATED="1530584941243" FOLDED="true" ID="ID_908365224" MODIFIED="1530912173926" TEXT="virtual deserializeBinaryBulk override ">
<node CREATED="1530584945007" ID="ID_1917126358" MODIFIED="1530585065452" TEXT="deserialize ( read) from buffer by reading the whole chunk of memory denoted by (offset, offset+limit) in one read operation"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_497060829" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530158040500" ID="ID_1007289590" LINK="ClickHouse/dbms/src/DataTypes/DataTypesNumber.cpp" MODIFIED="1530158062659" TEXT="DataTypeNumber.cpp"/>
</node>
<node CREATED="1530157900642" ID="ID_703935860" LINK="ClickHouse/dbms/src/DataTypes/DataTypeNumberBase.cpp" MODIFIED="1530157991131" TEXT="DataTypeNumberBase.cpp"/>
<node CREATED="1530157940233" FOLDED="true" ID="ID_1049662505" LINK="ClickHouse/dbms/src/DataTypes/DataTypeString.h" MODIFIED="1533616736137" TEXT="DataTypeString.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_982028300" MODIFIED="1533523060392" TEXT="properties">
<node CREATED="1530013557169" ID="ID_985144325" MODIFIED="1530081562328" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_222407706" MODIFIED="1530912173927" TEXT="members">
<node CREATED="1530172417881" ID="ID_705652221" MODIFIED="1530172421353" TEXT="no members"/>
</node>
<node CREATED="1530013563312" ID="ID_1953198992" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_576237813" MODIFIED="1533551799322" TEXT="functions">
<node CREATED="1530163661193" ID="ID_1415506496" LINK="#ID_502904471" MODIFIED="1530163980940" TEXT="virtual getName"/>
<node CREATED="1530154709630" FOLDED="true" ID="ID_507181226" MODIFIED="1533551799322" TEXT="serialize">
<node CREATED="1530154724258" FOLDED="true" ID="ID_956752791" MODIFIED="1530912173927" TEXT="virtual serializeBinaryBulkWithMultipleStreams">
<node CREATED="1530154781439" ID="ID_1209755907" MODIFIED="1530164052890" TEXT="virtual serializeBinaryBulk"/>
</node>
<node CREATED="1530154804306" FOLDED="true" ID="ID_114274350" MODIFIED="1530913479944" TEXT="virtual serializeBinary override">
<node CREATED="1530166943458" ID="ID_100042988" MODIFIED="1530167006526" TEXT="write the size of the string and the string itself sequentially to an output stream"/>
</node>
<node CREATED="1530154816968" FOLDED="true" ID="ID_1632074815" MODIFIED="1530912173928" TEXT="virtual serializeTextEscaped">
<node CREATED="1530170479147" ID="ID_917923563" MODIFIED="1530170605652" TEXT="fetch Stringref to a row in a string column, and write the escaped string (i.e. tab becomes \t, newline become \n, etc.) to an output stream"/>
</node>
<node CREATED="1530154829967" ID="ID_984963914" MODIFIED="1530164013843" TEXT="virtual serializeTextQuoted"/>
<node CREATED="1530154841682" ID="ID_661711254" MODIFIED="1530164016444" TEXT="virtual serializeTextCSV"/>
<node CREATED="1530154860470" FOLDED="true" ID="ID_1509483927" MODIFIED="1530912173928" TEXT="virtual serializeText">
<node CREATED="1530169044100" ID="ID_1946157781" MODIFIED="1530169228362" TEXT="fetch Stringref to a row in a string column, and write the string to an output stream"/>
</node>
<node CREATED="1530154865392" ID="ID_936885315" MODIFIED="1530164021526" TEXT="virtual serializeTextJSON"/>
<node CREATED="1530154880398" ID="ID_1593204442" MODIFIED="1530164024184" TEXT="virtual serializeTextXML"/>
</node>
<node CREATED="1530154715415" FOLDED="true" ID="ID_507984019" MODIFIED="1533551799322" TEXT="deserialize">
<node CREATED="1530154757907" FOLDED="true" ID="ID_636748758" MODIFIED="1530912173929" TEXT="virtual deserializeBinaryBulkWithMultipleStreams">
<node CREATED="1530154786232" ID="ID_1803571881" MODIFIED="1530164059141" TEXT="virtual deserializeBinaryBulk"/>
</node>
<node CREATED="1530154808453" FOLDED="true" ID="ID_1317490192" MODIFIED="1530912173929" TEXT="virtual deserializeBinary override">
<node CREATED="1530168096414" ID="ID_400492123" MODIFIED="1530168161647" TEXT="read the size of the string, then create a string field, resize the data of the field to size, then read from an input stream into the field data"/>
</node>
<node CREATED="1530154820893" ID="ID_1736029492" MODIFIED="1530171301488" TEXT="virtual deserializeTextEscaped">
<linktarget COLOR="#b0b0b0" DESTINATION="ID_1736029492" ENDARROW="Default" ENDINCLINATION="130;0;" ID="Arrow_ID_197697397" SOURCE="ID_446578962" STARTARROW="None" STARTINCLINATION="130;0;"/>
</node>
<node CREATED="1530154832642" ID="ID_1764935342" MODIFIED="1530164038323" TEXT="virtual deserializeTextQuoted"/>
<node CREATED="1530154844300" ID="ID_1494489805" MODIFIED="1530164040575" TEXT="virtual deserializeTextCSV"/>
<node CREATED="1530154869494" ID="ID_1572272914" MODIFIED="1530164044381" TEXT="virtual deserializeTextJSON"/>
</node>
<node CREATED="1530171282075" ID="ID_446578962" MODIFIED="1530173728272">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      template &lt;typename Reader&gt;
    </p>
    <p>
      static inline void read(IColumn &amp; column, Reader &amp;&amp; reader)
    </p>
  </body>
</html></richcontent>
<arrowlink DESTINATION="ID_1736029492" ENDARROW="Default" ENDINCLINATION="130;0;" ID="Arrow_ID_197697397" STARTARROW="None" STARTINCLINATION="130;0;"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1323991374" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530157957023" ID="ID_1130605428" LINK="ClickHouse/dbms/src/DataTypes/DataTypeString.cpp" MODIFIED="1530158002939" TEXT="DataTypeString.cpp"/>
<node CREATED="1533523529238" FOLDED="true" ID="ID_1699090507" LINK="ClickHouse/dbms/src/DataTypes/DataTypeTuple.h" MODIFIED="1533616736138" TEXT="DataTypeTuple.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_720740765" MODIFIED="1533551799325" TEXT="properties">
<node CREATED="1530013557169" ID="ID_249212970" MODIFIED="1530081562328" TEXT="description"/>
<node CREATED="1533523886020" FOLDED="true" ID="ID_50702517" MODIFIED="1533551799324" TEXT="members">
<node CREATED="1533523891357" FOLDED="true" ID="ID_1895115807" MODIFIED="1533551799323" TEXT="DataTypes">
<node CREATED="1533523899746" ID="ID_1334456479" MODIFIED="1533523902469" TEXT="elems"/>
</node>
<node CREATED="1533523892181" FOLDED="true" ID="ID_329113418" MODIFIED="1533551799323" TEXT="Strings">
<node CREATED="1533523904086" ID="ID_1730577093" MODIFIED="1533523904940" TEXT="names"/>
</node>
<node CREATED="1533523897950" FOLDED="true" ID="ID_542579443" MODIFIED="1533551799323" TEXT="bool">
<node CREATED="1533523908454" ID="ID_1424356403" MODIFIED="1533523908972" TEXT="have_explicit_names"/>
</node>
<node CREATED="1533523915754" FOLDED="true" ID="ID_650786884" MODIFIED="1533551799324" TEXT="static constexpr bool">
<node CREATED="1533523935183" ID="ID_212473158" MODIFIED="1533523935470" TEXT="is_parametric = true"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1016389267" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_1286275028" MODIFIED="1533523864610" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_64433803" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1533523541464" ID="ID_1843080876" LINK="ClickHouse/dbms/src/DataTypes/DataTypeTuple.cpp" MODIFIED="1533523588880" TEXT="DataTypeTuple.cpp"/>
</node>
<node CREATED="1529891881359" ID="ID_1395034063" LINK="ClickHouse/dbms/src/DataTypes/IDataType.cpp" MODIFIED="1529898175866" TEXT="IDataType.cpp"/>
<node CREATED="1533523214051" ID="ID_1617808512" LINK="ClickHouse/dbms/src/DataTypes/NestedUtils.h" MODIFIED="1533616742450" TEXT="NestedUtils.h">
<node CREATED="1533523235942" ID="ID_498296618" MODIFIED="1533616743881" TEXT="Block flatten(const Block &amp; block)">
<node CREATED="1533523256400" ID="ID_766745649" LINK="illustration%20of%20flatten(Block).png" MODIFIED="1533616753736" TEXT="Replace Array(Tuple(...)) columns to a multiple of Array columns in a form of `column_name.element_name`.&#xa;detail: assume block is of type Array(Tuple(...)), then just expand the columns (kind of like materialize) as illustrated"/>
</node>
<node CREATED="1533876118160" ID="ID_1283058086" MODIFIED="1533876128454" TEXT="pair&lt;string, string&gt; splitName(const string &amp; name)">
<node CREATED="1533876129692" ID="ID_1572787112" MODIFIED="1533876452638" TEXT="takes in a string, if the string is of format _*[a-zA-Z0-9]\._*[a-zA-Z0-9] (i.e. 2 alphanumeric strings with optional prefix &quot;_&quot; which are separated by &quot;.&quot;), then it returns the 2 strings in a pair, otherwise it returns the string itself and an empty string"/>
</node>
<node CREATED="1533876095061" ID="ID_1698126007" MODIFIED="1533876101562" TEXT="string extractTableName(const string &amp; nested_name)">
<node CREATED="1533876701945" ID="ID_436453903" MODIFIED="1533876724825" TEXT="get the first string after passing &quot;nested_name&quot; to splitName"/>
</node>
</node>
<node CREATED="1533523232395" ID="ID_932642844" LINK="ClickHouse/dbms/src/DataTypes/NestedUtils.cpp" MODIFIED="1533523604152" TEXT="NestedUtils.cpp"/>
</node>
<node CREATED="1529667688644" FOLDED="true" ID="ID_1345802108" MODIFIED="1533616736143" TEXT="Format">
<node CREATED="1529898589078" FOLDED="true" ID="ID_1723651238" LINK="ClickHouse/dbms/src/Formats/IRowInputStream.h" MODIFIED="1533616736141" TEXT="IRowInputStream.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_757672777" MODIFIED="1533616736140" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_487885243" MODIFIED="1533551799326" TEXT="description">
<node CREATED="1532517854679" ID="ID_599612884" MODIFIED="1532517883468" TEXT="defines interface for inputting data in different formats (binary, csv, json, etc)"/>
</node>
<node CREATED="1530013560221" ID="ID_1300357181" MODIFIED="1530013562255" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_952888193" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_102133568" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_986249542" MODIFIED="1530079245976" TEXT="classes"/>
</node>
<node CREATED="1529898694683" FOLDED="true" ID="ID_258528721" LINK="ClickHouse/dbms/src/Formats/BinaryRowInputStream.h" MODIFIED="1533616736140" TEXT="BinaryRowInputStream.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_1598914166" MODIFIED="1533551799328" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_129291328" MODIFIED="1533551799327" TEXT="description">
<node CREATED="1532517504798" ID="ID_166960227" MODIFIED="1532517851426" TEXT="A stream for inputting data in a binary line-by-line format."/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_872990593" MODIFIED="1533551799327" TEXT="members">
<node CREATED="1532517538294" FOLDED="true" ID="ID_1711483621" MODIFIED="1533551799327" TEXT=" ReadBuffer &amp;">
<node CREATED="1532517542193" ID="ID_693849007" MODIFIED="1532517566604" TEXT="istr : input stream"/>
</node>
<node CREATED="1532517600368" FOLDED="true" ID="ID_1821372121" MODIFIED="1533551799327" TEXT="Block">
<node CREATED="1532517603866" ID="ID_753723109" MODIFIED="1532517611001" TEXT="header : sample block"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1759213696" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_160639584" MODIFIED="1533551799327" TEXT="functions">
<node CREATED="1532517622827" FOLDED="true" ID="ID_1195759602" MODIFIED="1533551799327" TEXT=" bool read(MutableColumns &amp; columns)">
<node CREATED="1532517631226" ID="ID_1521887526" MODIFIED="1532517657532" TEXT="read from istr into columns based on header&apos;s datatype"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_554937949" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1529898701929" ID="ID_1476066105" LINK="ClickHouse/dbms/src/Formats/BinaryRowInputStream.cpp" MODIFIED="1529898737618" TEXT="BinaryRowInputStream.cpp"/>
<node CREATED="1532517890510" FOLDED="true" ID="ID_1724409495" LINK="ClickHouse/dbms/src/Formats/CSVRowInputStream.h" MODIFIED="1533616736141" TEXT="CSVRowInputStream.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_917934425" MODIFIED="1533551799329" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1621991489" MODIFIED="1533551799328" TEXT="description">
<node CREATED="1532517504798" ID="ID_1794028456" MODIFIED="1532517958037" TEXT="A stream for inputting data in csv format."/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_873966301" MODIFIED="1533551799329" TEXT="members">
<node CREATED="1532517538294" FOLDED="true" ID="ID_407482431" MODIFIED="1533551799328" TEXT=" ReadBuffer &amp;">
<node CREATED="1532517542193" ID="ID_1421328653" MODIFIED="1532517566604" TEXT="istr : input stream"/>
</node>
<node CREATED="1532517600368" FOLDED="true" ID="ID_23198143" MODIFIED="1533551799328" TEXT="Block">
<node CREATED="1532517603866" ID="ID_601933552" MODIFIED="1532517611001" TEXT="header : sample block"/>
</node>
<node CREATED="1532517964953" FOLDED="true" ID="ID_1359730558" MODIFIED="1533551799328" TEXT="bool">
<node CREATED="1532517987982" ID="ID_1684398560" MODIFIED="1532517990220" TEXT="with_names :"/>
</node>
<node CREATED="1532517970342" FOLDED="true" ID="ID_834196367" MODIFIED="1533551799329" TEXT="DataTypes">
<node CREATED="1532517991217" ID="ID_1913922971" MODIFIED="1532517996926" TEXT="data_types : "/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_826063629" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_546779211" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_444137879" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1532517915681" ID="ID_704737668" LINK="ClickHouse/dbms/src/Formats/CSVRowInputStream.cpp" MODIFIED="1532517944224" TEXT="CSVRowInputStream.cpp"/>
</node>
<node CREATED="1529898648748" ID="ID_1775331165" LINK="ClickHouse/dbms/src/Formats/IRowInputStream.cpp" MODIFIED="1529898677216" TEXT="IRowInputStream.cpp"/>
<node CREATED="1529667694687" FOLDED="true" ID="ID_1247684599" LINK="ClickHouse/dbms/src/Formats/IRowOutputStream.h" MODIFIED="1533616736143" TEXT="IRowOutputStream.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_958634162" MODIFIED="1533616736142" TEXT="properties">
<node CREATED="1530013557169" ID="ID_1253547248" MODIFIED="1530081562328" TEXT="description"/>
<node CREATED="1530013560221" ID="ID_106618406" MODIFIED="1530013562255" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_1315167082" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_1919035046" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1852279285" MODIFIED="1530079245976" TEXT="classes"/>
</node>
<node CREATED="1529898448265" FOLDED="true" ID="ID_340005960" LINK="ClickHouse/dbms/src/Formats/JSONRowOutputStream.h" MODIFIED="1533616736142" TEXT="JSONRowOutputStream.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_733252181" MODIFIED="1533551799329" TEXT="properties">
<node CREATED="1530013557169" ID="ID_778235532" MODIFIED="1530081562328" TEXT="description"/>
<node CREATED="1530013560221" ID="ID_1028618652" MODIFIED="1530013562255" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_1085368202" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_720037347" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1942793716" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1529898454795" ID="ID_672513364" LINK="ClickHouse/dbms/src/Formats/JSONRowOutputStream.cpp" MODIFIED="1530171537099" TEXT="JSONRowOutputStream.cpp"/>
</node>
<node CREATED="1529891899269" ID="ID_1426808252" LINK="ClickHouse/dbms/src/Formats/IRowOutputStream.cpp" MODIFIED="1529898548762" TEXT="IRowOutputStream.cpp"/>
</node>
<node CREATED="1529481453965" FOLDED="true" ID="ID_1022535075" MODIFIED="1533878504350" TEXT="IO">
<node CREATED="1529670117509" ID="ID_1001506288" LINK="ClickHouse/dbms/src/IO/BufferBase.h" MODIFIED="1533618381422" TEXT="BufferBase.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_18784821" MODIFIED="1533618386208" TEXT="properties">
<node CREATED="1530013557169" ID="ID_1952500219" MODIFIED="1530081562328" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1059419310" MODIFIED="1533551799330" TEXT="members">
<node CREATED="1532519239125" FOLDED="true" ID="ID_958753345" MODIFIED="1533551799330" TEXT="Position(char *)">
<node CREATED="1532519240467" ID="ID_38797486" MODIFIED="1532520216147" TEXT="pos : read /write position (cursor position)"/>
</node>
<node CREATED="1532519253473" FOLDED="true" ID="ID_1334200534" MODIFIED="1533551799330" TEXT="size_t">
<node CREATED="1532519258916" ID="ID_1761957931" MODIFIED="1532519303680" TEXT="bytes : how many bytes have been read /written, not including those already in the buffer"/>
</node>
<node CREATED="1532519306136" FOLDED="true" ID="ID_246929929" MODIFIED="1533551799330" TEXT="Buffer">
<node CREATED="1532520142519" ID="ID_77562135" MODIFIED="1532520149592" TEXT="working_buffer : "/>
</node>
<node CREATED="1532519311717" FOLDED="true" ID="ID_210868247" MODIFIED="1533551799330" TEXT="Buffer">
<node CREATED="1532520150467" ID="ID_721787605" MODIFIED="1532520154570" TEXT="internal_buffer : "/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1429127783" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_476958338" MODIFIED="1533618195480" TEXT="functions">
<node CREATED="1532520121072" FOLDED="true" ID="ID_1851858340" MODIFIED="1533551799330" TEXT="internalBuffer">
<node CREATED="1532520128548" ID="ID_732985399" MODIFIED="1532520141103" TEXT="return internal_buffer"/>
</node>
<node CREATED="1532520159823" FOLDED="true" ID="ID_526533069" MODIFIED="1533551799331" TEXT="buffer">
<node CREATED="1532520167212" ID="ID_68352817" MODIFIED="1532520172817" TEXT="return working_buffer"/>
</node>
<node CREATED="1532520173750" FOLDED="true" ID="ID_142349737" MODIFIED="1533551799331" TEXT="position">
<node CREATED="1532520182602" ID="ID_964571924" MODIFIED="1532520184215" TEXT="return pos"/>
</node>
<node CREATED="1532520185242" FOLDED="true" ID="ID_1595568772" MODIFIED="1533551799331" TEXT="offset">
<node CREATED="1532520222445" ID="ID_1219483911" MODIFIED="1532520239378" TEXT="offset in bytes of the cursor from the beginning of the working_buffer"/>
</node>
<node CREATED="1532520240108" FOLDED="true" ID="ID_1866458341" MODIFIED="1533551799331" TEXT="count">
<node CREATED="1532520264243" ID="ID_984043891" MODIFIED="1532520274921" TEXT="count how many bytes have been read/written, counting those that are still in the buffer"/>
</node>
<node CREATED="1532520276879" FOLDED="true" ID="ID_495112071" MODIFIED="1533551799331" TEXT="hasPendingData">
<node CREATED="1532520302223" ID="ID_1067252182" MODIFIED="1532520308066" TEXT="check that there is more bytes in buffer after cursor"/>
</node>
</node>
<node CREATED="1530014254828" FOLDED="true" ID="ID_1630901357" MODIFIED="1533551799332" TEXT="classes">
<node CREATED="1532519667882" FOLDED="true" ID="ID_43949181" MODIFIED="1533551799332" TEXT="Buffer">
<node CREATED="1532519668992" FOLDED="true" ID="ID_672983553" MODIFIED="1533551799332" TEXT="members">
<node CREATED="1532519687136" ID="ID_1732973886" MODIFIED="1532519705427" TEXT="Position(char *) : begin_pos"/>
<node CREATED="1532519687136" ID="ID_1419671751" MODIFIED="1532519710975" TEXT="Position(char *) : end_pos"/>
</node>
<node CREATED="1532519736204" FOLDED="true" ID="ID_68089129" MODIFIED="1533551799332" TEXT="functions">
<node CREATED="1532519739750" FOLDED="true" ID="ID_1257047914" MODIFIED="1533551799332" TEXT="begin">
<node CREATED="1532519742474" ID="ID_1018871227" MODIFIED="1532519749252" TEXT="return begin_pos"/>
</node>
<node CREATED="1532519739750" FOLDED="true" ID="ID_330791031" MODIFIED="1533551799332" TEXT="end">
<node CREATED="1532519742474" ID="ID_419415462" MODIFIED="1532519756272" TEXT="return end_pos"/>
</node>
<node CREATED="1532519759458" ID="ID_534352524" MODIFIED="1532519761373" TEXT="size"/>
<node CREATED="1532519761916" ID="ID_835954920" MODIFIED="1532519762907" TEXT="resize"/>
</node>
</node>
</node>
</node>
<node CREATED="1529670139771" ID="ID_1299255800" LINK="ClickHouse/dbms/src/IO/ReadBuffer.h" MODIFIED="1533618169610" TEXT="ReadBuffer.h">
<node CREATED="1530014296023" ID="ID_1565663248" MODIFIED="1533618170681" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1747944356" MODIFIED="1533551799333" TEXT="description">
<node CREATED="1532521618704" ID="ID_1906917553" MODIFIED="1532521646296" TEXT="provides interface for different types of read buffer"/>
</node>
<node CREATED="1530013560221" ID="ID_966464663" MODIFIED="1533619853644" TEXT="members">
<node CREATED="1532519839501" FOLDED="true" ID="ID_1794256550" MODIFIED="1533619856688" TEXT="size_t">
<node CREATED="1532519841143" ID="ID_1271606101" MODIFIED="1532519848813" TEXT="working_buffer_offset"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1508752987" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_1627849930" MODIFIED="1533618172990" TEXT="functions">
<node CREATED="1530167590891" ID="ID_363883973" MODIFIED="1533618207490" TEXT=" size_t read(char * to, size_t n)">
<node CREATED="1532525615956" ID="ID_388107036" MODIFIED="1532525621893" TEXT="Reads as many as there are to location &quot;to&quot;, no more than n bytes."/>
</node>
<node CREATED="1530167850713" ID="ID_1343360775" MODIFIED="1533618177697" TEXT="readStrict">
<node CREATED="1530167859433" ID="ID_1730750550" MODIFIED="1530167890163" TEXT="wrapper around read() that check if the number of bytes read is equal to requested number of bytes to read"/>
</node>
<node CREATED="1532521195662" ID="ID_28173546" MODIFIED="1533618179037" TEXT="next">
<node CREATED="1532521199366" ID="ID_1546611261" MODIFIED="1532525408954" TEXT="call nextImpl() to load new data into working_buffer, and reset pos(cursor) to working_buffer.begin(), return true if nextImpl() return true (nextImpl() return true if there is still data to load)"/>
</node>
<node CREATED="1532521292215" ID="ID_1768934918" MODIFIED="1533620649594" TEXT="nextIfAtEnd">
<node CREATED="1532521310372" ID="ID_857982206" MODIFIED="1532521357597" TEXT="check if there is no pending data, then call next(), otherwise do nothing"/>
</node>
<node CREATED="1532525299766" FOLDED="true" ID="ID_1638576490" MODIFIED="1533551799334" TEXT="eof">
<node CREATED="1532525301785" ID="ID_997655162" MODIFIED="1532525425446" TEXT="return true if there is no pending data and next() return false"/>
</node>
<node CREATED="1532525712389" FOLDED="true" ID="ID_575686012" MODIFIED="1533551799334" TEXT="ignore()">
<node CREATED="1532525713479" ID="ID_432195274" MODIFIED="1532528558869" TEXT="++pos if eof return false, otherwise throw (ignore 1 byte)"/>
</node>
<node CREATED="1532528559782" FOLDED="true" ID="ID_644511560" MODIFIED="1533551799334" TEXT="ignore(size_t n)">
<node CREATED="1532528565670" ID="ID_1109743335" MODIFIED="1532528570050" TEXT="ignore n bytes"/>
</node>
<node CREATED="1532528790507" FOLDED="true" ID="ID_1699329690" MODIFIED="1533551799334" TEXT="tryIgnore">
<node CREATED="1532528791549" ID="ID_1519958942" MODIFIED="1532528806869" TEXT="ignore n bytes, return the actual number of bytes ignored"/>
</node>
<node CREATED="1532525495826" FOLDED="true" ID="ID_1331452635" MODIFIED="1533551799334" TEXT="virtual bool nextImpl()">
<node CREATED="1532525498208" ID="ID_1227234529" MODIFIED="1532525513656" TEXT="Read the next data and fill a buffer with it. Return `false` in case of the end, `true` otherwise."/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1891129703" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1529670145906" ID="ID_803983061" LINK="ClickHouse/dbms/src/IO/WriteBuffer.h" MODIFIED="1533619849135" TEXT="WriteBuffer.h">
<node CREATED="1530014296023" ID="ID_470850728" MODIFIED="1533619850678" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1071255495" MODIFIED="1533551799335" TEXT="description">
<node CREATED="1532521618704" ID="ID_586541329" MODIFIED="1532521638138" TEXT="provides interface for different types of write buffer"/>
</node>
<node CREATED="1530013560221" ID="ID_1801949622" MODIFIED="1530013562255" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_1589095439" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_1092800701" MODIFIED="1533620660936" TEXT="functions">
<node CREATED="1532521195662" ID="ID_1705190328" MODIFIED="1533620663284" TEXT="next">
<node CREATED="1532521199366" ID="ID_297533077" MODIFIED="1532521285945" TEXT="call nextImpl() to flush working_buffer(write working_buffer to some other buffer), and reset pos(cursor) to working_buffer.begin()"/>
</node>
<node CREATED="1532521292215" ID="ID_657781464" MODIFIED="1533620665120" TEXT="nextIfAtEnd">
<node CREATED="1532521310372" ID="ID_933955964" MODIFIED="1532521357597" TEXT="check if there is no pending data, then call next(), otherwise do nothing"/>
</node>
<node CREATED="1532521440009" FOLDED="true" ID="ID_191323361" MODIFIED="1533551799335" TEXT="write(const char * from, size_t n)">
<node CREATED="1532521522203" ID="ID_1767771665" MODIFIED="1532521582387" TEXT="write n bytes from location &quot;from&quot;, with auto-flushing if buffer is full during writing"/>
</node>
<node CREATED="1532521325588" FOLDED="true" ID="ID_453170746" MODIFIED="1533551799335" TEXT="write(char x)">
<node CREATED="1532521402954" ID="ID_257105353" MODIFIED="1532521438903" TEXT="call nextIfAtEnd, and write &quot;x&quot; to current cursor position, and advance cursor"/>
</node>
<node CREATED="1532525549904" FOLDED="true" ID="ID_1865734774" MODIFIED="1533551799336" TEXT="virtual void nextImpl()">
<node CREATED="1532525560176" ID="ID_696142365" MODIFIED="1532525560934" TEXT="Write the data in the buffer (from the beginning of the buffer to the current position)."/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1731194838" MODIFIED="1530079245976" TEXT="classes"/>
</node>
<node CREATED="1529916153324" ID="ID_331031703" LINK="ClickHouse/dbms/src/IO/HexWriteBuffer.h" MODIFIED="1533619861478" TEXT="HexWriteBuffer.h">
<node CREATED="1532522056873" ID="ID_977185797" MODIFIED="1533619867971" TEXT="description">
<node CREATED="1532522059664" ID="ID_1236104065" MODIFIED="1532522060251" TEXT="Everything that is written into it, translates to HEX (in capital letters) and writes to another WriteBuffer."/>
</node>
<node CREATED="1532522067624" ID="ID_1977476047" MODIFIED="1533619862788" TEXT="members">
<node CREATED="1532522070112" ID="ID_1165988452" MODIFIED="1533619864266" TEXT="WriteBuffer &amp; ">
<node CREATED="1532522081810" ID="ID_670912980" MODIFIED="1532522090212" TEXT="out : outgoing buffer"/>
</node>
<node CREATED="1532522092827" FOLDED="true" ID="ID_1064412051" MODIFIED="1533551799336" TEXT="char [32]">
<node CREATED="1532522103842" ID="ID_1775701515" MODIFIED="1532522108902" TEXT="buf : ?"/>
</node>
</node>
<node CREATED="1532522121469" FOLDED="true" ID="ID_1795250593" MODIFIED="1533551799337" TEXT="functions">
<node CREATED="1532522123424" FOLDED="true" ID="ID_1828332904" MODIFIED="1533551799336" TEXT="nextImpl">
<node CREATED="1532522124425" ID="ID_1207334774" MODIFIED="1532522172424" TEXT="flush working buffer (in hex format) to &quot;out&quot;"/>
</node>
</node>
</node>
<node CREATED="1529916176475" ID="ID_1408682409" LINK="ClickHouse/dbms/src/IO/HexWriteBuffer.cpp" MODIFIED="1529916211998" TEXT="HexWriteBuffer.cpp"/>
</node>
</node>
<node CREATED="1529673977771" ID="ID_1971812084" LINK="ClickHouse/dbms/src/IO/BufferWithOwnMemory.h" MODIFIED="1533618839773" STYLE="fork" TEXT="BufferWithOwnMemory.h">
<node CREATED="1529675859918" ID="ID_537392837" MODIFIED="1533617778438" STYLE="fork" TEXT="properties">
<node CREATED="1529676056113" ID="ID_1054042038" MODIFIED="1533617779532" TEXT="description">
<node CREATED="1532629323621" ID="ID_99832611" MODIFIED="1532630682377" TEXT="a wrapper around WriteBuffer/ReadBuffer which either use existing_memory as buffer, or create new memory as buffer"/>
</node>
<node CREATED="1532630340048" FOLDED="true" ID="ID_1364634631" MODIFIED="1533619889784" TEXT="members">
<node CREATED="1532630343410" ID="ID_350615896" MODIFIED="1532630349497" TEXT="Memory : memory"/>
</node>
<node CREATED="1532630362267" FOLDED="true" ID="ID_1162663164" MODIFIED="1533620643392" TEXT="functions">
<node CREATED="1532630535495" FOLDED="true" ID="ID_110849461" MODIFIED="1533551799338" TEXT=" BufferWithOwnMemory(size_t size = DBMS_DEFAULT_BUFFER_SIZE, char * existing_memory = nullptr, size_t alignment = 0)">
<node CREATED="1532630537686" ID="ID_432504214" MODIFIED="1532630618434" TEXT="check if there is existing_memory, then its Base (either WriteBuffer or ReadBuffer will use that as their respective buffer, otherwise use Memory ctor to construct new memory and use it as buffer"/>
</node>
</node>
<node CREATED="1532629409724" FOLDED="true" ID="ID_677263668" MODIFIED="1532630278099" TEXT="classes">
<node CREATED="1532629413403" FOLDED="true" ID="ID_397816440" MODIFIED="1533551799340" TEXT="Memory">
<node CREATED="1532629422209" ID="ID_1392871202" MODIFIED="1532630268811" TEXT="A vector like class that allocates/deallocates a chunk of memory (i.e. it stores a few pointers to represent a chunk of memory)"/>
<node CREATED="1532629444536" FOLDED="true" ID="ID_1768534462" MODIFIED="1533551799339" TEXT="members">
<node CREATED="1532629446490" FOLDED="true" ID="ID_1269791473" MODIFIED="1533551799338" TEXT="size_t">
<node CREATED="1532629458289" ID="ID_1067149524" MODIFIED="1532629475165" TEXT="m_capacity :"/>
</node>
<node CREATED="1532629450348" FOLDED="true" ID="ID_3120771" MODIFIED="1533551799338" TEXT="size_t">
<node CREATED="1532629466519" ID="ID_228485291" MODIFIED="1532629472563" TEXT="m_size :"/>
</node>
<node CREATED="1532629452362" FOLDED="true" ID="ID_1992114392" MODIFIED="1533551799338" TEXT="char *">
<node CREATED="1532629476570" ID="ID_1592182625" MODIFIED="1532629490376" TEXT="m_data : "/>
</node>
<node CREATED="1532629456298" FOLDED="true" ID="ID_240495245" MODIFIED="1533551799339" TEXT="size_t">
<node CREATED="1532629483203" ID="ID_1721671680" MODIFIED="1532629488284" TEXT="m_alignment : "/>
</node>
</node>
<node CREATED="1532629776240" FOLDED="true" ID="ID_1548885269" MODIFIED="1533551799339" TEXT="functions">
<node CREATED="1532629778814" FOLDED="true" ID="ID_1248578703" MODIFIED="1533551799339" TEXT="static size_t align(const size_t value, const size_t alignment)">
<node CREATED="1532629779975" ID="ID_1704051206" MODIFIED="1532629823072" TEXT="return a value in accordance with alignemnt"/>
</node>
<node CREATED="1532630173562" FOLDED="true" ID="ID_50321614" MODIFIED="1533551799339" TEXT="alloc">
<node CREATED="1532630181773" ID="ID_523484951" MODIFIED="1532630225039" TEXT="calls Allocator::alloc to allocate memory according to the current value of members"/>
</node>
<node CREATED="1532630226593" FOLDED="true" ID="ID_1577244668" MODIFIED="1533551799339" TEXT="resize">
<node CREATED="1532630231811" ID="ID_1685543539" MODIFIED="1532630249914" TEXT="like how std::vector resize memory"/>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1529676050603" ID="ID_811431551" MODIFIED="1533617726459" TEXT="BufferWithOwnMemory&lt;WriteBuffer&gt;">
<node CREATED="1533620168152" ID="ID_390143095" LINK="ClickHouse/dbms/src/IO/CompressedWriteBuffer.h" MODIFIED="1533620176997" TEXT="CompressedWriteBuffer.h">
<node CREATED="1533873394019" ID="ID_407833194" MODIFIED="1533873396848" TEXT="description">
<node CREATED="1533873397337" ID="ID_1381474598" MODIFIED="1533875643619" TEXT="write to &quot;out&quot; buffer with content being compressed"/>
</node>
<node CREATED="1533875378682" ID="ID_12794598" MODIFIED="1533875464292" TEXT="members">
<node CREATED="1533875465140" ID="ID_1219798457" MODIFIED="1533875466546" TEXT=" WriteBuffer &amp;">
<node CREATED="1533875470720" ID="ID_1304593507" MODIFIED="1533875471284" TEXT="out"/>
</node>
</node>
</node>
<node CREATED="1533620170767" ID="ID_742569148" LINK="ClickHouse/dbms/src/IO/CompressedReadBufferFromFile.cpp" MODIFIED="1533620181940" TEXT="CompressedWriteBuffer.cpp"/>
<node CREATED="1529676152003" ID="ID_1050550929" LINK="ClickHouse/dbms/src/IO/WriteBufferFromFileBase.h" MODIFIED="1533617727598" TEXT="WriteBufferFromFileBase.h">
<node CREATED="1532630988616" ID="ID_536401519" MODIFIED="1533617766653" TEXT="properties">
<node CREATED="1532633983475" ID="ID_91244111" MODIFIED="1533617767777" TEXT="description">
<node CREATED="1532634059522" ID="ID_421577533" MODIFIED="1532634060136" TEXT="provide basic interface for write to file"/>
</node>
<node CREATED="1532630992498" ID="ID_1951707397" MODIFIED="1532630996314" TEXT="members"/>
<node CREATED="1532630997829" FOLDED="true" ID="ID_851344070" MODIFIED="1533620630545" TEXT="functions">
<node CREATED="1532631057336" FOLDED="true" ID="ID_1384591365" MODIFIED="1533551799340" TEXT="off_t seek(off_t off, int whence = SEEK_SET)">
<node CREATED="1532631069238" ID="ID_1827866572" MODIFIED="1532631073794" TEXT="calls doSeek"/>
</node>
<node CREATED="1532631074531" FOLDED="true" ID="ID_1751966359" MODIFIED="1533551799340" TEXT="void truncate(off_t length = 0)">
<node CREATED="1532631080146" ID="ID_732650936" MODIFIED="1532631083643" TEXT="calls doTruncate"/>
</node>
<node CREATED="1532631001246" ID="ID_640484866" MODIFIED="1532631020348" TEXT="virtual off_t getPositionInFile() = 0;"/>
<node CREATED="1532631003220" ID="ID_1443628888" MODIFIED="1532631022745" TEXT="virtual void sync() = 0;"/>
<node CREATED="1532631010350" ID="ID_403008406" MODIFIED="1532631015237" TEXT="virtual std::string getFileName() const = 0;"/>
<node CREATED="1532631027812" ID="ID_1661499949" MODIFIED="1532631028221" TEXT="virtual int getFD() const = 0;"/>
<node CREATED="1532631039571" ID="ID_1439028192" MODIFIED="1532631040688" TEXT="virtual off_t doSeek(off_t off, int whence) = 0;"/>
<node CREATED="1532631052818" ID="ID_1781402508" MODIFIED="1532631053876" TEXT="virtual void doTruncate(off_t length) = 0;"/>
</node>
</node>
<node CREATED="1529740218472" ID="ID_498212773" LINK="ClickHouse/dbms/src/IO/WriteBufferFromFileDescriptor.h" MODIFIED="1533617728817" TEXT="WriteBufferFromFileDescriptor.h">
<node CREATED="1532631254036" ID="ID_722658953" MODIFIED="1533617729862" TEXT="properties">
<node CREATED="1532634010276" ID="ID_1673455927" MODIFIED="1533617769728" TEXT="description">
<node CREATED="1532634047772" ID="ID_548295880" MODIFIED="1532634048147" TEXT="implement interface and include file descriptor"/>
</node>
<node CREATED="1532631257085" ID="ID_1172955444" MODIFIED="1533617731002" TEXT="members">
<node CREATED="1532631261349" ID="ID_746013261" MODIFIED="1532631329115" TEXT="int : fd"/>
</node>
<node CREATED="1532632937614" FOLDED="true" ID="ID_1508004961" MODIFIED="1533551799340" TEXT="concepts">
<node CREATED="1532632940437" ID="ID_682527883" LINK="http://man7.org/linux/man-pages/man2/lseek.2.html" MODIFIED="1532632965171" TEXT="lseek"/>
<node CREATED="1532633082345" ID="ID_1556565243" LINK="https://linux.die.net/man/2/ftruncate" MODIFIED="1532633086488" TEXT="ftrucate"/>
</node>
<node CREATED="1532631316977" FOLDED="true" ID="ID_1912417026" MODIFIED="1533620633777" TEXT="functions">
<node CREATED="1532631318951" FOLDED="true" ID="ID_1712512137" MODIFIED="1533551799341" TEXT="setFD">
<node CREATED="1532631329977" ID="ID_1423700621" MODIFIED="1532631332798" TEXT="set fd to rhs"/>
</node>
<node CREATED="1532631320780" FOLDED="true" ID="ID_1241465374" MODIFIED="1533551799341" TEXT="getFD">
<node CREATED="1532631323343" ID="ID_1832020419" MODIFIED="1532631325450" TEXT="return fd"/>
</node>
<node CREATED="1532632731881" FOLDED="true" ID="ID_151726977" MODIFIED="1533551799341" TEXT="nextImpl">
<node CREATED="1532632737554" ID="ID_1602601976" MODIFIED="1532632778623" TEXT="write content in the working_buffer to fd with syscall write"/>
</node>
<node CREATED="1532633204424" FOLDED="true" ID="ID_1774453775" MODIFIED="1533551799341" TEXT="getPositionInFile">
<node CREATED="1532633205407" ID="ID_1871257869" MODIFIED="1532633210235" TEXT="return current offset"/>
</node>
<node CREATED="1532633362460" FOLDED="true" ID="ID_1530861508" MODIFIED="1533551799341" TEXT="sync">
<node CREATED="1532633363526" ID="ID_1916008889" MODIFIED="1532633884942">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      1. calls next() to flush any content that's still in the buffer
    </p>
    <p>
      2. then call fsync to request OS to sync data with disk
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1532632930741" FOLDED="true" ID="ID_552495442" MODIFIED="1533551799341" TEXT="doSeek">
<node CREATED="1532632967579" ID="ID_104772629" MODIFIED="1532632974004" TEXT="calls lseek with fd"/>
</node>
<node CREATED="1532633088295" FOLDED="true" ID="ID_1332030476" MODIFIED="1533551799341" TEXT="doTruncate">
<node CREATED="1532633093587" ID="ID_980631062" MODIFIED="1532633097921" TEXT="calls ftruncate"/>
</node>
</node>
</node>
<node CREATED="1529740270704" ID="ID_887334422" LINK="ClickHouse/dbms/src/IO/WriteBufferFromFile.h" MODIFIED="1533617734906" TEXT="WriteBufferFromFile.h">
<node CREATED="1532633952740" ID="ID_1340109077" MODIFIED="1533617735979" TEXT="properties">
<node CREATED="1532633956142" ID="ID_1497096724" MODIFIED="1533617771625" TEXT="description">
<node CREATED="1532634037617" ID="ID_1991611211" MODIFIED="1532634075661" TEXT="a buffer to write to file"/>
</node>
<node CREATED="1532634076996" ID="ID_1935580214" MODIFIED="1532634079848" TEXT="members"/>
<node CREATED="1532634080289" FOLDED="true" ID="ID_1824890422" MODIFIED="1533620636265" TEXT="functions">
<node CREATED="1532634082780" FOLDED="true" ID="ID_1822506120" MODIFIED="1533551799342" TEXT="ctor">
<node CREATED="1532634097326" ID="ID_89563780" MODIFIED="1532634112991" TEXT="open a file with file path to get a file descriptor"/>
</node>
<node CREATED="1532634114038" FOLDED="true" ID="ID_586750966" MODIFIED="1533551799342" TEXT="close">
<node CREATED="1532634124865" ID="ID_1750662700" MODIFIED="1532634130762" TEXT="close file descriptor"/>
</node>
</node>
</node>
</node>
<node CREATED="1529740275778" ID="ID_1139805568" LINK="ClickHouse/dbms/src/IO/WriteBufferFromFile.cpp" MODIFIED="1529740660096" TEXT="WriteBufferFromFile.cpp"/>
</node>
<node CREATED="1529740224276" ID="ID_524893374" LINK="ClickHouse/dbms/src/IO/WriteBufferFromFileDescriptor.cpp" MODIFIED="1529740638935" TEXT="WriteBufferFromFileDescriptor.cpp"/>
</node>
<node CREATED="1529676181117" ID="ID_912904860" LINK="ClickHouse/dbms/src/IO/WriteBufferFromFileBase.cpp" MODIFIED="1529740616985" TEXT="WriteBufferFromFileBase.cpp"/>
</node>
<node CREATED="1529676124301" ID="ID_1605859652" MODIFIED="1533620226980" TEXT="BufferWithOwnMemory&lt;ReadBuffer&gt;">
<node CREATED="1533618391900" ID="ID_1103827109" LINK="ClickHouse/dbms/src/IO/CompressedReadBuffer.h" MODIFIED="1533618569597" TEXT="CompressedReadBuffer.h">
<node CREATED="1533873394019" ID="ID_392230754" MODIFIED="1533873396848" TEXT="description">
<node CREATED="1533873397337" ID="ID_1754417500" MODIFIED="1533875358146" TEXT="read compressed data into &quot;compressed_in&quot; (for instance, a ReadFromFileBuffer), and &quot;decompress&quot; and output to some given address"/>
</node>
<node CREATED="1533873458591" ID="ID_220302677" MODIFIED="1533873461351" TEXT="members">
<node CREATED="1533873461704" ID="ID_1548411723" MODIFIED="1533873462302" TEXT="ReadBuffer *">
<node CREATED="1533873463761" ID="ID_953087474" MODIFIED="1533873482099" TEXT="compressed_in"/>
</node>
</node>
</node>
<node CREATED="1533618473405" ID="ID_1339346572" LINK="ClickHouse/dbms/src/IO/CompressedReadBuffer.cpp" MODIFIED="1533618571948" TEXT="CompressedReadBuffer.cpp"/>
<node CREATED="1532634167303" ID="ID_1596613388" LINK="ClickHouse/dbms/src/IO/ReadBufferFromFileBase.h" MODIFIED="1533617814914" TEXT="ReadBufferFromFileBase.h">
<node CREATED="1532634217993" ID="ID_1925008695" MODIFIED="1533617716775" TEXT="properties">
<node CREATED="1532634416873" ID="ID_739939608" MODIFIED="1532634418489" TEXT="description"/>
<node CREATED="1532634418882" ID="ID_601513953" MODIFIED="1533617718290" TEXT="members">
<node CREATED="1532634470257" FOLDED="true" ID="ID_670431537" MODIFIED="1533551799344" TEXT="function&lt;void(ProfileInfo)&gt;">
<node CREATED="1532634573259" ID="ID_95140756" MODIFIED="1532634579988" TEXT="profile_callback : "/>
</node>
<node CREATED="1532634580747" FOLDED="true" ID="ID_139202468" MODIFIED="1533551799344" TEXT="clockid_t">
<node CREATED="1532634585988" ID="ID_26840128" MODIFIED="1532634596527" TEXT="clock_type : "/>
</node>
</node>
<node CREATED="1532634421197" ID="ID_169898065" MODIFIED="1533618135975" TEXT="functions">
<node CREATED="1532634423153" FOLDED="true" ID="ID_515124501" MODIFIED="1533551799344" TEXT="off_t seek(off_t off, int whence = SEEK_SET)">
<node CREATED="1532634425079" ID="ID_1380854474" MODIFIED="1532634428599" TEXT="calls doSeek"/>
</node>
<node CREATED="1532634429470" ID="ID_526747193" MODIFIED="1532634448532" TEXT="virtual off_t getPositionInFile() = 0"/>
<node CREATED="1532634453478" ID="ID_929544560" MODIFIED="1532634454075" TEXT="virtual std::string getFileName() const = 0"/>
<node CREATED="1532634458910" ID="ID_843105045" MODIFIED="1532634459203" TEXT="virtual int getFD() const = 0;"/>
<node CREATED="1532634465940" ID="ID_1535639546" MODIFIED="1532634466282" TEXT="virtual off_t doSeek(off_t off, int whence) = 0"/>
<node CREATED="1532634606824" ID="ID_1309524921" MODIFIED="1532634607540" TEXT="setProfileCallback"/>
</node>
<node CREATED="1532634472577" FOLDED="true" ID="ID_1724865383" MODIFIED="1533617915087" TEXT="classes">
<node CREATED="1532634479059" FOLDED="true" ID="ID_163067373" MODIFIED="1533551799345" TEXT="ProfileInfo">
<node CREATED="1532634480216" FOLDED="true" ID="ID_403012011" MODIFIED="1533551799344" TEXT="members">
<node CREATED="1532634483409" ID="ID_1069740296" MODIFIED="1532634507365" TEXT="size_t : bytes_requested"/>
<node CREATED="1532634496888" ID="ID_1592407152" MODIFIED="1532634499804" TEXT="size_t : bytes_read"/>
<node CREATED="1532634508157" ID="ID_1407256146" MODIFIED="1532634510893" TEXT="size_t : nanoseconds"/>
</node>
</node>
</node>
</node>
<node CREATED="1532634223969" ID="ID_1320518439" LINK="ClickHouse/dbms/src/IO/ReadBufferFromFileDescriptor.h" MODIFIED="1533617634267" TEXT="ReadBufferFromFileDescriptor.h">
<node CREATED="1532634264615" ID="ID_1659446529" MODIFIED="1533617650658" TEXT="properties">
<node CREATED="1532639543734" ID="ID_685688008" MODIFIED="1533617651761" TEXT="description">
<node CREATED="1532639547027" ID="ID_1102103296" MODIFIED="1532639547497" TEXT="implement interface and include file descriptor "/>
</node>
<node CREATED="1532634757095" ID="ID_1803040631" MODIFIED="1533617655765" TEXT="members">
<node CREATED="1532634759386" ID="ID_179416623" MODIFIED="1533617659738" TEXT="int">
<node CREATED="1532634761454" ID="ID_1505940148" MODIFIED="1532634764856" TEXT="fd :"/>
</node>
<node CREATED="1532634765680" ID="ID_1053315573" MODIFIED="1533617660393" TEXT="off_t">
<node CREATED="1532634772744" ID="ID_382092075" MODIFIED="1532634780082" TEXT="pos_in_file : what offset in file corresponds to working_buffer.end()."/>
</node>
</node>
<node CREATED="1532635460804" ID="ID_693859124" MODIFIED="1533617661723" TEXT="concepts">
<node CREATED="1532635463296" ID="ID_1072556552" LINK="https://en.cppreference.com/w/cpp/utility/optional" MODIFIED="1532635471334" TEXT="std::optional"/>
</node>
<node CREATED="1532634827567" ID="ID_1032754448" MODIFIED="1533617665602" TEXT="functions">
<node CREATED="1532634829349" FOLDED="true" ID="ID_1540454869" MODIFIED="1533551799345" TEXT="getFD">
<node CREATED="1532634838090" ID="ID_700752348" MODIFIED="1532634839384" TEXT="return fd"/>
</node>
<node CREATED="1532634840088" FOLDED="true" ID="ID_756335533" MODIFIED="1533551799346" TEXT="getPositionInFile">
<node CREATED="1532634846186" ID="ID_1568850056" MODIFIED="1532634917385" TEXT="return what offset in file corresponds to pos in buffer"/>
</node>
<node CREATED="1532636102887" ID="ID_632831932" MODIFIED="1533617826163" TEXT="nextImpl">
<node CREATED="1532636107663" ID="ID_1861723317" MODIFIED="1532636186743" TEXT="read as many bytes as the size of internal_buffer from fd to internal_buffer.begin() ( =working_buffer.begin()), and resize working_buffer to the number of bytes read."/>
</node>
<node CREATED="1532638275007" FOLDED="true" ID="ID_1587403761" MODIFIED="1533618125776" TEXT="doSeek">
<node CREATED="1532638277246" ID="ID_720950631" MODIFIED="1532638388396" TEXT="clever code with low readability, essentially what it does is just do SEEK_SET or SEEK_CUR with consideration of cases where seeked position is still in buffer. It would be much clearer if it just follow the more direct logic"/>
</node>
<node CREATED="1532639489129" FOLDED="true" ID="ID_264429482" MODIFIED="1533551799346" TEXT="poll">
<node CREATED="1532639491046" ID="ID_1117406486" MODIFIED="1532639509221" TEXT="use &quot;select&quot; to check if fd is ready to read from"/>
</node>
</node>
</node>
<node CREATED="1532634270008" ID="ID_195099617" LINK="ClickHouse/dbms/src/IO/ReadBufferFromFile.h" MODIFIED="1533617639498" TEXT="ReadBufferFromFile.h">
<node CREATED="1532633952740" ID="ID_1582790170" MODIFIED="1533617640444" TEXT="properties">
<node CREATED="1532633956142" ID="ID_675011028" MODIFIED="1533617641970" TEXT="description">
<node CREATED="1532634037617" ID="ID_250177282" MODIFIED="1532636334615" TEXT="a buffer to read from file"/>
</node>
<node CREATED="1532634076996" ID="ID_454491959" MODIFIED="1532634079848" TEXT="members"/>
<node CREATED="1532634080289" ID="ID_1196676207" MODIFIED="1533617643587" TEXT="functions">
<node CREATED="1532634082780" ID="ID_1701090666" MODIFIED="1533617644946" TEXT="ctor">
<node CREATED="1532634097326" ID="ID_369134960" MODIFIED="1532634112991" TEXT="open a file with file path to get a file descriptor"/>
</node>
<node CREATED="1532634114038" ID="ID_1530051168" MODIFIED="1533617645569" TEXT="close">
<node CREATED="1532634124865" ID="ID_77040350" MODIFIED="1532634130762" TEXT="close file descriptor"/>
</node>
</node>
</node>
</node>
<node CREATED="1532634272242" ID="ID_1340749612" LINK="ClickHouse/dbms/src/IO/ReadBufferFromFile.cpp" MODIFIED="1532634289209" TEXT="ReadBufferFromFile.cpp"/>
</node>
<node CREATED="1532634236339" ID="ID_702121460" LINK="ClickHouse/dbms/src/IO/ReadBufferFromFileDescriptor.cpp" MODIFIED="1532634250984" TEXT="ReadBufferFromFileDescriptor.cpp"/>
</node>
<node CREATED="1532634175621" ID="ID_808244495" LINK="ClickHouse/dbms/src/IO/ReadBufferFromFileBase.cpp" MODIFIED="1532634216828" TEXT="ReadBufferFromFileBase.cpp"/>
</node>
</node>
<node CREATED="1533618347567" ID="ID_586350804" LINK="ClickHouse/dbms/src/IO/CompressedReadBufferBase.h" MODIFIED="1533618370163" TEXT="CompressedReadBufferBase.h">
<node CREATED="1533618376557" ID="ID_696517752" MODIFIED="1533618390249" TEXT="properties">
<node CREATED="1533618587539" ID="ID_917177767" MODIFIED="1533618589236" TEXT="members">
<node CREATED="1533618589628" ID="ID_428657407" MODIFIED="1533618591097" TEXT="ReadBuffer *">
<node CREATED="1533618591458" ID="ID_1102220370" MODIFIED="1533618597028" TEXT="compressed_in"/>
</node>
<node CREATED="1533618602049" ID="ID_1653014409" MODIFIED="1533618602415" TEXT="PODArray&lt;char&gt;">
<node CREATED="1533618605678" ID="ID_360446227" MODIFIED="1533618606211" TEXT="own_compressed_buffer"/>
</node>
<node CREATED="1533618614831" ID="ID_1506331248" MODIFIED="1533618616866" TEXT="char *">
<node CREATED="1533618618000" ID="ID_765414664" MODIFIED="1533618619851" TEXT="compressed_buffer = nullptr : "/>
</node>
<node CREATED="1533618628321" ID="ID_1247963052" MODIFIED="1533618629432" TEXT="bool">
<node CREATED="1533618630007" ID="ID_1344770673" MODIFIED="1533618630334" TEXT="disable_checksum = false"/>
</node>
<node CREATED="1533618636490" ID="ID_907702435" MODIFIED="1533618636873" TEXT="LZ4::PerformanceStatistics">
<node CREATED="1533618637465" ID="ID_1800462277" MODIFIED="1533618639605" TEXT="lz4_stat"/>
</node>
</node>
</node>
</node>
<node CREATED="1533618354265" ID="ID_31522515" LINK="ClickHouse/dbms/src/IO/CompressedReadBufferBase.cpp" MODIFIED="1533618373499" TEXT="CompressedReadBufferBase.cpp"/>
<node CREATED="1529653338533" FOLDED="true" ID="ID_890941915" LINK="ClickHouse/dbms/src/IO/Progress.h" MODIFIED="1533616736147" TEXT="Progress.h">
<node CREATED="1530242892327" FOLDED="true" ID="ID_1498746523" MODIFIED="1533616736147" TEXT="ProgressValues">
<node CREATED="1530014296023" FOLDED="true" ID="ID_1513818567" MODIFIED="1530857901936" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1758541056" MODIFIED="1530912173945" TEXT="description">
<node CREATED="1530243428518" ID="ID_1312380186" MODIFIED="1530243447883" TEXT="used as output format of Progress"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_279984543" MODIFIED="1530912173947" TEXT="members">
<node CREATED="1530242935141" FOLDED="true" ID="ID_36275354" MODIFIED="1530912173945" TEXT="size_t">
<node CREATED="1530242940221" FOLDED="true" ID="ID_71764547" MODIFIED="1530912173945" TEXT="rows:">
<node CREATED="1530243450500" ID="ID_232728153" LINK="#ID_456818137" MODIFIED="1530243463728" TEXT="see Progess rows"/>
</node>
</node>
<node CREATED="1530242937240" FOLDED="true" ID="ID_1005998142" MODIFIED="1530912173946" TEXT="size_t">
<node CREATED="1530242947048" FOLDED="true" ID="ID_250142348" MODIFIED="1530912173946" TEXT="bytes:">
<node CREATED="1530243469707" ID="ID_1888405603" LINK="#ID_1399866328" MODIFIED="1530243483306" TEXT="see Progress bytes"/>
</node>
</node>
<node CREATED="1530242938358" FOLDED="true" ID="ID_1606982287" MODIFIED="1530912173946" TEXT="size_t">
<node CREATED="1530242951563" FOLDED="true" ID="ID_101718636" MODIFIED="1530912173946" TEXT="total_rows:">
<node CREATED="1530243485357" ID="ID_477169664" LINK="#ID_636261555" MODIFIED="1530243495071" TEXT="see Progress total_rows"/>
</node>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1438688677" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1000842217" MODIFIED="1530912173948" TEXT="functions">
<node CREATED="1530250700890" FOLDED="true" ID="ID_1521199573" MODIFIED="1530912173947" TEXT="read">
<node CREATED="1530250717709" ID="ID_1905541668" MODIFIED="1530250754392" TEXT="read into a ProgressValues from an input stream"/>
</node>
<node CREATED="1530250708515" FOLDED="true" ID="ID_1877673318" MODIFIED="1530912173947" TEXT="write">
<node CREATED="1530250755430" ID="ID_1398450510" MODIFIED="1530250781433" TEXT="write to an output stream"/>
</node>
<node CREATED="1530250710296" FOLDED="true" ID="ID_1280226387" MODIFIED="1530912173947" TEXT="writeJSON">
<node CREATED="1530250782966" ID="ID_908481299" MODIFIED="1530250846953" TEXT="write to an output stream in JSON format"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1373633036" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530242892327" FOLDED="true" ID="ID_290322197" MODIFIED="1533616736147" TEXT="Progress">
<node CREATED="1530014296023" FOLDED="true" ID="ID_367126938" MODIFIED="1530857897873" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_9706026" MODIFIED="1530912173948" TEXT="description">
<node CREATED="1530247463226" ID="ID_1612959220" MODIFIED="1530247495711" TEXT="used to describe the progress status on some query execution"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1461433461" MODIFIED="1530912173949" TEXT="members">
<node CREATED="1530243341837" FOLDED="true" ID="ID_967174218" MODIFIED="1530912173949" TEXT="std::atomic&lt;size_t&gt;">
<node CREATED="1530243371800" ID="ID_456818137" MODIFIED="1530243650534" TEXT="rows: number of processed rows"/>
</node>
<node CREATED="1530243364539" FOLDED="true" ID="ID_1320977755" MODIFIED="1530912173949" TEXT="std::atomic&lt;size_t&gt;">
<node CREATED="1530243374338" ID="ID_1399866328" MODIFIED="1530243673256" TEXT="bytes: number of (uncompressed) processed bytes"/>
</node>
<node CREATED="1530243366360" FOLDED="true" ID="ID_365438238" MODIFIED="1530912173949" TEXT="std::atomic&lt;size_t&gt;">
<node CREATED="1530243380282" ID="ID_636261555" MODIFIED="1530243694438" TEXT="total_rows: estimate of total number of rows must be processed, used for progress bar rendering"/>
</node>
</node>
<node CREATED="1530013563312" FOLDED="true" ID="ID_201844839" MODIFIED="1530912173950" TEXT="concepts">
<node CREATED="1530244092866" ID="ID_1148316500" LINK="http://www.cplusplus.com/reference/atomic/atomic/" MODIFIED="1530244103640" TEXT="atomic&lt;T&gt;"/>
<node CREATED="1530244104904" ID="ID_307978056" LINK="https://blog.csdn.net/cszhouwei/article/details/11730559" MODIFIED="1530246957670" TEXT="memory_order_relaxed"/>
</node>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1946227497" MODIFIED="1530912173951" TEXT="functions">
<node CREATED="1530247502739" FOLDED="true" ID="ID_1059193870" MODIFIED="1530912173950" TEXT="read /write/ writeJSON">
<node CREATED="1530250856528" ID="ID_1419193857" LINK="#ID_1000842217" MODIFIED="1530250883158" TEXT="wrapper around ProgressValues functions"/>
</node>
<node CREATED="1530247533151" FOLDED="true" ID="ID_674293927" MODIFIED="1530912173950" TEXT="incrementPiecewiseAtomically">
<node CREATED="1530247853457" ID="ID_1525636598" MODIFIED="1530247873331" TEXT="increase current progress values by some amount"/>
</node>
<node CREATED="1530247548283" FOLDED="true" ID="ID_1433642317" MODIFIED="1530912173950" TEXT="reset">
<node CREATED="1530247874417" ID="ID_1172320328" MODIFIED="1530247882476" TEXT="reset all progress values to 0"/>
</node>
<node CREATED="1530247557645" FOLDED="true" ID="ID_932583190" MODIFIED="1530912173951" TEXT="getValues">
<node CREATED="1530247884094" ID="ID_1328999003" MODIFIED="1530247901171" TEXT="return progress values in an ProgressValues object"/>
</node>
<node CREATED="1530247586054" FOLDED="true" ID="ID_1701553919" MODIFIED="1530912173951" TEXT="fetchAndResetPiecewiseAtomically">
<node CREATED="1530247902569" ID="ID_85062971" MODIFIED="1530247919027" TEXT="return progress values in an ProgressValues object and reset all values to 0"/>
</node>
<node CREATED="1530247920520" FOLDED="true" ID="ID_735756418" MODIFIED="1530912173951" TEXT="operator=">
<node CREATED="1530247932215" ID="ID_569742309" MODIFIED="1530247934682" TEXT="normal assignment"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1751503084" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
</node>
<node CREATED="1530165196506" ID="ID_336203382" LINK="ClickHouse/dbms/src/IO/Progress.cpp" MODIFIED="1530171452659" TEXT="Progress.cpp"/>
<node CREATED="1530167288351" FOLDED="true" ID="ID_1497812007" LINK="ClickHouse/dbms/src/IO/ReadHelpers.h" MODIFIED="1533616736148" TEXT="ReadHelpers.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_747728131" MODIFIED="1533616736148" TEXT="properties">
<node CREATED="1530013557169" ID="ID_348292929" MODIFIED="1530081562328" TEXT="description"/>
<node CREATED="1530013560221" ID="ID_752521660" MODIFIED="1530013562255" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_1775935433" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_144772952" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1374954539" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530167312591" ID="ID_935186441" LINK="ClickHouse/dbms/src/IO/ReadHelpers.cpp" MODIFIED="1530167353148" TEXT="ReadHelpers.cpp"/>
<node CREATED="1530165185636" FOLDED="true" ID="ID_513100891" LINK="ClickHouse/dbms/src/IO/VarInt.h" MODIFIED="1533616736149" TEXT="VarInt.h">
<node CREATED="1530165348555" FOLDED="true" ID="ID_98504328" MODIFIED="1533616736149" TEXT="properties">
<node CREATED="1530165351799" FOLDED="true" ID="ID_878703041" MODIFIED="1530912173954" TEXT="functions">
<node CREATED="1530166368651" FOLDED="true" ID="ID_1744718195" MODIFIED="1530912173953" TEXT="readVarUInt">
<node CREATED="1530166379502" ID="ID_1360925363" LINK="#ID_245286104" MODIFIED="1530170934848" TEXT="see writeVarUInt"/>
</node>
<node CREATED="1530165354789" FOLDED="true" ID="ID_245286104" MODIFIED="1530912173953" TEXT="writeVarUInt">
<node CREATED="1530166388362" ID="ID_1928757403" MODIFIED="1530166578489" TEXT="write Unit64(8 byte) to an output stream(disk/network), it supports variable length up to 2^63-1. It writes 7bits as a char(8bits) at a time, which is saying that it uses 9 bytes (9 * 7 =63) to stores 8 bytes. Why though?"/>
</node>
</node>
</node>
</node>
<node CREATED="1530167315198" FOLDED="true" ID="ID_238750796" LINK="ClickHouse/dbms/src/IO/WriteHelpers.h" MODIFIED="1533616736150" TEXT="WriteHelpers.h">
<node CREATED="1530165348555" FOLDED="true" ID="ID_965797323" MODIFIED="1533616736149" TEXT="properties">
<node CREATED="1530165351799" FOLDED="true" ID="ID_199629033" MODIFIED="1530912173955" TEXT="functions">
<node CREATED="1530169583508" FOLDED="true" ID="ID_1213032067" MODIFIED="1530912173954">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      template &lt;char c&gt;
    </p>
    <p>
      void writeAnyEscapedString(const char * begin, const char * end, WriteBuffer &amp; buf)
    </p>
  </body>
</html></richcontent>
<node CREATED="1530170886986" ID="ID_1611171567" MODIFIED="1530170903601" TEXT="write all special symbols to explicitly escaped form"/>
</node>
<node CREATED="1530169638775" FOLDED="true" ID="ID_1415222597" MODIFIED="1530912173955">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      template &lt;char c&gt;
    </p>
    <p>
      void writeAnyEscapedString(const String &amp; s, WriteBuffer &amp; buf)
    </p>
  </body>
</html></richcontent>
<node CREATED="1530170686518" ID="ID_1655851945" LINK="#ID_1213032067" MODIFIED="1530170825593" TEXT="direct calls to writeAnyEscapedString&lt;c&apos;&gt;(const char * begin, const char * end, WriteBuffer &amp; buf)"/>
</node>
<node CREATED="1530169646900" FOLDED="true" ID="ID_1220237594" MODIFIED="1530912173955" STYLE="fork" TEXT="writeEscapedString">
<node CREATED="1530170686518" ID="ID_1126106879" LINK="#ID_1415222597" MODIFIED="1530170764967" TEXT="direct calls to writeAnyEscapedString&lt;&apos;\&apos;&apos;&gt;(const String &amp; s, WriteBuffer &amp; buf)"/>
</node>
<node CREATED="1530167442526" FOLDED="true" ID="ID_1074156043" MODIFIED="1530912173955" TEXT="writeString">
<node CREATED="1530167452982" ID="ID_1062523520" LINK="#ID_177349437" MODIFIED="1530167623360" TEXT="direct calls to WriteBuffer.write()"/>
</node>
</node>
</node>
</node>
<node CREATED="1530167328335" ID="ID_1145896309" LINK="ClickHouse/dbms/src/IO/WriteHelpers.cpp" MODIFIED="1530167368059" TEXT="WriteHelpers.cpp"/>
</node>
<node CREATED="1530675727043" ID="ID_867668461" MODIFIED="1534140207659" TEXT="Interpreters">
<node CREATED="1530758741492" FOLDED="true" ID="ID_836224412" LINK="ClickHouse/dbms/src/Interpreters/ClientInfo.h" MODIFIED="1533616736151" TEXT="ClientInfo.h">
<node CREATED="1530014350060" FOLDED="true" ID="ID_315114527" MODIFIED="1533616736151" TEXT="properties">
<icon BUILTIN="help"/>
<node CREATED="1530013182602" FOLDED="true" ID="ID_36281909" MODIFIED="1533551799354" TEXT="description">
<node CREATED="1530759085078" ID="ID_1457640627" MODIFIED="1531254362733" TEXT="used to store client information and provide methods for serialization / deserialization of this information"/>
</node>
<node CREATED="1530013202034" FOLDED="true" ID="ID_1484198184" MODIFIED="1533551799356" TEXT="members">
<node CREATED="1530759038764" FOLDED="true" ID="ID_1222775515" MODIFIED="1533551799354" TEXT="QueryKind">
<node CREATED="1530759040291" ID="ID_306720793" MODIFIED="1531253319351" TEXT="query_kind = QueryKind::NO_QUERY : default query kind"/>
</node>
<node CREATED="1531253394683" FOLDED="true" ID="ID_256908219" MODIFIED="1533551799354" TEXT="Interface">
<node CREATED="1531253404899" ID="ID_1470033077" MODIFIED="1531253411309" TEXT="interface = Interface::TCP : default interface"/>
</node>
<node CREATED="1531253320317" FOLDED="true" ID="ID_1452775420" MODIFIED="1533551799354" TEXT="HTTPMethod">
<node CREATED="1531253336748" ID="ID_1478864559" MODIFIED="1531253346304" TEXT="http_method = HTTPMethod::UNKNOWN : default http method"/>
</node>
<node CREATED="1531253417576" FOLDED="true" ID="ID_906098156" MODIFIED="1533551799354" TEXT="String">
<node CREATED="1531253425851" ID="ID_1133554723" MODIFIED="1531253426194" TEXT="current_user"/>
</node>
<node CREATED="1531253426913" FOLDED="true" ID="ID_1934771827" MODIFIED="1533551799354" TEXT="String">
<node CREATED="1531253428733" ID="ID_1083841011" MODIFIED="1531253432325" TEXT="current_query_id"/>
</node>
<node CREATED="1531253440620" FOLDED="true" ID="ID_190704850" MODIFIED="1533551799354" TEXT="Poco::Net::SocketAddress">
<node CREATED="1531253442082" ID="ID_1060682116" MODIFIED="1531253447150" TEXT="current_address"/>
</node>
<node CREATED="1531253447966" FOLDED="true" ID="ID_414154291" MODIFIED="1533551799355" TEXT="String">
<node CREATED="1531253454973" ID="ID_1419777152" MODIFIED="1531253459993" TEXT="current_password"/>
</node>
<node CREATED="1531253818715" FOLDED="true" ID="ID_755586648" MODIFIED="1533551799355" TEXT="String">
<node CREATED="1531253820905" ID="ID_1945113280" MODIFIED="1531253881291" TEXT="initial_user : When query_kind == INITIAL_QUERY, these values are equal to current."/>
</node>
<node CREATED="1531253830208" FOLDED="true" ID="ID_1800800751" MODIFIED="1533551799355" TEXT="String">
<node CREATED="1531253832572" ID="ID_1851502176" MODIFIED="1531253832908" TEXT="initial_query_id"/>
</node>
<node CREATED="1531253837225" FOLDED="true" ID="ID_1200912805" MODIFIED="1533551799355" TEXT="Poco::Net::SocketAddress">
<node CREATED="1531253838511" ID="ID_271571376" MODIFIED="1531253844524" TEXT="initial_address"/>
</node>
<node CREATED="1531253889265" FOLDED="true" ID="ID_1688669616" MODIFIED="1533551799355" TEXT="String">
<node CREATED="1531253890223" ID="ID_1982728312" MODIFIED="1531253891806" TEXT="os_user"/>
</node>
<node CREATED="1531253903092" FOLDED="true" ID="ID_1858081381" MODIFIED="1533551799355" TEXT="String">
<node CREATED="1531253906450" ID="ID_1809301273" MODIFIED="1531253906985" TEXT="client_hostname"/>
</node>
<node CREATED="1531253907704" FOLDED="true" ID="ID_464258166" MODIFIED="1533551799355" TEXT="String">
<node CREATED="1531253910135" ID="ID_1930499390" MODIFIED="1531253912922" TEXT="client_name"/>
</node>
<node CREATED="1531253918458" FOLDED="true" ID="ID_927195498" MODIFIED="1533551799355" TEXT="Uint64">
<node CREATED="1531253922088" ID="ID_1906085846" MODIFIED="1531253922455" TEXT="client_version_major"/>
</node>
<node CREATED="1531253918458" FOLDED="true" ID="ID_1491978545" MODIFIED="1533551799356" TEXT="Uint64">
<node CREATED="1531253922088" ID="ID_1535141140" MODIFIED="1531253936958" TEXT="client_version_minor"/>
</node>
<node CREATED="1531253941198" FOLDED="true" ID="ID_935352844" MODIFIED="1533551799356" TEXT="unsigned">
<node CREATED="1531253943434" ID="ID_1807242585" MODIFIED="1531253943849" TEXT="client_revision"/>
</node>
<node CREATED="1531253950212" FOLDED="true" ID="ID_78555568" MODIFIED="1533551799356" TEXT="String">
<node CREATED="1531253951161" ID="ID_212685695" MODIFIED="1531253955643" TEXT="http_user_agent"/>
</node>
<node CREATED="1531253956385" FOLDED="true" ID="ID_375294920" MODIFIED="1533551799356" TEXT="String">
<node CREATED="1531253960157" ID="ID_441478644" MODIFIED="1531253962326" TEXT="quota_key"/>
</node>
</node>
<node CREATED="1529917903274" ID="ID_94627804" MODIFIED="1530696720037" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1388866109" MODIFIED="1533551799357" TEXT="functions">
<node CREATED="1531254143540" FOLDED="true" ID="ID_902748505" MODIFIED="1533551799356" TEXT="empty">
<node CREATED="1531254144655" ID="ID_1774480043" MODIFIED="1531254170767" STYLE="fork" TEXT="return if query_kind is NO_QUERY"/>
</node>
<node CREATED="1531254178074" FOLDED="true" ID="ID_372955626" MODIFIED="1533551799356" TEXT="write">
<node CREATED="1531254276132" ID="ID_120880522" MODIFIED="1531254287325" TEXT="write information about members"/>
</node>
<node CREATED="1531254179288" FOLDED="true" ID="ID_1649678429" MODIFIED="1533551799356" TEXT="read">
<node CREATED="1531254276132" ID="ID_1228800896" MODIFIED="1531254293943" TEXT="read information about members"/>
</node>
<node CREATED="1531254183257" ID="ID_1719798376" MODIFIED="1531254183535" TEXT="fillOSUserHostNameAndVersionInfo"/>
</node>
<node CREATED="1530014254828" FOLDED="true" ID="ID_1026872555" MODIFIED="1533551799357" TEXT="classes">
<node CREATED="1530758962308" FOLDED="true" ID="ID_555108697" MODIFIED="1533551799357" TEXT="enum class Interface : UInt8">
<node CREATED="1530758973285" ID="ID_86640023" MODIFIED="1530758980431" TEXT="TCP = 1"/>
<node CREATED="1530758985270" ID="ID_306402934" MODIFIED="1530758985972" TEXT="HTTP = 2"/>
</node>
<node CREATED="1530758967445" FOLDED="true" ID="ID_344860064" MODIFIED="1533551799357" TEXT="enum class HTTPMethod : UInt8">
<node CREATED="1530758997386" ID="ID_45002992" MODIFIED="1530758997759" TEXT="UNKNOWN = 0"/>
<node CREATED="1530759001377" MODIFIED="1530759001377" TEXT="GET = 1"/>
<node CREATED="1530759005179" MODIFIED="1530759005179" TEXT="POST = 2"/>
</node>
<node CREATED="1530758971651" FOLDED="true" ID="ID_421230625" MODIFIED="1533551799357" TEXT="enum class QueryKind : UInt8">
<node CREATED="1530759010909" ID="ID_467357578" MODIFIED="1530759013394" TEXT="NO_QUERY = 0"/>
<node CREATED="1530759017928" MODIFIED="1530759017928" TEXT="INITIAL_QUERY = 1"/>
<node CREATED="1530759021084" MODIFIED="1530759021084" TEXT="SECONDARY_QUERY = 2"/>
</node>
</node>
</node>
</node>
<node CREATED="1530758755579" ID="ID_1813331025" LINK="ClickHouse/dbms/src/Interpreters/ClientInfo.cpp" MODIFIED="1530758773206" TEXT="ClientInfo.cpp"/>
<node CREATED="1530675734197" FOLDED="true" ID="ID_1367137625" LINK="ClickHouse/dbms/src/Interpreters/ProcessList.h" MODIFIED="1533616736153" TEXT="ProcessList.h">
<node CREATED="1530675831019" FOLDED="true" ID="ID_1204604674" MODIFIED="1533616736151" TEXT="ProcessInfo">
<node CREATED="1530014332949" FOLDED="true" ID="ID_538291165" MODIFIED="1533551799359" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1669445406" MODIFIED="1533551799358" TEXT="description">
<node CREATED="1530755723629" ID="ID_986836084" MODIFIED="1530755807036" TEXT="used as an output data structure for ProcessListElement"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_549119023" MODIFIED="1533551799359" TEXT="members">
<node CREATED="1530676174673" FOLDED="true" ID="ID_1126425119" MODIFIED="1533551799358" TEXT="String">
<node CREATED="1530676190808" ID="ID_136889843" MODIFIED="1530676193629" TEXT="query"/>
</node>
<node CREATED="1530676194476" FOLDED="true" ID="ID_833573020" MODIFIED="1533551799358" TEXT="double">
<node CREATED="1530676196823" ID="ID_527534209" MODIFIED="1530676201656" TEXT="elapsed_seconds"/>
</node>
<node CREATED="1530676202519" FOLDED="true" ID="ID_1153556573" MODIFIED="1533551799358" TEXT="size_t">
<node CREATED="1530676206039" ID="ID_1160504328" MODIFIED="1530676208376" TEXT="read_rows"/>
</node>
<node CREATED="1530676209230" FOLDED="true" ID="ID_792816852" MODIFIED="1533551799358" TEXT="size_t">
<node CREATED="1530676210380" ID="ID_1530082735" MODIFIED="1530676214743" TEXT="read_bytes"/>
</node>
<node CREATED="1530676215631" FOLDED="true" ID="ID_1507623211" MODIFIED="1533551799358" TEXT="size_t">
<node CREATED="1530676217900" ID="ID_225410710" MODIFIED="1530676220739" TEXT="total_rows"/>
</node>
<node CREATED="1530676222056" FOLDED="true" ID="ID_82882888" MODIFIED="1533551799359" TEXT="size_t">
<node CREATED="1530676225862" ID="ID_1277056838" MODIFIED="1530676228424" TEXT="written_rows"/>
</node>
<node CREATED="1530676229695" FOLDED="true" ID="ID_1572156792" MODIFIED="1533551799359" TEXT="size_t">
<node CREATED="1530676231116" ID="ID_1726973709" MODIFIED="1530676234130" TEXT="written_bytes"/>
</node>
<node CREATED="1530676238650" FOLDED="true" ID="ID_1903680058" MODIFIED="1533551799359" TEXT="Int64">
<node CREATED="1530676245146" ID="ID_347844554" MODIFIED="1530676247924" TEXT="memory_usage"/>
</node>
<node CREATED="1530676248779" FOLDED="true" ID="ID_554650900" MODIFIED="1533551799359" TEXT="Int64">
<node CREATED="1530676252899" ID="ID_827665066" MODIFIED="1530676257257" TEXT="peak_memory_usage"/>
</node>
<node CREATED="1530676258591" FOLDED="true" ID="ID_326984244" MODIFIED="1533551799359" TEXT="ClientInfo">
<node CREATED="1530676263225" ID="ID_188269083" MODIFIED="1530676265160" TEXT="client_info"/>
</node>
<node CREATED="1530676266580" FOLDED="true" ID="ID_1317308184" MODIFIED="1533551799359" TEXT="bool">
<node CREATED="1530676269933" ID="ID_1654468224" MODIFIED="1530676273665" TEXT="is_cancelled"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_139314220" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_331795518" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_901769066" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530675833477" FOLDED="true" ID="ID_1114158139" MODIFIED="1533616736152" TEXT="ProcessListElement">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1123387435" MODIFIED="1533551799362" TEXT="properties">
<node CREATED="1530013557169" ID="ID_1224268017" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_595284280" MODIFIED="1533551799361" TEXT="members">
<node CREATED="1530755918581" FOLDED="true" ID="ID_1807470593" MODIFIED="1533551799360" TEXT="String">
<node CREATED="1530756232514" ID="ID_362821880" MODIFIED="1530756235072" TEXT="query"/>
</node>
<node CREATED="1530755927671" FOLDED="true" ID="ID_287049861" LINK="#ID_315114527" MODIFIED="1533551799360" TEXT="ClientInfo">
<node CREATED="1530756236455" ID="ID_1972225836" MODIFIED="1531256600636" TEXT="client_info : stores information about client"/>
</node>
<node CREATED="1530755933519" FOLDED="true" ID="ID_1386573049" MODIFIED="1533551799360" TEXT="Stopwatch">
<node CREATED="1530756240344" ID="ID_812516901" MODIFIED="1530756243520" TEXT="watch"/>
</node>
<node CREATED="1530755939003" FOLDED="true" ID="ID_62733883" MODIFIED="1533551799360" TEXT="Progress">
<node CREATED="1530756244327" ID="ID_819342852" MODIFIED="1530756427034" TEXT="progress_in : progress of input stream"/>
</node>
<node CREATED="1530755949810" FOLDED="true" ID="ID_141629573" MODIFIED="1533551799360" TEXT="Progress">
<node CREATED="1530756247233" ID="ID_1931454472" MODIFIED="1530756435049" TEXT="progress_out : progress of input stream"/>
</node>
<node CREATED="1530755952524" FOLDED="true" ID="ID_1475223211" MODIFIED="1533551799360" TEXT="MemoryTracker">
<node CREATED="1530756250434" ID="ID_608746748" MODIFIED="1530756456848" TEXT="memory_tracker : track memory usage of current process"/>
</node>
<node CREATED="1530755959262" FOLDED="true" ID="ID_126340848" MODIFIED="1533551799360" TEXT="QueryPriorities::Handle">
<node CREATED="1530756254447" ID="ID_1275407391" MODIFIED="1530756260087" TEXT="priority_handle"/>
</node>
<node CREATED="1530755973957" FOLDED="true" ID="ID_1165155756" MODIFIED="1533551799360" TEXT="CurrentMetrics::Increment">
<node CREATED="1530756261133" ID="ID_1534577357" MODIFIED="1530756266213" TEXT="num_queries"/>
</node>
<node CREATED="1530755988446" FOLDED="true" ID="ID_1542792635" MODIFIED="1533551799361" TEXT="std::atomic&lt;bool&gt;">
<node CREATED="1530756267585" ID="ID_370701648" MODIFIED="1530756270649" TEXT="is_killed"/>
</node>
<node CREATED="1530756025947" FOLDED="true" ID="ID_1430250524" MODIFIED="1533551799361" TEXT="const ProcessListForUser *">
<node CREATED="1530756277881" ID="ID_1389650598" MODIFIED="1530756288800" TEXT="user_process_list"/>
</node>
<node CREATED="1530756039607" FOLDED="true" ID="ID_1226865436" MODIFIED="1533551799361" TEXT="mutable std::mutex">
<node CREATED="1530756290278" ID="ID_1113189544" MODIFIED="1530756295329" TEXT="query_streams_mutex"/>
</node>
<node CREATED="1530756045655" FOLDED="true" ID="ID_386502987" MODIFIED="1533551799361" TEXT="BlockInputStreamPtr">
<node CREATED="1530756296781" ID="ID_678433344" MODIFIED="1530756305228" TEXT="query_stream_in"/>
</node>
<node CREATED="1530756046668" FOLDED="true" ID="ID_18497712" MODIFIED="1533551799361" TEXT="BlockOutputStreamPtr">
<node CREATED="1530756306331" ID="ID_228424536" MODIFIED="1530756312206" TEXT="query_stream_out"/>
</node>
<node CREATED="1530756052014" ID="ID_1239983450" LINK="#ID_888800614" MODIFIED="1530756119186" TEXT="QueryStreamsStatus"/>
</node>
<node CREATED="1530013563312" ID="ID_153228306" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1438400106" MODIFIED="1533551799362" TEXT="functions">
<node CREATED="1531256572001" FOLDED="true" ID="ID_1049098956" MODIFIED="1533551799361" TEXT="getClientInfo">
<node CREATED="1531256573881" ID="ID_780686221" MODIFIED="1531256578621" TEXT="return client_info"/>
</node>
<node CREATED="1531256818708" FOLDED="true" ID="ID_379332119" MODIFIED="1533551799361" TEXT="getProgressIn">
<node CREATED="1531256844880" ID="ID_1331165359" MODIFIED="1531256850608" TEXT="return progress_in.getValues"/>
</node>
<node CREATED="1531256846067" FOLDED="true" ID="ID_142155500" MODIFIED="1533551799361" TEXT="getProgressOut">
<node CREATED="1531256855864" ID="ID_1411511302" MODIFIED="1531256859994" TEXT="return progress_out.getValues"/>
</node>
<node CREATED="1531256926469" ID="ID_1068637240" MODIFIED="1531256926700" TEXT="getUserNetworkThrottler"/>
<node CREATED="1531256995979" FOLDED="true" ID="ID_652993956" MODIFIED="1533551799362" TEXT="updateProgressIn">
<node CREATED="1531257000637" ID="ID_758467499" MODIFIED="1531257028943" TEXT="add value of rhs to progress_in"/>
</node>
<node CREATED="1531256999457" FOLDED="true" ID="ID_712014463" MODIFIED="1533551799362" TEXT="updateProgressOut">
<node CREATED="1531257000637" ID="ID_1091734536" MODIFIED="1531257032989" TEXT="add value of rhs to progress_out"/>
</node>
<node CREATED="1531257033676" FOLDED="true" ID="ID_1990197868" MODIFIED="1533551799362" TEXT="getInfo">
<node CREATED="1531257122899" ID="ID_1839186379" MODIFIED="1531257130467" TEXT="return members in the format of ProcessInfo"/>
</node>
<node CREATED="1531257167281" ID="ID_939802895" MODIFIED="1531257167746" TEXT="setQueryStreams"/>
<node CREATED="1531257170234" ID="ID_180675469" MODIFIED="1531257170916" TEXT="releaseQueryStreams"/>
<node CREATED="1531257173452" ID="ID_560426341" MODIFIED="1531257173831" TEXT="streamsAreReleased"/>
<node CREATED="1531257176450" ID="ID_57021593" MODIFIED="1531257176802" TEXT="tryGetQueryStreams"/>
</node>
<node CREATED="1530014254828" FOLDED="true" ID="ID_790692177" MODIFIED="1533551799362" TEXT="classes">
<node CREATED="1530756089572" FOLDED="true" ID="ID_888800614" MODIFIED="1533551799362" TEXT="enum QueryStreamsStatus">
<node CREATED="1530756090570" ID="ID_1330662642" MODIFIED="1530756107817" TEXT="NotInitialized"/>
<node CREATED="1530756110057" MODIFIED="1530756110057" TEXT="Initialized"/>
<node CREATED="1530756113783" MODIFIED="1530756113783" TEXT="Released"/>
</node>
</node>
</node>
</node>
<node CREATED="1530756184721" ID="ID_1946431520" MODIFIED="1530756185854" TEXT="ProcessListEntry"/>
<node CREATED="1530675939559" FOLDED="true" ID="ID_696010773" MODIFIED="1533616736152" TEXT="ProcessListForUser">
<node CREATED="1530014332949" FOLDED="true" ID="ID_965917196" MODIFIED="1533551799363" TEXT="properties">
<node CREATED="1530013557169" ID="ID_247415520" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" ID="ID_235050784" MODIFIED="1530675870607" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_967456561" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_690303946" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_251312033" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530675839711" FOLDED="true" ID="ID_1060452356" MODIFIED="1533616736152" TEXT="ProcessList">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1225130148" MODIFIED="1533551799363" TEXT="properties">
<node CREATED="1530013557169" ID="ID_451478991" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" ID="ID_543617560" MODIFIED="1530675870607" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_737944158" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_583913454" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1036815219" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
</node>
<node CREATED="1530675734197" ID="ID_635345769" LINK="ClickHouse/dbms/src/Interpreters/ProcessList.cpp" MODIFIED="1530675776877" TEXT="ProcessList.cpp"/>
<node CREATED="1531248917434" FOLDED="true" ID="ID_52214389" MODIFIED="1533616736153" TEXT="SortBlock.cpp">
<node CREATED="1531248936108" FOLDED="true" ID="ID_732267979" MODIFIED="1533616736153" TEXT="functions">
<node CREATED="1531248939416" FOLDED="true" ID="ID_1293316999" MODIFIED="1533551799363" TEXT="void sortBlock(Block &amp; block, const SortDescription &amp; description, size_t limit)">
<node CREATED="1531248957782" ID="ID_615129126" MODIFIED="1531248957782" TEXT=""/>
</node>
</node>
</node>
<node CREATED="1530760755377" ID="ID_358497480" LINK="ClickHouse/dbms/src/Interpreters/Quota.h" MODIFIED="1534140207659" TEXT="Quota.h">
<node CREATED="1530013182602" FOLDED="true" ID="ID_886252348" MODIFIED="1533616736154" TEXT="description">
<node CREATED="1530760810924" ID="ID_922534866" MODIFIED="1530760819752" TEXT="Quota for resources consumption for specific interval. Used to limit resource usage by user."/>
</node>
<node CREATED="1530760875436" ID="ID_1460944666" MODIFIED="1534140207659" TEXT="QuotaValues">
<node CREATED="1530014332949" ID="ID_1299418553" MODIFIED="1534140207659" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1597687823" MODIFIED="1533551799364" TEXT="description">
<node CREATED="1531320477173" ID="ID_567114072" MODIFIED="1531320529417" TEXT="collection of values, used as return type"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_227406159" MODIFIED="1533551799365" TEXT="members">
<node CREATED="1530773235690" FOLDED="true" ID="ID_83672633" MODIFIED="1533551799364" TEXT="size_t / atomic&lt;size_t&gt;">
<node CREATED="1530773262447" ID="ID_514622742" MODIFIED="1531320293398" TEXT="queries : number of queries."/>
</node>
<node CREATED="1530773235690" FOLDED="true" ID="ID_1449496663" MODIFIED="1533551799364" TEXT="size_t / atomic&lt;size_t&gt;">
<node CREATED="1530773267041" ID="ID_715620267" MODIFIED="1531320301268" TEXT="errors : number of queries with exceptions."/>
</node>
<node CREATED="1530773235690" FOLDED="true" ID="ID_23546047" MODIFIED="1533551799364" TEXT="size_t / atomic&lt;size_t&gt;">
<node CREATED="1530773268965" ID="ID_986331324" MODIFIED="1531320318447" TEXT="result_rows : number of rows returned as result."/>
</node>
<node CREATED="1530773235690" FOLDED="true" ID="ID_728617127" MODIFIED="1533551799364" TEXT="size_t / atomic&lt;size_t&gt;">
<node CREATED="1530773272216" ID="ID_1098074084" MODIFIED="1531320325567" TEXT="result_bytes : number of bytes returned as result."/>
</node>
<node CREATED="1530773235690" FOLDED="true" ID="ID_1328569372" MODIFIED="1533551799364" TEXT="size_t / atomic&lt;size_t&gt;">
<node CREATED="1530773275740" ID="ID_910165749" MODIFIED="1531320332873" TEXT="read_rows : number of rows read from tables."/>
</node>
<node CREATED="1530773235690" FOLDED="true" ID="ID_1196858076" MODIFIED="1533551799364" TEXT="size_t / atomic&lt;size_t&gt;">
<node CREATED="1530773275740" ID="ID_1786931807" MODIFIED="1531320340130" TEXT="read_bytes : number of bytes read from tables."/>
</node>
<node CREATED="1530773235690" FOLDED="true" ID="ID_149799470" MODIFIED="1533551799364" TEXT="size_t / atomic&lt;size_t&gt;">
<node CREATED="1530773275740" ID="ID_553869931" MODIFIED="1531320282944" TEXT="execution_time_usec : total amount of query execution time in microseconds."/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_918128434" MODIFIED="1534140207674" TEXT="concepts">
<node CREATED="1530772048581" ID="ID_577770687" MODIFIED="1534140207674" TEXT="std::forward_as_tuple">
<node CREATED="1530772059186" ID="ID_1655821153" MODIFIED="1534140207674" TEXT="implemented with forward, the implementation of forward see links">
<node CREATED="1530772097829" ID="ID_1614513313" LINK="https://stackoverflow.com/questions/27501400/the-implementation-of-stdforward" MODIFIED="1530772125828" TEXT="article1"/>
<node CREATED="1530772108353" ID="ID_198689132" LINK="https://stackoverflow.com/questions/42329230/difference-between-stdforward-implementation" MODIFIED="1530772137627" TEXT="article2"/>
<node CREATED="1530772138557" ID="ID_326424633" LINK="http://bajamircea.github.io/coding/cpp/2016/04/07/move-forward.html" MODIFIED="1530772148075" TEXT="article3"/>
</node>
</node>
</node>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1123438425" MODIFIED="1533551799365" TEXT="functions">
<node CREATED="1530772829250" FOLDED="true" ID="ID_1954992707" MODIFIED="1533551799365" TEXT="clear">
<node CREATED="1530772858749" ID="ID_81027489" MODIFIED="1530772863406" TEXT="set all members to 0s"/>
</node>
<node CREATED="1530772864449" FOLDED="true" ID="ID_1087109258" MODIFIED="1533551799365" TEXT="operator= / operator==">
<node CREATED="1530772874425" ID="ID_1558566157" MODIFIED="1530772883351" TEXT="normal assignment, equality"/>
</node>
<node CREATED="1530773128327" ID="ID_228533147" MODIFIED="1530773131302" TEXT="initFromConfig"/>
<node CREATED="1530772308680" FOLDED="true" ID="ID_505141752" MODIFIED="1533551799365" TEXT="tuple">
<node CREATED="1530772312953" ID="ID_447619846" MODIFIED="1530772827706" TEXT="return its members as a tuple (if lvalue, and return rvalue reference)"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_948125739" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530760891717" FOLDED="true" ID="ID_370651818" MODIFIED="1533616736156" TEXT="QuotaForInterval">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1751397831" MODIFIED="1533551799367" TEXT="properties">
<node CREATED="1530013557169" ID="ID_1047585265" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1883966452" MODIFIED="1533551799366" TEXT="members">
<node CREATED="1530773626137" FOLDED="true" ID="ID_442665203" MODIFIED="1533551799366" TEXT="std::atomic&lt;time_t&gt;">
<node CREATED="1530773659462" ID="ID_1634797519" MODIFIED="1530773682867" TEXT="rounded_time{0} :"/>
</node>
<node CREATED="1530773627089" FOLDED="true" ID="ID_1094361056" MODIFIED="1533551799366" TEXT="size_t">
<node CREATED="1530773664027" ID="ID_780949206" MODIFIED="1530773676239" TEXT="duration = 0 : "/>
</node>
<node CREATED="1530773630919" FOLDED="true" ID="ID_765391023" MODIFIED="1533551799366" TEXT="bool">
<node CREATED="1530773684174" ID="ID_304400172" MODIFIED="1530773689940" TEXT="randomize = false"/>
</node>
<node CREATED="1530773634413" FOLDED="true" ID="ID_207236675" MODIFIED="1533551799366" TEXT="time_t">
<node CREATED="1530773693135" ID="ID_982841987" MODIFIED="1530773697046" TEXT="offset = 0"/>
</node>
<node CREATED="1530773641733" FOLDED="true" ID="ID_1636876991" MODIFIED="1533551799366" TEXT="QuotaValues&lt;size_t&gt;">
<node CREATED="1530773700783" ID="ID_1781626674" MODIFIED="1530773702553" TEXT="max : "/>
</node>
<node CREATED="1530773643212" FOLDED="true" ID="ID_486808897" MODIFIED="1533551799366" TEXT="QuotaValues&lt;atmoic&lt;size_t&gt;&gt;">
<node CREATED="1530773704178" ID="ID_1748441127" MODIFIED="1530773707300" TEXT="used : "/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_1117997406" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_607080750" MODIFIED="1533551799367" TEXT="functions">
<node CREATED="1530773777772" FOLDED="true" ID="ID_1258383784" MODIFIED="1533551799366" TEXT="copy ctor/assignment / equality">
<node CREATED="1530773785066" ID="ID_927580990" MODIFIED="1530773805776" TEXT="do it only for certain members"/>
</node>
<node CREATED="1530774178268" FOLDED="true" ID="ID_1006594346" MODIFIED="1533551799366" TEXT="addQuery">
<node CREATED="1530774279525" ID="ID_1103912806" MODIFIED="1530774286227" TEXT="increment used.queries"/>
</node>
<node CREATED="1530774187067" FOLDED="true" ID="ID_726502067" MODIFIED="1533551799367" TEXT="addError">
<node CREATED="1530774279525" ID="ID_304016708" MODIFIED="1530774291915" TEXT="increment used.errors"/>
</node>
<node CREATED="1530774166669" FOLDED="true" ID="ID_402518727" MODIFIED="1533551799367" TEXT="checkExceeded">
<node CREATED="1530774242175" ID="ID_1920143306" MODIFIED="1531322062109" TEXT="call &quot;updateTime&quot;, then direct calls to &quot;check&quot; to check if members of &quot;used&quot; have exceed members of max"/>
</node>
<node CREATED="1530774392907" FOLDED="true" ID="ID_152125463" MODIFIED="1533551799367" TEXT="checkAndAddResultRowsBytes">
<node CREATED="1531322107875" ID="ID_1359199372" MODIFIED="1531322160614" TEXT="add some value to used.result_rows and used.rresult_bytes, and call checkExceeded"/>
</node>
<node CREATED="1530774396767" FOLDED="true" ID="ID_1786023558" MODIFIED="1533551799367" TEXT="checkAndAddReadRowsBytes">
<node CREATED="1531322107875" ID="ID_555412847" MODIFIED="1531322181777" TEXT="add some value to used.read_rows and used.read_bytes, and call checkExceeded"/>
</node>
<node CREATED="1530774400063" FOLDED="true" ID="ID_171066197" MODIFIED="1533551799367" TEXT="checkAndAddExecutionTime">
<node CREATED="1531322166258" FOLDED="true" ID="ID_1178296595" MODIFIED="1533551799367" TEXT="add some value to used.execution_time_usec and call checkExceeded ">
<node CREATED="1531727226922" ID="ID_1235673451" MODIFIED="1531727226922" TEXT=""/>
</node>
</node>
<node CREATED="1531320913113" ID="ID_93107789" MODIFIED="1531320913627" TEXT="updateTime"/>
<node CREATED="1531320914186" FOLDED="true" ID="ID_720541543" MODIFIED="1533551799367" TEXT="check">
<node CREATED="1531321410592" ID="ID_980442239" MODIFIED="1531321459164" TEXT="check if some used member value exceed corresponding max member value, if so, throw"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1915296286" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530760920255" FOLDED="true" ID="ID_226156529" MODIFIED="1533616736156" TEXT="QuotaForIntervals">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1093075027" MODIFIED="1533551799368" TEXT="properties">
<node CREATED="1530013557169" ID="ID_527930973" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1093134890" MODIFIED="1533551799368" TEXT="members">
<node CREATED="1530774431542" FOLDED="true" ID="ID_607889314" MODIFIED="1533551799368" TEXT="std::map&lt;size_t, QuotaForInterval&gt;(Container)">
<node CREATED="1530774453887" ID="ID_935034087" MODIFIED="1530774455239" TEXT="cont"/>
</node>
<node CREATED="1530774447296" FOLDED="true" ID="ID_170397236" MODIFIED="1533551799368" TEXT="string">
<node CREATED="1530774456046" ID="ID_1539394102" MODIFIED="1530774458088" TEXT="quota_name"/>
</node>
<node CREATED="1530774448398" FOLDED="true" ID="ID_1862211525" MODIFIED="1533551799368" TEXT="string">
<node CREATED="1530774458783" ID="ID_666117241" MODIFIED="1530774462937" TEXT="user_name"/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_828866589" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1387511237" MODIFIED="1533551799368" TEXT="functions">
<node CREATED="1530014251553" FOLDED="true" ID="ID_51788367" MODIFIED="1533551799368" TEXT="functions">
<node CREATED="1530773777772" FOLDED="true" ID="ID_85886259" MODIFIED="1533551799368" TEXT="copy ctor/assignment / equality">
<node CREATED="1530773785066" ID="ID_524292684" MODIFIED="1530773805776" TEXT="do it only for certain members"/>
</node>
<node CREATED="1530774178268" FOLDED="true" ID="ID_710438639" MODIFIED="1533551799368" TEXT="addQuery">
<node CREATED="1530774687912" ID="ID_1655173163" LINK="#ID_1006594346" MODIFIED="1530774748508" TEXT="similar to QuotaForInterval::addQuery, but do it for the whole map in reverse order"/>
</node>
<node CREATED="1530774187067" ID="ID_914871894" MODIFIED="1530774188696" TEXT="addError"/>
<node CREATED="1530774166669" ID="ID_1578933277" MODIFIED="1530774177826" TEXT="checkExceeded"/>
<node CREATED="1530774392907" ID="ID_552939183" MODIFIED="1530774393661" TEXT="checkAndAddResultRowsBytes"/>
<node CREATED="1530774396767" ID="ID_540208372" MODIFIED="1530774397141" TEXT="checkAndAddReadRowsBytes"/>
<node CREATED="1530774400063" ID="ID_231452399" MODIFIED="1530774400374" TEXT="checkAndAddExecutionTime"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1141525405" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530760922125" FOLDED="true" ID="ID_496595112" MODIFIED="1533616736156" TEXT="Quota">
<node CREATED="1530014332949" FOLDED="true" ID="ID_261099300" MODIFIED="1533551799369" TEXT="properties">
<node CREATED="1530013557169" ID="ID_716939044" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" ID="ID_119795979" MODIFIED="1530696720033" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_4716028" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_870744972" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1162849316" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530760924352" FOLDED="true" ID="ID_1608142875" MODIFIED="1533616736156" TEXT="Quotas">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1378060197" MODIFIED="1533551799369" TEXT="properties">
<node CREATED="1530013557169" ID="ID_588833616" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" ID="ID_2933531" MODIFIED="1530696720033" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_569112334" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_445676418" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_422541893" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
</node>
<node CREATED="1530760761191" ID="ID_1000152166" LINK="ClickHouse/dbms/src/Interpreters/Quota.cpp" MODIFIED="1530760779717" TEXT="Quota.cpp"/>
</node>
<node CREATED="1532502222746" ID="ID_1805896662" MODIFIED="1532502224610" TEXT="Parser">
<node CREATED="1534159901360" ID="ID_1394507221" MODIFIED="1534159903861" TEXT="Lexer.h">
<node CREATED="1534159910459" ID="ID_453488593" MODIFIED="1534159941187" TEXT="description"/>
<node CREATED="1534159941818" ID="ID_1426515453" MODIFIED="1534159948373" TEXT="members">
<node CREATED="1534159952010" ID="ID_113475359" MODIFIED="1534159967261" TEXT="const char * const">
<node CREATED="1534159998095" ID="ID_1088367892" MODIFIED="1534160000782" TEXT="begin"/>
</node>
<node CREATED="1534159967892" ID="ID_604095778" MODIFIED="1534159969671" TEXT="const char *">
<node CREATED="1534159994719" ID="ID_1797617950" MODIFIED="1534159995933" TEXT="pos"/>
</node>
<node CREATED="1534159970652" ID="ID_812831109" MODIFIED="1534159973153" TEXT="const char * const">
<node CREATED="1534159991538" ID="ID_1745388285" MODIFIED="1534159993918" TEXT="end"/>
</node>
<node CREATED="1534159979573" ID="ID_1602644795" MODIFIED="1534159980048" TEXT="const size_t">
<node CREATED="1534159988126" ID="ID_1785707393" MODIFIED="1534159990744" TEXT="max_query_size : "/>
</node>
<node CREATED="1534160276310" ID="ID_920946785" MODIFIED="1534160276831" TEXT="TokenType">
<node CREATED="1534160282069" ID="ID_1767890321" MODIFIED="1534160293876" TEXT="prev_significant_token_type = TokenType::Whitespace : This is needed to disambiguate tuple access operator from floating point number (.1)"/>
</node>
</node>
<node CREATED="1534160012959" ID="ID_735289627" MODIFIED="1534160016323" TEXT="concepts"/>
<node CREATED="1534160016798" ID="ID_485308886" MODIFIED="1534160018467" TEXT="functions">
<node CREATED="1534160205654" ID="ID_836447526" MODIFIED="1534160229624" TEXT="Token nextToken()">
<node CREATED="1534161597792" ID="ID_1736915200" MODIFIED="1534161629350" TEXT="direct call to nextTokenImpl, check max_query_size not exceeded, and set prev_significant_token_type"/>
</node>
<node CREATED="1534160232488" ID="ID_1270505631" MODIFIED="1534160239698" TEXT="Token nextTokenImpl()"/>
</node>
<node CREATED="1534160304479" ID="ID_1784807935" MODIFIED="1534160308224" TEXT="non-member functions">
<node CREATED="1534160317008" ID="ID_1773632642" MODIFIED="1534160317525" TEXT="const char * getTokenName(TokenType type)">
<node CREATED="1534160824523" ID="ID_381709928" MODIFIED="1534160840368" TEXT="print each token&apos;s name in string form"/>
</node>
<node CREATED="1534160318114" ID="ID_501654460" MODIFIED="1534160323886" TEXT="const char * getErrorTokenDescription(TokenType type)">
<node CREATED="1534160935125" ID="ID_1198184285" MODIFIED="1534160955887" TEXT="given more detailed text description on each error type"/>
</node>
</node>
<node CREATED="1534160018989" ID="ID_1577308211" MODIFIED="1534160021178" TEXT="classes">
<node CREATED="1534160030643" ID="ID_643025392" MODIFIED="1534160089068" TEXT="enum class TokenType">
<node CREATED="1534160074404" ID="ID_1718281460" MODIFIED="1534160098856" TEXT="tokens for keywords"/>
</node>
<node CREATED="1534160021781" ID="ID_475000566" MODIFIED="1534160023224" TEXT="Token">
<node CREATED="1534160100061" ID="ID_454623933" MODIFIED="1534160106700" TEXT="members">
<node CREATED="1534160107071" ID="ID_1427419777" MODIFIED="1534160117233" TEXT="TokenType type"/>
<node CREATED="1534160124243" ID="ID_1424296990" MODIFIED="1534160124556" TEXT=" const char * begin"/>
<node CREATED="1534160128519" ID="ID_702583641" MODIFIED="1534160128944" TEXT="const char * end"/>
</node>
<node CREATED="1534160130504" ID="ID_1519799193" MODIFIED="1534160132001" TEXT="functions">
<node CREATED="1534160139267" ID="ID_922550278" MODIFIED="1534160139613" TEXT="size_t size()">
<node CREATED="1534160140250" ID="ID_808052771" MODIFIED="1534160145681" TEXT="return end - begin"/>
</node>
<node CREATED="1534160153754" ID="ID_1333827306" MODIFIED="1534160154042" TEXT="isSignificant">
<node CREATED="1534160154781" ID="ID_1877167374" MODIFIED="1534160167263" TEXT="type != TokenType::Whitespace &amp;&amp; type != TokenType::Comment"/>
</node>
<node CREATED="1534160168184" ID="ID_1390653515" MODIFIED="1534160175092" TEXT="isEnd">
<node CREATED="1534160175583" ID="ID_1171815642" MODIFIED="1534160180927" TEXT="type == TokenType::EndOfStream"/>
</node>
<node CREATED="1534160181660" ID="ID_1049407273" MODIFIED="1534160183815" TEXT="isError">
<node CREATED="1534160184300" ID="ID_162129942" MODIFIED="1534160192086" TEXT="type is any one of the error type"/>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1534159904432" ID="ID_1935705819" MODIFIED="1534159907669" TEXT="Lexer.cpp"/>
</node>
<node CREATED="1529653334300" ID="ID_1778401268" MODIFIED="1533616759621" TEXT="Storages">
<node CREATED="1529984084307" FOLDED="true" ID="ID_887535284" LINK="ClickHouse/dbms/src/Storages/ColumnDefault.h" MODIFIED="1533616736158" TEXT="ColumnDefault.h">
<arrowlink DESTINATION="ID_492977238" ENDARROW="Default" ENDINCLINATION="58;0;" ID="Arrow_ID_1026100595" STARTARROW="None" STARTINCLINATION="58;0;"/>
<node CREATED="1530014372946" FOLDED="true" ID="ID_1418615878" MODIFIED="1533616736158" TEXT="properties">
<node CREATED="1530013557169" ID="ID_1988896255" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1066255322" MODIFIED="1533551799369" TEXT="members">
<node CREATED="1530013604634" ID="ID_617908521" MODIFIED="1530013630225" TEXT="ColumnDefaultKind(enum)"/>
<node CREATED="1530013630730" ID="ID_1187135485" MODIFIED="1530013635413" TEXT="ASTPtr"/>
</node>
<node CREATED="1530013563312" ID="ID_1231989794" MODIFIED="1530013566459" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_1930594286" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_94233339" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1529984118566" ID="ID_227862359" LINK="ClickHouse/dbms/src/Storages/ColumnsDescription.cpp" MODIFIED="1529984149238" TEXT="ColumnDefault.cpp">
<arrowlink DESTINATION="ID_492977238" ENDARROW="Default" ENDINCLINATION="30;0;" ID="Arrow_ID_56860336" STARTARROW="None" STARTINCLINATION="30;0;"/>
</node>
<node CREATED="1529918728911" FOLDED="true" ID="ID_492977238" LINK="ClickHouse/dbms/src/Storages/ColumnsDescription.h" MODIFIED="1533616736159" TEXT="ColumnsDescription.h">
<linktarget COLOR="#b0b0b0" DESTINATION="ID_492977238" ENDARROW="Default" ENDINCLINATION="58;0;" ID="Arrow_ID_1026100595" SOURCE="ID_887535284" STARTARROW="None" STARTINCLINATION="58;0;"/>
<linktarget COLOR="#b0b0b0" DESTINATION="ID_492977238" ENDARROW="Default" ENDINCLINATION="30;0;" ID="Arrow_ID_56860336" SOURCE="ID_227862359" STARTARROW="None" STARTINCLINATION="30;0;"/>
<node CREATED="1530014384668" FOLDED="true" ID="ID_1291385159" MODIFIED="1533616736159" TEXT="properties ">
<node CREATED="1530013557169" ID="ID_615318680" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_993963912" MODIFIED="1533551799370" TEXT="members">
<node CREATED="1530013688139" FOLDED="true" ID="ID_1934498625" MODIFIED="1533551799370" TEXT="NamesAndTypesList">
<node CREATED="1532639905038" ID="ID_1746930342" MODIFIED="1532639906581" TEXT="ordinary : "/>
</node>
<node CREATED="1532639899370" FOLDED="true" ID="ID_731567879" MODIFIED="1533551799370" TEXT="NamesAndTypesList">
<node CREATED="1532639907514" ID="ID_610407203" MODIFIED="1532639912354" TEXT="materialized : "/>
</node>
<node CREATED="1532639901168" FOLDED="true" ID="ID_1548494490" MODIFIED="1533551799370" TEXT="NamesAndTypesList">
<node CREATED="1532639915785" ID="ID_1302559931" MODIFIED="1532639917275" TEXT="aliases : "/>
</node>
<node CREATED="1530013696581" FOLDED="true" ID="ID_1355292927" MODIFIED="1533551799370" TEXT="ColumnDefaults">
<node CREATED="1532639920502" ID="ID_460534920" MODIFIED="1532639922017" TEXT="defaults : "/>
</node>
</node>
<node CREATED="1530013563312" FOLDED="true" ID="ID_1745225201" MODIFIED="1533551799370" TEXT="concepts">
<node CREATED="1532640282419" ID="ID_1624973117" LINK="https://www.boost.org/doc/libs/1_67_0/libs/range/doc/html/range/reference/utilities/join.html" MODIFIED="1532640290064" TEXT="boost::join"/>
</node>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1905577378" MODIFIED="1533551799370" TEXT="functions">
<node CREATED="1532639980338" FOLDED="true" ID="ID_1872979487" MODIFIED="1533551799370" TEXT="getAllPhysical">
<node CREATED="1532639981202" ID="ID_1830962873" MODIFIED="1532639991323" TEXT="return ordinary + materialized"/>
</node>
<node CREATED="1532639993642" FOLDED="true" ID="ID_1173657641" MODIFIED="1533551799370" TEXT="getAll">
<node CREATED="1532640002378" ID="ID_1430263616" MODIFIED="1532640003808" TEXT="return ordinary + materialized + aliases"/>
</node>
<node CREATED="1532640384726" ID="ID_1422806453" MODIFIED="1532640385118" TEXT="getNamesOfPhysical"/>
<node CREATED="1532640407520" ID="ID_1061473174" MODIFIED="1532640421633" TEXT="NameAndTypePair getPhysical(const String &amp; column_name)"/>
<node CREATED="1532640427712" ID="ID_341477584" MODIFIED="1532640433258" TEXT="bool hasPhysical(const String &amp; column_name)"/>
</node>
<node CREATED="1530014254828" ID="ID_1273777699" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1529918733905" ID="ID_431066811" LINK="ClickHouse/dbms/src/Storages/ColumnsDescription.cpp" MODIFIED="1532984975595" TEXT="ColumnsDescription.cpp"/>
<node CREATED="1529918305795" ID="ID_771863818" LINK="ClickHouse/dbms/src/Storages/ITableDeclaration.h" MODIFIED="1533616762286" TEXT="ITableDeclaration.h">
<node CREATED="1530014332949" FOLDED="true" ID="ID_1621910742" MODIFIED="1534159096555" TEXT="properties">
<node CREATED="1530013557169" ID="ID_752072242" MODIFIED="1530013559548" TEXT="description"/>
<node CREATED="1530013560221" FOLDED="true" ID="ID_1370089738" MODIFIED="1533551799371" TEXT="members">
<node CREATED="1530013696581" FOLDED="true" ID="ID_412496615" LINK="#ID_492977238" MODIFIED="1533551799371" TEXT="ColumnsDescription">
<node CREATED="1532640463259" ID="ID_91153181" MODIFIED="1532640465368" TEXT="columns : "/>
</node>
</node>
<node CREATED="1530013563312" FOLDED="true" ID="ID_144037038" MODIFIED="1533551799371" TEXT="concepts">
<node CREATED="1532700265137" ID="ID_1757814159" LINK="http://goog-sparsehash.sourceforge.net/doc/dense_hash_map.html" MODIFIED="1532700275278" TEXT="dense_hash_map"/>
</node>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1513560407" MODIFIED="1534159096555" TEXT="functions">
<node CREATED="1532644002458" FOLDED="true" ID="ID_105831482" MODIFIED="1533551799372" TEXT="ColumnsDescription getColumns()">
<node CREATED="1532644003880" ID="ID_812944915" MODIFIED="1532644005886" TEXT="return columns"/>
</node>
<node CREATED="1532644006673" FOLDED="true" ID="ID_428695361" MODIFIED="1533551799372" TEXT="NameAndTypePair getColumn(const String &amp; column_name)">
<node CREATED="1532644129905" ID="ID_1544418155" MODIFIED="1532644133983" TEXT="get column by name"/>
</node>
<node CREATED="1532644139342" ID="ID_741271955" MODIFIED="1532644139659" TEXT="bool hasColumn(const String &amp; column_name)"/>
<node CREATED="1532644140141" FOLDED="true" ID="ID_1242848858" MODIFIED="1533551799372" TEXT="void setColumns(ColumnsDescription columns_)">
<node CREATED="1532644185169" ID="ID_1185657643" MODIFIED="1532644200893" TEXT="set column.ordinary to rhs"/>
</node>
<node CREATED="1532644836999" FOLDED="true" ID="ID_1554205761" MODIFIED="1533551799372" TEXT="getSampleBlock">
<node CREATED="1532644846413" ID="ID_851216467" MODIFIED="1532698421906" TEXT="create a sample block (something like a header block) of columns of.ordinary + materialized"/>
</node>
<node CREATED="1532644845313" FOLDED="true" ID="ID_1258435013" MODIFIED="1533551799372" TEXT="getSampleBlockNonMaterialized">
<node CREATED="1532644846413" ID="ID_257429478" MODIFIED="1532698426656" TEXT="create a sample block (something like a header block) of columns of materialized"/>
</node>
<node CREATED="1532698473527" FOLDED="true" ID="ID_403894170" MODIFIED="1533551799372" TEXT="getSampleBlockForColumns">
<node CREATED="1532644846413" ID="ID_170306673" MODIFIED="1532698490820" TEXT="create a sample block (something like a header block) of columns with given names"/>
</node>
<node CREATED="1532698518844" FOLDED="true" ID="ID_661864063" MODIFIED="1534159096555" TEXT="listOfColumns">
<node CREATED="1532698520662" ID="ID_1177499043" MODIFIED="1532698534625" TEXT="return a comma separated list of column names"/>
</node>
<node CREATED="1532700607608" FOLDED="true" ID="ID_1755989717" MODIFIED="1533551799372" TEXT="NamesAndTypesMap getColumnsMap(const Args &amp;... args)">
<node CREATED="1532700622376" ID="ID_1313348683" MODIFIED="1532700717593" TEXT="return dense_hash_map mapping StringRef() to IDataType *, by loop through all elements in args (assuming args is of type NamesAndTypesList, and insert name as key, type pointer as value."/>
</node>
<node CREATED="1532700931956" FOLDED="true" ID="ID_711296639" MODIFIED="1533551799372" TEXT="void check(const Names &amp; column_names) const">
<node CREATED="1532701028254" ID="ID_1649708770" MODIFIED="1532701096625" TEXT="check if column_names are all in physical columns, and there is not repeated names"/>
</node>
<node CREATED="1532700932151" FOLDED="true" ID="ID_64619462" MODIFIED="1533551799373" TEXT="void check(const NamesAndTypesList &amp; provided_columns)">
<node CREATED="1532701118803" ID="ID_338663161" MODIFIED="1532701154666" TEXT="same as above, except that it also check the types of the columns are consistent with the physical columns"/>
</node>
<node CREATED="1532701155405" FOLDED="true" ID="ID_793515857" MODIFIED="1533551799373" TEXT="void check(const NamesAndTypesList &amp; columns, const Names &amp; column_names)">
<node CREATED="1532701796166" ID="ID_850150542" MODIFIED="1532701813148" TEXT="same as above, except it check the intersection of columns and column_names"/>
</node>
<node CREATED="1532701814060" FOLDED="true" ID="ID_1213023951" MODIFIED="1533551799373" TEXT="check(const Block &amp; block, bool need_all = false) ">
<icon BUILTIN="help"/>
<node CREATED="1532723506769" ID="ID_442321687" MODIFIED="1532723551148" TEXT="save as above. If need_all, still checks that all the columns of the table are in the block"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1613223181" MODIFIED="1530079245976" TEXT="classes"/>
</node>
<node CREATED="1529917854220" ID="ID_444686345" LINK="ClickHouse/dbms/src/Storages/IStorage.h" MODIFIED="1533616767019" TEXT="IStorage.h">
<node CREATED="1530014350060" FOLDED="true" ID="ID_1672405857" MODIFIED="1534159103982" TEXT="properties">
<node CREATED="1530013182602" FOLDED="true" ID="ID_992943736" MODIFIED="1533551799373" TEXT="description">
<node CREATED="1532703077616" ID="ID_96562722" MODIFIED="1532703099946" TEXT="responsible for  &#xa;* - storage of the table data;   &#xa;* - the definition in which files (or not in files) the data is stored;   &#xa;* - data lookups and appends;   &#xa;* - data storage structure (compression, etc.)   &#xa;* - concurrent access to data (locks, etc.)"/>
</node>
<node CREATED="1530013202034" FOLDED="true" ID="ID_553795646" MODIFIED="1533551799374" TEXT="members">
<node CREATED="1532719839522" FOLDED="true" ID="ID_1468810776" MODIFIED="1533551799373" TEXT="bool">
<node CREATED="1532719841529" ID="ID_235521030" MODIFIED="1532719851729" TEXT="is_dropped = false : "/>
</node>
<node CREATED="1530013220418" FOLDED="true" ID="ID_1856075139" MODIFIED="1533551799374" TEXT="mutable RWLockFIFOPtr">
<node CREATED="1532703944220" ID="ID_155428473" MODIFIED="1532703947668" TEXT="data_lock = RWLockFIFO::create() :"/>
</node>
<node CREATED="1532703948517" FOLDED="true" ID="ID_1036739762" MODIFIED="1533551799374" TEXT="mutable RWLockFIFOPtr">
<node CREATED="1532703958154" ID="ID_1223759719" MODIFIED="1532703959871" TEXT="structure_lock = RWLockFIFO::create();"/>
</node>
</node>
<node CREATED="1529917903274" FOLDED="true" ID="ID_192664976" MODIFIED="1533551799374" TEXT="concepts">
<node CREATED="1529917908770" ID="ID_612838144" LINK="http://www.cplusplus.com/reference/memory/enable_shared_from_this/" MODIFIED="1532702334772" TEXT="enable_shared_from_this"/>
</node>
<node CREATED="1530014251553" FOLDED="true" ID="ID_218310779" MODIFIED="1534159103982" TEXT="functions">
<node CREATED="1532703125092" FOLDED="true" ID="ID_271234456" MODIFIED="1533551799374" TEXT="virtual std::string getName()">
<node CREATED="1532703182076" ID="ID_466761052" MODIFIED="1532703182438" TEXT="The main name of the table type (for example, StorageMergeTree)."/>
</node>
<node CREATED="1532703129065" FOLDED="true" ID="ID_1922713386" MODIFIED="1533551799383" TEXT="virtual std::string getTableName()">
<node CREATED="1532703196766" ID="ID_1866712916" MODIFIED="1532703197157" TEXT="The name of the table."/>
</node>
<node CREATED="1532703149386" FOLDED="true" ID="ID_27484456" MODIFIED="1533551799383" TEXT="virtual bool isRemote()">
<node CREATED="1532703216020" ID="ID_1249244777" MODIFIED="1532703217332" TEXT=" Returns true if the storage receives data from a remote server or servers"/>
</node>
<node CREATED="1532703152997" FOLDED="true" ID="ID_139814810" MODIFIED="1533551799383" TEXT="virtual bool supportsSampling()">
<node CREATED="1532703423050" ID="ID_998358902" MODIFIED="1532703423363" TEXT="Returns true if the storage supports queries with the SAMPLE section."/>
</node>
<node CREATED="1532703157469" FOLDED="true" ID="ID_1233591292" MODIFIED="1533551799383" TEXT="virtual bool supportsFinal()">
<node CREATED="1532703450508" ID="ID_311114985" MODIFIED="1532703450776" TEXT="Returns true if the storage supports queries with the FINAL section."/>
</node>
<node CREATED="1532703457692" FOLDED="true" ID="ID_598006275" MODIFIED="1533551799384" TEXT="virtual bool supportsPrewhere()">
<node CREATED="1532703462917" ID="ID_1382307665" MODIFIED="1532703463324" TEXT="Returns true if the storage supports queries with the PREWHERE section."/>
</node>
<node CREATED="1532703479805" FOLDED="true" ID="ID_82965004" MODIFIED="1534159103982" TEXT=" virtual bool supportsReplication()">
<node CREATED="1532703485397" ID="ID_538093620" MODIFIED="1532703485649" TEXT="Returns true if the storage replicates SELECT, INSERT and ALTER commands among replicas."/>
</node>
<node CREATED="1532703494291" FOLDED="true" ID="ID_1265387203" MODIFIED="1533551799384" TEXT="virtual bool supportsDeduplication()">
<node CREATED="1532703499059" ID="ID_153988092" MODIFIED="1532703499295" TEXT="Returns true if the storage supports deduplication of inserted data blocks ."/>
</node>
<node CREATED="1532704389688" ID="ID_1873525022" MODIFIED="1532704393082" TEXT="lockStructure"/>
<node CREATED="1532703500114" ID="ID_679620536" MODIFIED="1532704376966" TEXT="lockForAlter"/>
<node CREATED="1532704377565" ID="ID_1606491554" MODIFIED="1532704383305" TEXT="lockDataForAlter"/>
<node CREATED="1532704384233" ID="ID_94333518" MODIFIED="1532704388683" TEXT="lockStructureForAlter"/>
<node CREATED="1532705081482" FOLDED="true" ID="ID_2208285" MODIFIED="1533551799384" TEXT="virtual BlockInputStreams read">
<node CREATED="1532718853347" ID="ID_789679851" MODIFIED="1532718885595" TEXT="read a set of columns from the table. returns a stream with which you can read data sequentially or multiple streams for parallel data reading"/>
</node>
<node CREATED="1532705086437" FOLDED="true" ID="ID_1126465481" MODIFIED="1533551799384" TEXT="virtual BlockOutputStreamPtr write">
<node CREATED="1532718900687" ID="ID_39915298" MODIFIED="1532718901116" TEXT="Writes the data to a table"/>
</node>
<node CREATED="1532718903054" FOLDED="true" ID="ID_1912800302" MODIFIED="1533551799384" TEXT="virtual void drop() ">
<node CREATED="1532719009776" ID="ID_123170325" MODIFIED="1532719010190" TEXT="Delete the table data"/>
</node>
<node CREATED="1532719030479" FOLDED="true" ID="ID_331890608" MODIFIED="1533551799384" TEXT="virtual void truncate(const ASTPtr &amp; /*query*/)">
<node CREATED="1532719036918" ID="ID_153621112" MODIFIED="1532719047597">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the table data and leave it empty.&#160;(Must be called under lockForAlter.)
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1532719124756" FOLDED="true" ID="ID_1326349649" MODIFIED="1533551799384" TEXT="virtual void rename(const String &amp; /*new_path_to_db*/, &#xa;const String &amp; /*new_database_name*/, const String &amp; /*new_table_name*/)">
<node CREATED="1532719139794" ID="ID_1460391659" MODIFIED="1532719140320" TEXT="Rename the table"/>
</node>
<node CREATED="1532720647197" ID="ID_1004818275" MODIFIED="1532720651299" TEXT="virtual void alter(const AlterCommands &amp; /*params*/, const String &amp; /*database_name*/, const String &amp; /*table_name*/, const Context &amp; /*context*/)">
<icon BUILTIN="help"/>
</node>
<node CREATED="1532720726418" FOLDED="true" ID="ID_1563635169" MODIFIED="1533551799385" TEXT="virtual void clearColumnInPartition(const ASTPtr &amp; /*partition*/, const Field &amp; /*column_name*/, const Context &amp; /*context*/)">
<node CREATED="1532720731134" ID="ID_1351530695" MODIFIED="1532720731509" TEXT="Execute CLEAR COLUMN ... IN PARTITION query which removes column from given partition."/>
</node>
<node CREATED="1532720750830" FOLDED="true" ID="ID_51271451" MODIFIED="1533551799385" TEXT="virtual void replacePartitionFrom(const StoragePtr &amp; /*source_table*/, const ASTPtr &amp; /*partition*/, bool /*replace*/, const Context &amp;)">
<node CREATED="1532720755996" ID="ID_106323266" MODIFIED="1532720756313" TEXT="Execute ALTER TABLE dst.table REPLACE(ATTACH) PARTITION partition FROM src.table"/>
</node>
<node CREATED="1532720763848" FOLDED="true" ID="ID_1633428200" MODIFIED="1533551799385" TEXT=" virtual void dropPartition(const ASTPtr &amp; /*query*/, const ASTPtr &amp; /*partition*/, bool /*detach*/, const Context &amp; /*context*/)">
<node CREATED="1532720768255" ID="ID_774031014" MODIFIED="1532720768565" TEXT="Run the query (DROP|DETACH) PARTITION."/>
</node>
<node CREATED="1532720776207" FOLDED="true" ID="ID_1222960894" MODIFIED="1533551799385" TEXT=" virtual void attachPartition(const ASTPtr &amp; /*partition*/, bool /*part*/, const Context &amp; /*context*/)">
<node CREATED="1532720780405" ID="ID_1680532000" MODIFIED="1532720780691" TEXT="Run the ATTACH request (PART|PARTITION)"/>
</node>
<node CREATED="1532720787271" FOLDED="true" ID="ID_501222219" MODIFIED="1533551799385" TEXT=" virtual void fetchPartition(const ASTPtr &amp; /*partition*/, const String &amp; /*from*/, const Context &amp; /*context*/)">
<node CREATED="1532720791278" ID="ID_651722084" MODIFIED="1532720791755" TEXT="Run the FETCH PARTITION query."/>
</node>
<node CREATED="1532720843578" FOLDED="true" ID="ID_214468066" MODIFIED="1533551799385" TEXT=" virtual void freezePartition(const ASTPtr &amp; /*partition*/, const String &amp; /*with_name*/, const Context &amp; /*context*/)">
<node CREATED="1532720878253" ID="ID_489724428" MODIFIED="1532720878763" TEXT="Run the FREEZE PARTITION request. That is, create a local backup (snapshot) of data using the `localBackup` function (see localBackup.h)"/>
</node>
<node CREATED="1532720107754" FOLDED="true" ID="ID_410528746" MODIFIED="1533551799385" TEXT="virtual bool optimize(const ASTPtr &amp; /*query*/, const ASTPtr &amp; /*partition*/, &#xa;bool /*final*/, bool /*deduplicate*/, const Context &amp; /*context*/)">
<node CREATED="1532720190477" ID="ID_136187424" MODIFIED="1532720198025" TEXT="Perform any background work. For example, combining parts in a MergeTree type table. Returns whether any work has been done."/>
</node>
<node CREATED="1532720098360" FOLDED="true" ID="ID_1022197684" MODIFIED="1533551799385" TEXT="virtual void mutate(const MutationCommands &amp;, const Context &amp;)">
<node CREATED="1532720104043" ID="ID_165092418" MODIFIED="1532720106442" TEXT="mutate the table contents"/>
</node>
<node CREATED="1532719984910" FOLDED="true" ID="ID_664182444" MODIFIED="1533551799385" TEXT="virtual void startup()">
<node CREATED="1532719992000" ID="ID_897709578" MODIFIED="1532720026523">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      if the table have to do some complicated work on startup, that must be postponed after creation of table object (like launching some background threads), do it in this method. You should call this method after creation of object.
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1532720028818" FOLDED="true" ID="ID_319217550" MODIFIED="1533551799385" TEXT="virtual void shutdown() ">
<node CREATED="1532720049630" ID="ID_1136623140" MODIFIED="1532720066357">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      If the table have to do some complicated work when destroying an object - do it in advance. For example, if the table contains any threads for background work, ask them to complete and wait for completion.
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1532719819863" ID="ID_1588350435" MODIFIED="1532719922010" TEXT="virtual ActionLock getActionLock(StorageActionBlockType /* action_type */)">
<icon BUILTIN="help"/>
</node>
<node CREATED="1532719656939" FOLDED="true" ID="ID_44841100" MODIFIED="1533551799385" TEXT=" virtual bool mayBenefitFromIndexForIn(const ASTPtr &amp; /* left_in_operand */) ">
<node CREATED="1532719817930" ID="ID_1081810954" MODIFIED="1532719818376" TEXT="Provides a hint that the storage engine may evaluate the IN-condition by using an index."/>
</node>
<node CREATED="1532719649834" FOLDED="true" ID="ID_1548780810" MODIFIED="1533551799386" TEXT="virtual bool checkData()">
<node CREATED="1532719655365" ID="ID_1164107798" MODIFIED="1532719655648" TEXT="Checks validity of the data"/>
</node>
<node CREATED="1532719600694" FOLDED="true" ID="ID_1572588517" MODIFIED="1533551799386" TEXT="virtual bool checkTableCanBeDropped() ">
<node CREATED="1532719605798" ID="ID_1594019084" MODIFIED="1532719606103" TEXT="Checks that table could be dropped right now"/>
</node>
<node CREATED="1532719619607" FOLDED="true" ID="ID_1624585210" MODIFIED="1533551799386" TEXT="virtual void updateDependencies()">
<icon BUILTIN="help"/>
<node CREATED="1532719624551" ID="ID_676873431" MODIFIED="1532719625697" TEXT="Notify engine about updated dependencies for this storage"/>
</node>
<node CREATED="1532719152060" FOLDED="true" ID="ID_629992990" MODIFIED="1533551799386" TEXT="virtual String getDataPath() ">
<node CREATED="1532719419554" ID="ID_350306201" MODIFIED="1532719419930" TEXT="Returns data path if storage supports it, empty string otherwise."/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_1234533495" MODIFIED="1530079245976" TEXT="classes"/>
</node>
<node CREATED="1530005452269" ID="ID_357309205" LINK="ClickHouse/dbms/src/Storages/StorageMemory.h" MODIFIED="1534156586760" TEXT="StorageMemory.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_1111494354" MODIFIED="1533522519535" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_709874752" MODIFIED="1533551799386" TEXT="description">
<node CREATED="1532725650248" ID="ID_432515800" MODIFIED="1532985088591" TEXT="store data simply in memory"/>
</node>
<node CREATED="1530013560221" FOLDED="true" ID="ID_621979835" MODIFIED="1533551799387" TEXT="members">
<node CREATED="1532721362729" FOLDED="true" ID="ID_492353017" MODIFIED="1533551799386" TEXT="String">
<node CREATED="1532721366001" ID="ID_1023754596" MODIFIED="1532721370849" TEXT="table_name : "/>
</node>
<node CREATED="1532721427720" FOLDED="true" ID="ID_1351824628" MODIFIED="1533551799386" TEXT="BlocksList (list&lt;Block&gt;">
<node CREATED="1532721431413" ID="ID_1967216265" MODIFIED="1532721433549" TEXT="data : "/>
</node>
<node CREATED="1532721440734" FOLDED="true" ID="ID_1466503058" MODIFIED="1533551799387" TEXT="std::mutex">
<node CREATED="1532721444168" ID="ID_1807544667" MODIFIED="1532721447912" TEXT="mutex : "/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_248319100" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" FOLDED="true" ID="ID_1065665193" MODIFIED="1533551799387" TEXT="functions">
<node CREATED="1532721489191" FOLDED="true" ID="ID_1848703346" MODIFIED="1533551799387" TEXT="void drop()">
<node CREATED="1532721516313" ID="ID_1162639926" MODIFIED="1532721526048" TEXT="make data an empty list"/>
</node>
<node CREATED="1532721514857" FOLDED="true" ID="ID_903494254" MODIFIED="1533551799387" TEXT="void truncate(const ASTPtr &amp;)">
<node CREATED="1532721526912" ID="ID_1113126583" MODIFIED="1532721531823" TEXT="same as drop()"/>
</node>
<node CREATED="1532723826899" FOLDED="true" ID="ID_1687457003" MODIFIED="1533551799387" TEXT="read">
<node CREATED="1532724510484" ID="ID_679042308" MODIFIED="1532724609878" TEXT="divide BlockList into &quot;num_streams&quot; number of evenly distributed blocks, and associate a MemoryBlockInputStream with each fraction of blocks"/>
</node>
<node CREATED="1532723767374" FOLDED="true" ID="ID_32294348" MODIFIED="1533551799387" TEXT="write">
<node CREATED="1532723769392" ID="ID_1976519612" MODIFIED="1532723823676" TEXT="return a MemoryBlockOutputStream, whose storage is a reference to *this, so that it will write block to *this.data"/>
</node>
<node CREATED="1532723824703" FOLDED="true" ID="ID_1945522503" MODIFIED="1533551799387" TEXT="registerStorageMemory">
<node CREATED="1532986196475" ID="ID_280255667" MODIFIED="1532986406316" TEXT="there is a singleton object of type StorageFactory, which has a std::unordered_map&lt;std::string, Creator&gt;, and registerStorageMemory just put pair (&quot;Memory&quot;, some Creator function) into the map (for purpose of registration)"/>
</node>
</node>
<node CREATED="1530014254828" FOLDED="true" ID="ID_1295085382" MODIFIED="1533551799389" TEXT="classes">
<node CREATED="1532721602080" FOLDED="true" ID="ID_916002258" LINK="#ID_879238537" MODIFIED="1533551799388" TEXT="class MemoryBlockInputStream : public IProfilingBlockInputStream">
<node CREATED="1532722908865" FOLDED="true" ID="ID_1549671368" MODIFIED="1533551799388" TEXT="members">
<node CREATED="1532722912398" FOLDED="true" ID="ID_1746546967" MODIFIED="1533551799387" TEXT="Names">
<node CREATED="1532722916045" ID="ID_936080371" MODIFIED="1532723150958" STYLE="fork" TEXT="column_names : specify the name of columns to get from each block"/>
</node>
<node CREATED="1532722918364" FOLDED="true" ID="ID_709406885" MODIFIED="1533551799387" TEXT="BlocksList::iterator">
<node CREATED="1532722934688" ID="ID_1411747539" MODIFIED="1532722936698" TEXT="begin : "/>
</node>
<node CREATED="1532722926387" FOLDED="true" ID="ID_1493093451" MODIFIED="1533551799387" TEXT="BlocksList::iterator">
<node CREATED="1532722937803" ID="ID_53352959" MODIFIED="1532722939458" TEXT="end :"/>
</node>
<node CREATED="1532722928264" FOLDED="true" ID="ID_1107639082" MODIFIED="1533551799388" TEXT="BlocksList::iterator">
<node CREATED="1532722940424" ID="ID_228767660" MODIFIED="1532722941978" TEXT="it : "/>
</node>
<node CREATED="1532722942644" FOLDED="true" ID="ID_1360395051" MODIFIED="1533551799388" TEXT="const StorageMemory &amp;">
<node CREATED="1532722949821" ID="ID_815285350" MODIFIED="1532722952322" TEXT="storage : "/>
</node>
</node>
<node CREATED="1532722652214" FOLDED="true" ID="ID_655003769" MODIFIED="1533551799388" TEXT="functions">
<node CREATED="1532722655854" FOLDED="true" ID="ID_1874834093" MODIFIED="1533551799388" TEXT="readImpl">
<node CREATED="1532722658124" ID="ID_476476161" MODIFIED="1532722771132" TEXT="similar to readImpl from BlocksListBlockInputStream.h, it reads one block at a time from BlockList"/>
</node>
</node>
</node>
<node CREATED="1532721608712" FOLDED="true" ID="ID_1860540765" LINK="#ID_580736226" MODIFIED="1533551799388" TEXT="class MemoryBlockOutputStream : public IBlockOutputStream">
<node CREATED="1532723789122" FOLDED="true" ID="ID_390350606" MODIFIED="1533551799388" TEXT="members">
<node CREATED="1532722942644" FOLDED="true" ID="ID_1229761330" MODIFIED="1533551799388" TEXT="const StorageMemory &amp;">
<node CREATED="1532722949821" ID="ID_1495139694" MODIFIED="1532722952322" TEXT="storage : "/>
</node>
</node>
<node CREATED="1532722867375" FOLDED="true" ID="ID_1292440797" MODIFIED="1533551799388" TEXT="functions">
<node CREATED="1532722876499" FOLDED="true" ID="ID_1356260722" MODIFIED="1533551799388" TEXT=" void write(const Block &amp; block)">
<node CREATED="1532722878328" ID="ID_1733390814" MODIFIED="1532722891819" TEXT="write block to storage.data"/>
</node>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1530005454749" ID="ID_653038433" LINK="ClickHouse/dbms/src/Storages/StorageMemory.cpp" MODIFIED="1530005527763" TEXT="StorageMemory.cpp"/>
<node CREATED="1530005469987" ID="ID_582147459" LINK="ClickHouse/dbms/src/Storages/StorageTinyLog.h" MODIFIED="1533616768699" TEXT="StorageTinyLog.h">
<node CREATED="1530014296023" ID="ID_271610067" MODIFIED="1534163202341" TEXT="properties">
<node CREATED="1530013557169" ID="ID_104696902" MODIFIED="1530081562328" TEXT="description">
<node CREATED="1534156552423" ID="ID_483979163" LINK="illustration_of_createTable_insertInto_for_StorageTinyLog.png" MODIFIED="1534156574364" TEXT="store data in log files on disk, see illustration"/>
</node>
<node CREATED="1530013560221" ID="ID_1104173838" MODIFIED="1533616770655" TEXT="members">
<node CREATED="1532986515135" FOLDED="true" ID="ID_480785174" MODIFIED="1533551799389" TEXT="String">
<node CREATED="1532986552810" ID="ID_331923312" MODIFIED="1532986553942" TEXT="path : "/>
</node>
<node CREATED="1532986515947" FOLDED="true" ID="ID_1616995595" MODIFIED="1533551799389" TEXT="String">
<node CREATED="1532986559929" ID="ID_530052976" MODIFIED="1532986561365" TEXT="name : "/>
</node>
<node CREATED="1532986520344" FOLDED="true" ID="ID_1121790621" MODIFIED="1533551799390" TEXT="size_t">
<node CREATED="1532986564850" ID="ID_1620423301" MODIFIED="1532986569731" TEXT="max_compress_block_size : "/>
</node>
<node CREATED="1532986523604" ID="ID_232358456" MODIFIED="1533877476059" TEXT="Files_t">
<node CREATED="1532986575279" ID="ID_965182172" MODIFIED="1532986576460" TEXT="files : "/>
</node>
<node CREATED="1532986526807" FOLDED="true" ID="ID_661643769" MODIFIED="1533551799390" TEXT="FileChecker">
<node CREATED="1532986582382" ID="ID_1261507394" MODIFIED="1532986583968" TEXT="file_checker : "/>
</node>
<node CREATED="1532986533866" FOLDED="true" ID="ID_458458920" MODIFIED="1533551799390" TEXT="Logger *">
<node CREATED="1532986587384" ID="ID_1550208594" MODIFIED="1532986588281" TEXT="log : "/>
</node>
</node>
<node CREATED="1530013563312" ID="ID_702156688" MODIFIED="1533616771569" TEXT="concepts">
<node CREATED="1533551879653" ID="ID_1437951259" LINK="https://stackoverflow.com/questions/29136749/what-does-typename-mean-in-the-template-parameters" MODIFIED="1533551896483" TEXT="usage of &quot;typename = &quot;"/>
<node CREATED="1533551872244" ID="ID_1443253305" LINK="https://eli.thegreenplace.net/2014/sfinae-and-enable_if/" MODIFIED="1534163214560" TEXT="SFINAE">
<node CREATED="1533552037771" ID="ID_957808280" LINK="#ID_1241805856" MODIFIED="1533605694332" TEXT="used in flatten -&gt; create, see link for illustration"/>
</node>
</node>
<node CREATED="1530014251553" ID="ID_1834979380" MODIFIED="1530014254314" TEXT="functions">
<node CREATED="1533877184451" ID="ID_1379478907" MODIFIED="1533877189866" TEXT="StorageTinyLog::StorageTinyLog(&#xa;    const std::string &amp; path_,&#xa;    const std::string &amp; name_,&#xa;    const ColumnsDescription &amp; columns_,&#xa;    bool attach,&#xa;    size_t max_compress_block_size_)&#xa;    : IStorage{columns_},&#xa;    path(path_), name(name_),&#xa;    max_compress_block_size(max_compress_block_size_),&#xa;    file_checker(path + escapeForFileName(name) + &apos;/&apos; + &quot;sizes.json&quot;),&#xa;    log(&amp;Logger::get(&quot;StorageTinyLog&quot;))">
<node CREATED="1533877229978" ID="ID_1053063602" LINK="#ID_1415108369" MODIFIED="1533877556900">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      1. create a directory at given directory path_ + name_ + &quot;/&quot;
    </p>
    <p>
      2. call addFiles on each column from getColumns().getAllPhyiscal()
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1533877454965" ID="ID_1415108369" MODIFIED="1533877462686" TEXT="void addFiles(const String &amp; column_name, const IDataType &amp; type)">
<node CREATED="1533877684780" ID="ID_1012596609" MODIFIED="1533877935536" TEXT="1. if &quot;column_name&quot; is not in the map &quot;files&quot;, throw"/>
<node CREATED="1533877936041" ID="ID_746143395" MODIFIED="1533880177743">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      2. create a StreamCallback funciton as following:
    </p>
    <p>
      &#160;i). stream_name = getFileNameForStream(column_name, substream_path);
    </p>
    <p>
      &#160;ii). if stream_name is not already in map &quot;files&quot;, insert the pair {column_name, Poco::File(path + escapeForFileName(name) + '/' + stream_name + &quot;.bin&quot;)} into &quot;files&quot;
    </p>
    <p>
      &#160;iii). calls type.enumerateStreams(stream_callback, {})
    </p>
    <p>
      
    </p>
    <p>
      note that it seems File::File(const std::string&amp; rPath): FileImpl(rPath) ctor only stores the string in class Poco::FileImple 's member &quot;_path&quot;, and it does not open(create) a &quot;.bin&quot; file to store data. (it's used for the purpose of storing metadata?) Instead, &quot;.bin&quot; files are created during readData and writeData (see link)
    </p>
  </body>
</html></richcontent>
<node CREATED="1533880178747" ID="ID_92770734" LINK="#ID_1732761031" MODIFIED="1533880199052" TEXT="readData"/>
<node CREATED="1533880183171" ID="ID_1802228257" LINK="#ID_409261821" MODIFIED="1533880203704" TEXT="writeData"/>
</node>
<node CREATED="1533878445100" ID="ID_968265764" LINK="#ID_607696889" MODIFIED="1533878666447" TEXT="3. type.enumerateStreams(stream_callback, {})"/>
</node>
<node CREATED="1534139588648" ID="ID_1518048364" MODIFIED="1534139592119" TEXT="BlockInputStreams StorageTinyLog::read(&#xa;    const Names &amp; column_names,&#xa;    const SelectQueryInfo &amp; /*query_info*/,&#xa;    const Context &amp; context,&#xa;    QueryProcessingStage::Enum &amp; processed_stage,&#xa;    const size_t max_block_size,&#xa;    const unsigned /*num_streams*/)">
<node CREATED="1534139592968" ID="ID_1191746035" MODIFIED="1534139620160" TEXT="return BlockInputStreams(1, std::make_shared&lt;TinyLogBlockInputStream&gt;( max_block_size, Nested::collect(getColumns().getAllPhysical().addTypes(column_names)), *this, context.getSettingsRef().max_read_buffer_size));"/>
</node>
<node CREATED="1533882656255" ID="ID_1733261837" MODIFIED="1533883440108">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      BlockOutputStreamPtr StorageTinyLog::write(
    </p>
    <p>
      &#160;&#160;&#160;&#160;const ASTPtr &amp; /*query*/, const Settings &amp; /*settings*/)
    </p>
  </body>
</html></richcontent>
<node CREATED="1533883635810" ID="ID_1639265113" MODIFIED="1533883644560" TEXT="return make_shared&lt;TinyLogBlockOutputStream&gt;(*this)"/>
</node>
</node>
<node CREATED="1530014254828" ID="ID_122247589" MODIFIED="1533616774747" TEXT="classes">
<node CREATED="1533877512467" ID="ID_1730139995" MODIFIED="1533877521356" TEXT="struct ColumnData">
<node CREATED="1533877521830" ID="ID_538615726" MODIFIED="1533877524331" TEXT="members">
<node CREATED="1533877528105" ID="ID_1405239866" MODIFIED="1533877528357" TEXT="Poco::File data_file"/>
</node>
</node>
<node CREATED="1532721602080" FOLDED="true" ID="ID_119221167" LINK="#ID_879238537" MODIFIED="1533883701415" TEXT="class TinyLogBlockInputStream : public IProfilingBlockInputStream">
<node CREATED="1532989200693" ID="ID_1869771431" MODIFIED="1533617386411" TEXT="members">
<node CREATED="1532989207758" ID="ID_1044361311" MODIFIED="1533617386415" TEXT="size_t">
<node CREATED="1532989244397" ID="ID_1423087041" MODIFIED="1532989246678" TEXT="block_size : "/>
</node>
<node CREATED="1532989212205" ID="ID_598064003" MODIFIED="1533617386416" TEXT="NamesAndTypesList">
<node CREATED="1532989251222" ID="ID_148065768" MODIFIED="1532989255849" TEXT="columns : "/>
</node>
<node CREATED="1532989219193" ID="ID_1683559677" MODIFIED="1533617386416" TEXT="StorageTinyLog &amp;">
<node CREATED="1532989264912" ID="ID_264056060" MODIFIED="1532989271696" TEXT="storage : "/>
</node>
<node CREATED="1532989234745" ID="ID_533863784" MODIFIED="1533617386417" TEXT="bool">
<node CREATED="1532989268912" ID="ID_481426968" MODIFIED="1532989270197" TEXT="finished = false"/>
</node>
<node CREATED="1532989238060" ID="ID_368622918" MODIFIED="1533617386417" TEXT="size_t">
<node CREATED="1532989275169" ID="ID_1028293349" MODIFIED="1532989280717" TEXT="max_read_buffer_size"/>
</node>
<node CREATED="1533617345234" ID="ID_461205402" MODIFIED="1533617386418" TEXT="std::map&lt;std::string, std::unique_ptr&lt;Stream&gt;&gt; (FileStreams)">
<node CREATED="1533617359052" ID="ID_17035714" MODIFIED="1533617361049" TEXT="streams : "/>
</node>
</node>
<node CREATED="1532722652214" ID="ID_479943428" MODIFIED="1533617296299" TEXT="functions">
<node CREATED="1533883696121" ID="ID_650363487" MODIFIED="1533883697254" TEXT="TinyLogBlockInputStream(size_t block_size_, const NamesAndTypesList &amp; columns_, StorageTinyLog &amp; storage_, size_t max_read_buffer_size_)">
<node CREATED="1533883697775" ID="ID_289055916" MODIFIED="1533883699401" TEXT="ctor"/>
</node>
<node CREATED="1533616871612" ID="ID_1193399290" MODIFIED="1533616872306" TEXT="getName">
<node CREATED="1533616872731" ID="ID_389745616" MODIFIED="1533616879681" TEXT="return &quot;TinyLog&quot;"/>
</node>
<node CREATED="1533616880785" ID="ID_77869179" MODIFIED="1533616885208" TEXT="getHeader">
<node CREATED="1533617186292" ID="ID_752208714" LINK="#ID_498296618" MODIFIED="1533617209143" TEXT="create a header block with flatten"/>
</node>
<node CREATED="1532722655854" ID="ID_857621989" MODIFIED="1533617300522" TEXT="readImpl">
<node CREATED="1532722658124" ID="ID_1608048779" MODIFIED="1533879915727" TEXT="for each column in &quot;columns&quot;, create a MutableColumn of the same type,  then call readData to fill in the column, and then insert that column to &quot;res&quot; block. At last, return flatten(res)."/>
</node>
<node CREATED="1533617414208" ID="ID_1732761031" MODIFIED="1533617414622" TEXT="void readData(const String &amp; name, const IDataType &amp; type, IColumn &amp; column, size_t limit)">
<node CREATED="1533880316365" ID="ID_1154416005" MODIFIED="1533880695585">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      1.&#160;
    </p>
    <p>
      InputStreamGetter stream_getter = [&amp;] (const SubstreamPath &amp; path) -&gt; ReadBuffer *
    </p>
    <p>
      {
    </p>
    <p>
      &#160;&#160;&#160;&#160;String stream_name = IDataType::getFileNameForStream(name, path);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;if (!streams.count(stream_name))
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;streams[stream_name] = std::make_unique&lt;Stream&gt;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;(storage.files[stream_name].data_file.path(), max_read_buffer_size);
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;return &amp;streams[stream_name]-&gt;compressed;
    </p>
    <p>
      };
    </p>
    <p>
      
    </p>
    <p>
      firstly, it gets &quot;stream_name&quot; from &quot;name&quot; and &quot;path&quot;. If &quot;stream_name&quot; is not already in &quot;streams&quot;, then it creates a new Stream object (which opens/creates a file), and return the compressed buffer of that Stream object
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1533617324983" ID="ID_342526020" MODIFIED="1533617326343" TEXT="classes">
<node CREATED="1533617326921" ID="ID_930222519" MODIFIED="1533617327552" TEXT="Stream">
<node CREATED="1533871030230" ID="ID_1193971165" MODIFIED="1533871032193" TEXT="functions">
<node CREATED="1533871032778" ID="ID_772658010" MODIFIED="1533871212169" TEXT=" Stream(const std::string &amp; data_path, size_t max_read_buffer_size)"/>
</node>
<node CREATED="1533870963071" ID="ID_599403963" MODIFIED="1533870976907" TEXT="members">
<node CREATED="1533870977484" ID="ID_1090843435" MODIFIED="1533870978791" TEXT="ReadBufferFromFile">
<node CREATED="1533870982839" ID="ID_714646905" MODIFIED="1533875700378" TEXT="plain : use ReadBufferFromFile to open(create) a file at given &quot;data_path&quot;."/>
</node>
<node CREATED="1533870993113" ID="ID_610343317" MODIFIED="1533870993703" TEXT="CompressedReadBuffer">
<node CREATED="1533870994192" ID="ID_1395648240" MODIFIED="1533875725762" TEXT="compressed : create a CompressedReadBuffer from &quot;plain&quot;"/>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1532721608712" FOLDED="true" ID="ID_1988561370" LINK="#ID_580736226" MODIFIED="1533883702382" TEXT="class TinyLogBlockOutputStream : public IBlockOutputStream">
<node CREATED="1532723789122" ID="ID_1122854765" MODIFIED="1533871040508" TEXT="members">
<node CREATED="1532722942644" ID="ID_1799082452" MODIFIED="1533871322132" TEXT="StorageTinyLog &amp;">
<node CREATED="1532722949821" ID="ID_1618476737" MODIFIED="1532722952322" TEXT="storage : "/>
</node>
<node CREATED="1533871324949" ID="ID_478860084" MODIFIED="1533871329760" TEXT="bool">
<node CREATED="1533871332089" ID="ID_22033264" MODIFIED="1533871336400" TEXT="done=false"/>
</node>
<node CREATED="1533617345234" ID="ID_1026628225" MODIFIED="1533617386418" TEXT="std::map&lt;std::string, std::unique_ptr&lt;Stream&gt;&gt; (FileStreams)">
<node CREATED="1533617359052" ID="ID_1466093959" MODIFIED="1533617361049" TEXT="streams : "/>
</node>
</node>
<node CREATED="1532722867375" ID="ID_1868559411" MODIFIED="1533871041169" TEXT="functions">
<node CREATED="1533883665647" ID="ID_631020843" MODIFIED="1533883665961" TEXT="TinyLogBlockOutputStream(StorageTinyLog &amp; storage_)">
<node CREATED="1533883666544" ID="ID_1428851015" MODIFIED="1533883669753" TEXT="ctor"/>
</node>
<node CREATED="1533871427365" ID="ID_582718134" MODIFIED="1533871427991" TEXT="getHeader">
<node CREATED="1533875807841" ID="ID_1985461383" MODIFIED="1533875812234" TEXT="return a header block"/>
</node>
<node CREATED="1532722876499" ID="ID_725969929" MODIFIED="1533871042588" TEXT=" void write(const Block &amp; block)">
<node CREATED="1532722878328" ID="ID_192197481" MODIFIED="1533882578191" TEXT="check block, then call writeData to output data"/>
</node>
<node CREATED="1533871449006" ID="ID_535866785" MODIFIED="1533871449468" TEXT="void writeSuffix()"/>
<node CREATED="1533871458140" ID="ID_409261821" MODIFIED="1533871458582" TEXT=" void writeData(const String &amp; name, const IDataType &amp; type, const IColumn &amp; column, WrittenStreams &amp; written_streams)">
<node CREATED="1533882238359" ID="ID_1060214826" LINK="#ID_1732761031" MODIFIED="1533882246937" TEXT="similar to readData"/>
</node>
</node>
<node CREATED="1533617326921" ID="ID_1427369924" MODIFIED="1533617327552" TEXT="Stream">
<node CREATED="1533871030230" ID="ID_189038567" MODIFIED="1533871032193" TEXT="functions">
<node CREATED="1533871032778" ID="ID_700369495" MODIFIED="1533871034737" TEXT="ctor"/>
</node>
<node CREATED="1533870963071" ID="ID_579220417" MODIFIED="1533870976907" TEXT="members">
<node CREATED="1533870977484" ID="ID_1261339093" MODIFIED="1533871067238" TEXT="WriteBufferFromFile">
<node CREATED="1533870982839" ID="ID_207323801" MODIFIED="1533875762681" TEXT="plain : use WriteBufferFromFile to open(create) a file at given &quot;data_path&quot;"/>
</node>
<node CREATED="1533870993113" ID="ID_678701039" MODIFIED="1533870993703" TEXT="CompressedReadBuffer">
<node CREATED="1533870994192" ID="ID_8969440" MODIFIED="1533875749559" TEXT="compressed : create a CompressedWriteBuffer from &quot;plain&quot;"/>
</node>
</node>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1530005473258" ID="ID_589520780" LINK="ClickHouse/dbms/src/Storages/StorageTinyLog.cpp" MODIFIED="1530005549740" TEXT="StorageTinyLog.cpp"/>
<node CREATED="1532978308609" ID="ID_327019211" MODIFIED="1533871053509" TEXT="StorageMergeTree">
<node CREATED="1532978325917" ID="ID_25480498" MODIFIED="1534156928973" TEXT="concepts">
<node CREATED="1532978355931" ID="ID_1026447314" LINK="https://www.youtube.com/watch?v=TOb1tuEZ2X4" MODIFIED="1532978376664" TEXT="what is b-tree?"/>
<node CREATED="1532978377530" ID="ID_84851307" LINK="https://www.geeksforgeeks.org/database-file-indexing-b-tree-introduction/" MODIFIED="1532978400320" TEXT="what is b+tree?"/>
<node CREATED="1532978340100" ID="ID_229857416" LINK="https://stackoverflow.com/questions/870218/differences-between-b-trees-and-b-trees" MODIFIED="1532978354173" TEXT="difference between b-tree and b+tree"/>
<node CREATED="1532978441976" ID="ID_411677403" LINK="http://www.ovaistariq.net/733/understanding-btree-indexes-and-how-they-impact-performance/#.W19gNNVKjIU" MODIFIED="1532978702577" TEXT="why use b+tree in dbms?"/>
</node>
</node>
</node>
<node CREATED="1529917897302" ID="ID_106472226" LINK="ClickHouse/dbms/src/Storages/IStorage.cpp" MODIFIED="1529918353304" TEXT="IStorage.cpp"/>
</node>
<node CREATED="1529918308883" ID="ID_865739899" LINK="ClickHouse/dbms/src/Storages/ITableDeclaration.cpp" MODIFIED="1529918378676" TEXT="ITableDeclaration.cpp"/>
</node>
<node CREATED="1529562014757" ID="ID_1590413864" MODIFIED="1529562014757" TEXT=""/>
</node>
</node>
<node CREATED="1529923966810" FOLDED="true" ID="ID_1245390223" MODIFIED="1533616736167" POSITION="left" TEXT="libs">
<node CREATED="1529923988820" FOLDED="true" ID="ID_369597067" MODIFIED="1533616736167" TEXT="libcommon">
<node CREATED="1529924141247" FOLDED="true" ID="ID_267079515" MODIFIED="1533616736166" TEXT="include">
<node CREATED="1529923994050" FOLDED="true" ID="ID_1356901900" MODIFIED="1533616736165" TEXT="ext">
<node CREATED="1529924034164" ID="ID_894056024" LINK="ClickHouse/libs/libcommon/include/ext/collection_cast.h" MODIFIED="1529924129649" TEXT="collection_cast.h"/>
<node CREATED="1530531353007" ID="ID_1725084667" LINK="ClickHouse/libs/libcommon/include/ext/bit_cast.h" MODIFIED="1530531386734" TEXT="bit_cast.h"/>
<node CREATED="1532725939358" ID="ID_398457006" LINK="ClickHouse/libs/libcommon/include/ext/singleton.h" MODIFIED="1532725975083" TEXT="singleton.h"/>
</node>
<node CREATED="1530168853182" FOLDED="true" ID="ID_66568724" MODIFIED="1533616736166" TEXT="common">
<node CREATED="1530168860102" FOLDED="true" ID="ID_1483168673" LINK="ClickHouse/libs/libcommon/include/common/StringRef.h" MODIFIED="1533616736165" TEXT="StringRef.h">
<node CREATED="1530014296023" FOLDED="true" ID="ID_153242781" MODIFIED="1533611593985" TEXT="properties">
<node CREATED="1530013557169" FOLDED="true" ID="ID_1484582337" MODIFIED="1530912173987" TEXT="description">
<node CREATED="1530168921196" ID="ID_221721650" MODIFIED="1530168959632" TEXT="a reference object to string, underlying data structure is a pointer and a size"/>
</node>
<node CREATED="1530013560221" ID="ID_140765821" MODIFIED="1530013562255" TEXT="members"/>
<node CREATED="1530013563312" ID="ID_760020989" MODIFIED="1530079240505" TEXT="concepts"/>
<node CREATED="1530014251553" ID="ID_433715952" MODIFIED="1530014254314" TEXT="functions"/>
<node CREATED="1530014254828" ID="ID_1306995657" MODIFIED="1530079245976" TEXT="classes"/>
</node>
</node>
<node CREATED="1530170007831" ID="ID_892842922" LINK="ClickHouse/libs/libcommon/include/common/find_first_symbols.h" MODIFIED="1530170022483" TEXT="find_first_symbols.h"/>
<node CREATED="1530267598401" ID="ID_1551063807" LINK="ClickHouse/libs/libcommon/include/common/likely.h" MODIFIED="1530267617453" TEXT="likely.h"/>
</node>
</node>
</node>
</node>
</node>
</map>
