<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1531926947501" ID="ID_1910419224" LINK="ClickHouse/dbms/programs/main.cpp" MODIFIED="1531927367615">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int main(int argc_, char ** argv_)
    </p>
    <p>
      dbms\programs\main.cpp 144 - 174
    </p>
  </body>
</html></richcontent>
<node CREATED="1531927019521" ID="ID_1281781207" LINK="ClickHouse/dbms/programs/server/Server.cpp" MODIFIED="1531927420627" POSITION="right">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int mainEntryClickHouseServer(int argc, char ** argv)
    </p>
    <p>
      dbms\programs\server\Server.cpp 618 - 631
    </p>
  </body>
</html></richcontent>
<node CREATED="1531927473067" ID="ID_1056316842" LINK="ClickHouse/contrib/poco/Util/src/ServerApplication.cpp" MODIFIED="1531927583741">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int ServerApplication::run(int argc, char** pArgv)
    </p>
    <p>
      contrib\poco\Util\src\ServerApplication.cpp 597 - 619
    </p>
  </body>
</html></richcontent>
<node CREATED="1531927473067" ID="ID_1065846038" LINK="ClickHouse/contrib/poco/Util/src/ServerApplication.cpp" MODIFIED="1531927693936">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int ServerApplication::run()
    </p>
    <p>
      contrib\poco\Util\src\ServerApplication.cpp 92 - 95
    </p>
  </body>
</html></richcontent>
<node CREATED="1531927587633" ID="ID_1583803772" LINK="ClickHouse/contrib/poco/Util/src/Application.cpp" MODIFIED="1531927760977">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int Application::run()
    </p>
    <p>
      contrib\poco\Util\src\ServerApplication.cpp 327 - 352
    </p>
  </body>
</html></richcontent>
<node CREATED="1531927811917" ID="ID_1992419036" LINK="ClickHouse/dbms/programs/server/Server.cpp" MODIFIED="1531927871858">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      void Server::initialize(Poco::Util::Application &amp; self)
    </p>
    <p>
      dbms\programs\server\Server.cpp 79 - 83
    </p>
  </body>
</html></richcontent>
<node CREATED="1531927881179" ID="ID_819949918" LINK="ClickHouse/libs/libdaemon/src/BaseDaemon.cpp" MODIFIED="1531928059463">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      void BaseDaemon::initialize(Application &amp; self)
    </p>
    <p>
      libs\libdaemon\src 847 - 1082
    </p>
  </body>
</html></richcontent>
<node CREATED="1531928085747" ID="ID_1340390913" MODIFIED="1531928105945">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      line 849
    </p>
    <p>
      task_manager.reset(new Poco::TaskManager)
    </p>
  </body>
</html></richcontent>
<node CREATED="1531928245740" ID="ID_1355403825" LINK="ClickHouse/contrib/poco/Foundation/src/TaskManager.cpp" MODIFIED="1531928334500">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      TaskManager(ThreadPool::ThreadAffinityPolicy affinityPolicy = ThreadPool::TAP_DEFAULT)
    </p>
    <p>
      contrib\poco\Foundation\src\TaskManager.cpp 25 - 28
    </p>
  </body>
</html></richcontent>
<node CREATED="1531928376033" ID="ID_638214251" LINK="ClickHouse/contrib/poco/Foundation/src/ThreadPool.cpp" MODIFIED="1531928575773">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      static ThreadPool&amp; defaultPool(ThreadAffinityPolicy affinityPolicy = TAP_DEFAULT)
    </p>
    <p>
      contrib\poco\Foundation\src\ThreadPool.cpp&#160;588 - 591
    </p>
  </body>
</html></richcontent>
<node CREATED="1531928376033" ID="ID_1492956545" LINK="ClickHouse/contrib/poco/Foundation/src/ThreadPool.cpp" MODIFIED="1531929322014">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      ThreadPool* ThreadPoolSingletonHolder::pool(ThreadPool::ThreadAffinityPolicy affinityPolicy = ThreadPool::TAP_DEFAULT)
    </p>
    <p>
      contrib\poco\Foundation\src\ThreadPool.cpp&#160;562 - 574
    </p>
  </body>
</html></richcontent>
<node CREATED="1531928376033" ID="ID_1298406164" LINK="ClickHouse/contrib/poco/Foundation/src/ThreadPool.cpp" MODIFIED="1531929286918">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      ThreadPool(int minCapacity = 2,
    </p>
    <p>
      int maxCapacity = 16,
    </p>
    <p>
      int idleTime = 60,
    </p>
    <p>
      int stackSize = POCO_THREAD_STACK_SIZE,
    </p>
    <p>
      ThreadAffinityPolicy affinityPolicy = TAP_DEFAULT)
    </p>
    <p>
      contrib\poco\Foundation\src\ThreadPool.cpp&#160;283 - 314
    </p>
  </body>
</html></richcontent>
<node CREATED="1531929180532" ID="ID_841346997" MODIFIED="1531948310279" TEXT="Thread 2 : by changing minCapacity from 2 to 1, now it only start 1 thread (i,e, thread 2), the use of thread 2 is not sure. According to POCO documentation,&quot;The TaskManager manages a collection of tasks and monitors their lifetime.&quot; , but it only appears 3 times in BaseDaemon, and it seems it does no actual work.">
<icon BUILTIN="help"/>
<icon BUILTIN="messagebox_warning"/>
</node>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1531942200209" ID="ID_949282832" MODIFIED="1531942230051">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      line 1076
    </p>
    <p>
      signal_listener_thread.start(*signal_listener);
    </p>
  </body>
</html></richcontent>
<node CREATED="1531942237109" ID="ID_1198341099" MODIFIED="1531948316399">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Thread 3:&#160;&#160;create a thread to do signal logging, and deal with the signals.
    </p>
  </body>
</html></richcontent>
<icon BUILTIN="messagebox_warning"/>
<node CREATED="1531941181916" ID="ID_1335782824" LINK="Thread3_what_it_is_doing_illustration.png" MODIFIED="1531942175576" TEXT="see illustration, typically the class inherits from class Runnable, but here BaseDaemon use a wrapper class SignalListener"/>
<node CREATED="1531941185136" ID="ID_1685141099" LINK="https://blog.csdn.net/WUDAIJUN/article/details/9821583" MODIFIED="1531941224909" TEXT="link"/>
</node>
</node>
</node>
</node>
<node CREATED="1531942416157" ID="ID_851638583" LINK="ClickHouse/dbms/programs/server/Server.cpp" MODIFIED="1531943824127">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int Server::main(const std::vector&lt;std::string&gt; &amp; /*args*/)
    </p>
    <p>
      dbms\programs\server\Server.cpp 90 - 615
    </p>
  </body>
</html></richcontent>
<node CREATED="1531942572076" ID="ID_466834793" MODIFIED="1531942653756">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      line 304
    </p>
    <p>
      loadMetadata(*global_context)
    </p>
  </body>
</html></richcontent>
<node CREATED="1531942657677" ID="ID_741236094" MODIFIED="1531942693774" TEXT="8 threads are about to start during loadMetadata(*global_context), and all will be closed after"/>
</node>
<node CREATED="1531942695818" ID="ID_761529744" MODIFIED="1531943870719">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      line 336
    </p>
    <p>
      dns_cache_updater = std::make_unique&lt;DNSCacheUpdater&gt;(*global_context)
    </p>
  </body>
</html></richcontent>
<node CREATED="1531943873543" ID="ID_988274233" LINK="ClickHouse/dbms/src/Interpreters/DNSCacheUpdater.cpp" MODIFIED="1531943978564">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      DNSCacheUpdater::DNSCacheUpdater(Context &amp; context_)
    </p>
    <p>
      dbms\src\Interpreters\DNSCacheUpdater.cpp 58 - 62
    </p>
  </body>
</html></richcontent>
<node CREATED="1531944035779" ID="ID_916044895" LINK="ClickHouse/dbms/src/Interpreters/Context.cpp" MODIFIED="1531944250181">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      BackgroundProcessingPool &amp; Context::getBackgroundPool()
    </p>
    <p>
      dbms\src\Interpreters\Context.cpp 1325 - 1331
    </p>
  </body>
</html></richcontent>
<node CREATED="1531944668271" ID="ID_1895020612" LINK="ClickHouse/dbms/src/Storages/MergeTree/BackgroundProcessingPool.cpp" MODIFIED="1531944821258">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      BackgroundProcessingPool::BackgroundProcessingPool(int size_) : size(size_)
    </p>
    <p>
      dbms\src\Storages\MergeTree\BackgroundProcessingPool.cpp 55 - 62
    </p>
  </body>
</html></richcontent>
<node CREATED="1531944852227" ID="ID_778719909" MODIFIED="1531948320056" TEXT="Thread 4 : create a thread as dns_cache_updater to a watcher updating DNS cache in case of network errors. There used to be 16 threads, there BackgroundProcessingPool(size_) gets &quot;size_&quot; from (*global_context).settings.background_pool_size.value and (*global_context).settings.background_schedule_pool_size.value. By changing them to 1, now it creates only 1 thread.&#xa;&#xa;How DNSCacheUpdater class works is that it has a BackgroundProcessingPool object, which has the following members:&#xa;1. using Task = std::function&lt;bool()&gt;;&#xa;2.  using Tasks = std::multimap&lt;Poco::Timestamp, TaskHandle&gt;;    &#xa;3. using Threads = std::vector&lt;std::thread&gt;;&#xa;4. Tasks tasks;  &#xa;5. Threads threads;&#xa;and news tasks are added to &quot;tasks&quot;, which functions like a run queue (?), and threads does the work.">
<icon BUILTIN="messagebox_warning"/>
</node>
</node>
</node>
</node>
</node>
<node CREATED="1531946067998" ID="ID_666216444" MODIFIED="1531946098929">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      line&#160;342
    </p>
    <p>
      Poco::ThreadPool server_pool(3, config().getUInt(&quot;max_connections&quot;, 1024))
    </p>
  </body>
</html></richcontent>
<node CREATED="1531946099788" ID="ID_478617505" LINK="#ID_1816788082" MODIFIED="1532072268247">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Thread 5 : this is about to create minCapacity = 3 threads, by changing 3 to 1, it creates only 1 thread.
    </p>
    <p>
      The use of these threads, is later at line 458 for example, when
    </p>
    <p>
      &#160;&#160;&#160;servers.emplace_back(new Poco::Net::TCPServer(
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;new TCPHandlerFactory(*this),
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;server_pool,
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;socket,
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;new Poco::Net::TCPServerParams));
    </p>
    <p>
      TCPServer constructor needs a parameter ThreadPool, which by reading the code from TCPServer, it seems to deal with the connection and communication. See link for details.
    </p>
  </body>
</html></richcontent>
<icon BUILTIN="messagebox_warning"/>
<node CREATED="1532072268273" ID="ID_1073543708" MODIFIED="1532072270795" TEXT="backtrace">
<node CREATED="1532034125848" ID="ID_1388743338" LINK="thread5_bt_after_clickhouse_server_main.PNG" MODIFIED="1532072508853" TEXT="here the threadpool is created, and thread(s) in it is started by calling PooledThread::start(), which directs to PooledThread::run() (which does nothing at the moment), and then PooledThread::start() calls wait, and sample bt can be seen via link (bt remains the same until a connection request received from clickhouse-client), also refer to source code for a better understanding."/>
<node CREATED="1532053451984" ID="ID_512640123" LINK="thread5_bt_after_connection_established.PNG" MODIFIED="1532072512802" TEXT="after connection has been established with a client, the bt can be seen via link"/>
</node>
<node CREATED="1532438799306" ID="ID_782519010" LINK="illustration_of_incoming_connection.png" MODIFIED="1532438817489" TEXT="see what happens when a client request connection"/>
</node>
</node>
<node CREATED="1531947317195" ID="ID_1033268915" MODIFIED="1531947371799" TEXT="line 352 - 519">
<node CREATED="1531946954753" ID="ID_1942875458" MODIFIED="1531947215335">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      line 354
    </p>
    <p>
      listen_hosts.emplace_back(&quot;::1&quot;)
    </p>
  </body>
</html></richcontent>
<node CREATED="1531947216033" ID="ID_306482112" MODIFIED="1531947639114" TEXT="use tbreak +1, jump +1 to skip this line, so that later we have set up less threads. Now listen_hosts only has {&quot;127.0.0.1&quot;}, it used to has {&quot;::1&quot;, &quot;127.0.0.1&quot;}.&#xa;it used to have to create 6 threads to listen on different ports as following&#xa;&#xa;#&lt;Information&gt;Application: Listening http://[::1]:8123&#xa;#&lt;Information&gt; Application: Listening tcp: [::1]:9000&#xa;#&lt;Information&gt; Application: Listening interserver http: [::1]:9009&#xa;#&lt;Information&gt; Application: Listening http://127.0.0.1:8123&#xa;#&lt;Information&gt; Application: Listening tcp: 127.0.0.1:9000 (*)&#xa;#&lt;Information&gt; Application: Listening interserver http: 127.0.0.1:9009&#xa;&#xa;now, it only listens on port &quot;127.0.0.1&quot;"/>
</node>
<node CREATED="1531947388743" ID="ID_1168196578" MODIFIED="1531947721599" TEXT="line 414 - 450">
<node CREATED="1531947697708" ID="ID_1458953122" MODIFIED="1531947859962" TEXT="use tbreak 451, jump 451 to skip these lines, where it put http protocal server into &quot;servers&quot; (each element of &quot;servers&quot; will later be started. By doing this, we will only have tcp 127.0.0.1"/>
</node>
<node CREATED="1531947861400" ID="ID_1272693622" MODIFIED="1531947911927" TEXT="line 452 - 465">
<node CREATED="1531947912399" ID="ID_490829977" MODIFIED="1531947929023" TEXT="run these lines to put tcp protocol server into &quot;servers&quot;"/>
</node>
<node CREATED="1531947929767" ID="ID_949907511" MODIFIED="1531947964476" TEXT="line 468 - 490">
<node CREATED="1531947697708" ID="ID_131053808" MODIFIED="1531948024088" TEXT="use tbreak 491, jump 491 to skip these lines, where it put secure tcp protocal server into &quot;servers&quot; (each element of &quot;servers&quot; will later be started. By doing this, we will only have tcp 127.0.0.1"/>
</node>
<node CREATED="1531948025190" ID="ID_1166172446" MODIFIED="1531948049368" TEXT="line 493 - 506">
<node CREATED="1531948049808" ID="ID_1937375109" MODIFIED="1531948142127" TEXT="run these lines. These lines will add an interserver IO http protocol server to &quot;servers&quot;. I tried to skip it, but doing so will cause seg fault and be catch at line 508"/>
</node>
</node>
<node CREATED="1531948161166" ID="ID_865827846" MODIFIED="1532028665023">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      line 524 - 525
    </p>
    <p>
      for (auto &amp; server : servers)
    </p>
    <p>
      &#160;&#160;&#160;&#160;server-&gt;start();
    </p>
  </body>
</html></richcontent>
<node CREATED="1531948194244" ID="ID_1816788082" MODIFIED="1532028144154">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Thread 6 &amp; 7 : now there are 2 threads (used to be 6 threads) started listening on incoming connections (one for tcp protocol, the other for interserver IO http), the 2 threads are created just to perform &quot;TCPServer::run()&quot;, (see illustration, also see link definition section for a idea of what's going on). After receiving a connection request, it generates a socket and put it into a queue. Then, the threadpool in Thread 5 will deal with the connection and do communication (&quot;sending receiving data?&quot;)
    </p>
  </body>
</html></richcontent>
<icon BUILTIN="messagebox_warning"/>
<icon BUILTIN="help"/>
<node CREATED="1532027425503" ID="ID_134514196" LINK="illustration_of_POCO_TCPServer&amp;Thread.png" MODIFIED="1532027481468" TEXT="see illustration"/>
<node CREATED="1532027483816" ID="ID_10264496" LINK="https://pocoproject.org/docs/Poco.Net.TCPServer.html" MODIFIED="1532027504690" TEXT="see link (POCO TCPServer documentation)"/>
<node CREATED="1532072259220" ID="ID_504844303" MODIFIED="1532072264294" TEXT="backtrace">
<node CREATED="1532072265189" ID="ID_1972734861" LINK="thread6_bt_after_clickhouse_server_main.PNG" MODIFIED="1532072518436" TEXT="bt after running clickhouse-server"/>
<node CREATED="1532146779790" ID="ID_1691624444" LINK="thread6_bt_after_connection_established.PNG" MODIFIED="1532438618351" TEXT="after connection has been established with a client"/>
</node>
</node>
</node>
<node CREATED="1532028052321" ID="ID_1314750373" MODIFIED="1532028672774">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      line 527 - 528
    </p>
    <p>
      main_config_reloader-&gt;start()
    </p>
    <p>
      users_config_reloader-&gt;start()
    </p>
  </body>
</html></richcontent>
<node CREATED="1532028124524" ID="ID_1472765910" LINK="ClickHouse/dbms/src/Common/Config/ConfigReloader.h" MODIFIED="1532028768905" TEXT="Thread 8 &amp; 9 : these 2 threads are created by ConfigReloader, which just periodically checks if the config files have been changed and updates accordingly, according to ConfigReloader.h">
<icon BUILTIN="messagebox_warning"/>
</node>
</node>
<node CREATED="1532028333215" ID="ID_1379384096" MODIFIED="1532028681736">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      line 599
    </p>
    <p>
      AsynchronousMetrics async_metrics(*global_context)
    </p>
  </body>
</html></richcontent>
<node CREATED="1532028688044" ID="ID_35975859" LINK="ClickHouse/dbms/src/Interpreters/AsynchronousMetrics.h" MODIFIED="1532028790581" TEXT="Thread 10: these 2 threads are created by AsynchronousMetrics, which just periodically calculates and updates some metrics, according to AsynchronousMetrics.h">
<icon BUILTIN="messagebox_warning"/>
</node>
</node>
<node CREATED="1532028791618" ID="ID_425561776" MODIFIED="1532028834706">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      line 609
    </p>
    <p>
      SessionCleaner session_cleaner(*global_context)
    </p>
  </body>
</html></richcontent>
<node CREATED="1532028835900" ID="ID_431754428" MODIFIED="1532028961232" TEXT="Thread 11: create a thread to do ? (seems not relevant to work)">
<icon BUILTIN="messagebox_warning"/>
<icon BUILTIN="help"/>
</node>
</node>
</node>
</node>
</node>
</node>
</node>
</node>
</map>
