<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1531450682465" ID="ID_1616358089" MODIFIED="1531451295563" TEXT="clickhouse-server --config-file=/etc/clickhouse-server/config.xml">
<node CREATED="1531451114720" ID="ID_336648579" LINK="ClickHouse/dbms/programs/main.cpp" MODIFIED="1531462328693" POSITION="right">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int main(int argc_, char ** argv_)
    </p>
    <p>
      dbms/programs/main.cpp
    </p>
    <p>
      line 159 - 174
    </p>
  </body>
</html></richcontent>
<node CREATED="1531452264502" ID="ID_735902506" MODIFIED="1531452264502" TEXT="">
<node CREATED="1531452337797" ID="ID_279768099" LINK="ClickHouse/dbms/programs/server/Server.cpp" MODIFIED="1531462363775">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int mainEntryClickHouseServer(int argc, char ** argv)
    </p>
    <p>
      dbms/programs/server/Server.cpp
    </p>
    <p>
      line 618 - 631
    </p>
  </body>
</html></richcontent>
<node CREATED="1531452731471" ID="ID_1702512738" LINK="ClickHouse/contrib/poco/Util/src/ServerApplication.cpp" MODIFIED="1531462422623">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int ServerApplication::run(int argc, char** pArgv)
    </p>
    <p>
      contrib\poco\Util\src/ServerApplication.cpp
    </p>
    <p>
      line 597 - 619
    </p>
  </body>
</html></richcontent>
<node CREATED="1531461833554" ID="ID_1514866318" LINK="ClickHouse/contrib/poco/Util/src/Application.cpp" MODIFIED="1531736961868">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      void Application::init(int argc, char* pArgv[])
    </p>
    <p>
      contrib\poco\Util\src/Application.cpp
    </p>
    <p>
      line 130 - 134
    </p>
  </body>
</html></richcontent>
<node CREATED="1531462160359" ID="ID_601009677" LINK="ClickHouse/contrib/poco/Util/src/Application.cpp" MODIFIED="1531462586501">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      void Application::setArgs(const ArgVec&amp; args)
    </p>
    <p>
      contrib\poco\Util\src/Application.cpp
    </p>
    <p>
      line 361 - 373
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1531462269048" FOLDED="true" ID="ID_1317669975" MODIFIED="1531736995098" TEXT="description">
<node CREATED="1531464449140" ID="ID_1630858368" MODIFIED="1531464745469">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      basically&#160;&#160;this code snippet does the following:
    </p>
    <p>
      1. _command=&quot;/home/glen/ClickHouse_llvm/build/dbms/programs/clickhouse-server&quot;
    </p>
    <p>
      2. _unprocessedArgs = {&quot;/home/glen/ClickHouse_llvm/build/dbms/programs/clickhouse-server&quot;, &quot;--config-file=/etc/clickhouse-server/config.xml&quot;}
    </p>
    <p>
      3. set property pair :
    </p>
    <p>
      (&quot;application.argc&quot;, 2)
    </p>
    <p>
      (&quot;application.argv[0]&quot;, &quot;/home/glen/ClickHouse_llvm/build/dbms/programs/clickhouse-server&quot;)
    </p>
    <p>
      (&quot;application.argv[1]&quot;, &quot;--config-file=/etc/clickhouse-server/config.xml&quot;)
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1531462233115" FOLDED="true" ID="ID_559966448" MODIFIED="1531738635518" TEXT="code">
<node CREATED="1531462250855" ID="ID_1207102493" MODIFIED="1531462580596" TEXT="void Application::setArgs(int argc, char* pArgv[])&#xa;{&#xa;&#x9;_command = pArgv[0];&#xa;&#x9;_pConfig-&gt;setInt(&quot;application.argc&quot;, argc);&#xa;&#x9;_unprocessedArgs.reserve(argc);&#xa;&#x9;std::string argvKey = &quot;application.argv[&quot;;&#xa;&#x9;for (int i = 0; i &lt; argc; ++i)&#xa;&#x9;{&#xa;&#x9;&#x9;std::string arg(pArgv[i]);&#xa;&#x9;&#x9;_pConfig-&gt;setString(argvKey + NumberFormatter::format(i) + &quot;]&quot;, arg);&#xa;&#x9;&#x9;_unprocessedArgs.push_back(arg);&#xa;&#x9;}&#xa;}">
<node CREATED="1531463901576" ID="ID_1118670412" MODIFIED="1531463906244" TEXT="setInt">
<node CREATED="1531463390211" ID="ID_388952568" MODIFIED="1531463451011" TEXT="setInt calls setRawWithEvent(key, NumberFormatter::format(value))"/>
<node CREATED="1531463451984" ID="ID_743853190" MODIFIED="1531463517815" TEXT="NumberFormatter::format(value) converts a base-10 number to string"/>
<node CREATED="1531463519149" ID="ID_522988894" MODIFIED="1531463771180">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      AbstractConfiguration::setRawWithEvent(const std::string&amp; key, std::string value) does the following:
    </p>
    <p>
      1. Create key-value pair (key, value)
    </p>
    <p>
      2. does &quot;propertyChanging(this, kv);&quot;
    </p>
    <p>
      3. setRaw(key, value)
    </p>
    <p>
      4. does &quot;propertyChanged(this, kv);&quot;
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1531463678784" ID="ID_1651486044" MODIFIED="1531463789285" TEXT="Poco::BasicEvent&lt;KeyValue&gt; propertyChanging;&#xa;/// Fired before a property value is changed or&#xa;/// a new property is created.">
<icon BUILTIN="help"/>
</node>
<node CREATED="1531463833364" ID="ID_1290958700" MODIFIED="1531463868665" TEXT="virtual void setRaw(const std::string&amp; key, const std::string&amp; value) = 0;&#xa;&#x9;/// Sets the property with the given key to the given value.&#xa;&#x9;/// An already existing value for the key is overwritten.&#xa;&#x9;/// Must be overridden by subclasses."/>
<node CREATED="1531463708497" ID="ID_1060088937" MODIFIED="1531463838280" TEXT="Poco::BasicEvent&lt;const KeyValue&gt; propertyChanged;&#xa;/// Fired after a property value has been changed&#xa;/// or a property has been created.">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1531463975575" ID="ID_979857983" MODIFIED="1531463989200" TEXT="_unprocessedArgs.reserve(argc)">
<node CREATED="1531463990345" ID="ID_1903860256" MODIFIED="1531464014065" TEXT="_unprocessedArgs is of type std::vector&lt;std::string&gt;, so it just calls vector.reserve"/>
</node>
<node CREATED="1531464015646" ID="ID_873630700" MODIFIED="1531464446962" TEXT="setString same as setInt"/>
</node>
</node>
<node CREATED="1531461833554" ID="ID_630124807" LINK="ClickHouse/contrib/poco/Util/src/Application.cpp" MODIFIED="1531464916844">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      void Application::init()
    </p>
    <p>
      contrib\poco\Util\src/Application.cpp
    </p>
    <p>
      line 130 - 134
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1531464878190" FOLDED="true" ID="ID_290881152" MODIFIED="1531736777674" TEXT="description">
<node CREATED="1531465339330" ID="ID_1361078681" MODIFIED="1531466229564">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      basically&#160;&#160;this code snippet does the following:&#160;
    </p>
    <p>
      1 get application path into appPath, so appPath stores {_node = &quot;&quot;, _device = &quot;&quot;, _name = &quot;clickhouse-server&quot;, _version = &quot;&quot;, _dirs = std::vector of length 6, capacity 6 = {&quot;home&quot;, &quot;glen&quot;, &quot;ClickHouse_llvm&quot;, &quot;build&quot;, &quot;dbms&quot;, &quot;programs&quot;}, _absolute = true} (before all its members are value-initialized)
    </p>
    <p>
      2. set property pairs:
    </p>
    <p>
      (&quot;application.path&quot;, &quot;/home/glen/ClickHouse_llvm/build/dbms/programs/clickhouse-server&quot;)
    </p>
    <p>
      (&quot;application.name, &quot;clickhouse-server&quot;)
    </p>
    <p>
      (&quot;application.baseName, &quot;clickhouse-server&quot;)
    </p>
    <p>
      (&quot;application.dir&quot;, /home/glen/ClickHouse_llvm/build/dbms/programs/&quot;)
    </p>
    <p>
      (&quot;application.configDir&quot;, &quot;/root/.config/clickhouse-server/&quot;)
    </p>
    <p>
      (&quot;application.cacheDir&quot;,&#160;&quot;/root/.cache/clickhouse-server/&quot;)
    </p>
    <p>
      (&quot;application.dataDir&quot;, &quot;/root/.local/share/clickhouse-server/&quot;)
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1531468183111" ID="ID_1016040024" MODIFIED="1531468247750">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      3. calls processOptions which set property pair:
    </p>
    <p>
      (&quot;config-file&quot;, &quot;/etc/clickhouse-server/config.xml&quot;)
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1531464823133" FOLDED="true" ID="ID_710078115" MODIFIED="1531468251884" TEXT="code">
<node CREATED="1531464824422" ID="ID_192384943" MODIFIED="1531468173379" TEXT="void Application::init()&#xa;{&#xa;&#x9;Path appPath;&#xa;&#x9;getApplicationPath(appPath);&#xa;&#x9;_pConfig-&gt;setString(&quot;application.path&quot;, appPath.toString());&#xa;&#x9;_pConfig-&gt;setString(&quot;application.name&quot;, appPath.getFileName());&#xa;&#x9;_pConfig-&gt;setString(&quot;application.baseName&quot;, appPath.getBaseName());&#xa;&#x9;_pConfig-&gt;setString(&quot;application.dir&quot;, appPath.parent().toString());&#xa;&#x9;_pConfig-&gt;setString(&quot;application.configDir&quot;, Path::configHome() + appPath.getBaseName() + Path::separator());&#xa;&#x9;_pConfig-&gt;setString(&quot;application.cacheDir&quot;, Path::cacheHome() + appPath.getBaseName() + Path::separator());&#xa;&#x9;_pConfig-&gt;setString(&quot;application.dataDir&quot;, Path::dataHome() + appPath.getBaseName() + Path::separator());&#xa;&#x9;processOptions();&#xa;}">
<node CREATED="1531465131569" ID="ID_1949048353" MODIFIED="1531465138167" TEXT="getApplicationPath">
<node CREATED="1531465140187" ID="ID_1899541573" LINK="#ID_290881152" MODIFIED="1531465173274" TEXT="get path of clickhouse-server from _command, see detail in description"/>
</node>
<node CREATED="1531464958046" ID="ID_490741750" LINK="#ID_873630700" MODIFIED="1531464983383" TEXT="setString see link"/>
<node CREATED="1531466440228" ID="ID_61507490" MODIFIED="1531466444135" TEXT="processOptions">
<node CREATED="1531466456754" ID="ID_482308233" MODIFIED="1531467029258" TEXT="defines some &quot;_options&quot; and &quot;processor&quot;"/>
<node CREATED="1531467048189" ID="ID_722719628" MODIFIED="1531467149185" TEXT="use &quot;processor&quot; to process all _unprocessedArgs, there is only 1, which is &quot;--config-file=/etc/clickhouse-server/config.xml&quot;."/>
<node CREATED="1531467150238" ID="ID_1293435844" MODIFIED="1531467211478" TEXT="it&apos;s parsed into 2 parts, argName : &quot;config-file&quot;, value : &quot;/etc/clickhouse-server/config.xml&quot;"/>
<node CREATED="1531467695056" ID="ID_1903887162" MODIFIED="1531467784014" TEXT="then it calls &quot;handleOption(argName, value);&quot; which only adds property pairs (&quot;config-file&quot;, &quot;/etc/clickhouse-server/config.xml&quot;)"/>
<node CREATED="1531468148245" ID="ID_177853210" MODIFIED="1531468163425" TEXT="then it calls processor.checkRequired(), which seems to do nothing"/>
</node>
</node>
</node>
</node>
<node CREATED="1531461986371" FOLDED="true" ID="ID_1033228419" MODIFIED="1531736711481" TEXT="description">
<node CREATED="1531462118589" ID="ID_136003391" MODIFIED="1531468336230">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      1. calls setArgs(argc, pArgv)
    </p>
    <p>
      2. calls init()
    </p>
    <p>
      basically, what it does is to set property pairs described in setArgs and init()
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1531461992838" FOLDED="true" ID="ID_254276743" MODIFIED="1531724653143" TEXT="code">
<node CREATED="1531451515298" ID="ID_1793025076" MODIFIED="1531462076606" TEXT="void Application::init(int argc, char* pArgv[])&#xa;{&#xa;&#x9;setArgs(argc, pArgv);&#xa;&#x9;init();&#xa;}"/>
</node>
<node CREATED="1531468403661" ID="ID_1208287593" LINK="ClickHouse/contrib/poco/Util/src/ServerApplication.cpp" MODIFIED="1531468803198">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int ServerApplication::run()
    </p>
    <p>
      contrib\poco\Util\src/ServerApplication.cpp
    </p>
    <p>
      line 92 - 95
    </p>
  </body>
</html></richcontent>
<node CREATED="1531468715665" ID="ID_1906568837" LINK="ClickHouse/contrib/poco/Util/src/Application.cpp" MODIFIED="1531468884051">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int Application::run()
    </p>
    <p>
      contrib\poco\Util\src/Application.cpp
    </p>
    <p>
      line 327 - 352
    </p>
  </body>
</html></richcontent>
<node CREATED="1531469812660" ID="ID_551497372" LINK="ClickHouse/dbms/programs/server/Server.cpp" MODIFIED="1531470971140">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      void Server::initialize(Poco::Util::Application &amp; self)
    </p>
    <p>
      dbms/programs/server/Server.cpp
    </p>
    <p>
      line 79 - 83
    </p>
  </body>
</html></richcontent>
<node CREATED="1531470774604" ID="ID_1053862261" LINK="ClickHouse/libs/libdaemon/src/BaseDaemon.cpp" MODIFIED="1531470989475">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      void BaseDaemon::initialize(Application &amp; self)
    </p>
    <p>
      libs\libdaemon\src\BaseDaemon.cpp
    </p>
    <p>
      line 847 - 1082
    </p>
  </body>
</html></richcontent>
<node CREATED="1531723268966" ID="ID_752738744" LINK="ClickHouse/contrib/poco/Foundation/src/TaskManager.cpp" MODIFIED="1531723387370">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      TaskManager(ThreadPool::ThreadAffinityPolicy affinityPolicy = ThreadPool::TAP_DEFAULT)
    </p>
    <p>
      contrib\poco\Foundation\src\TaskManager.cpp
    </p>
    <p>
      line 25 - 28
    </p>
  </body>
</html></richcontent>
<node CREATED="1531723389541" ID="ID_81595581" LINK="ClickHouse/contrib/poco/Foundation/src/ThreadPool.cpp" MODIFIED="1531723849827">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      static ThreadPool&amp; defaultPool(ThreadAffinityPolicy affinityPolicy = TAP_DEFAULT);
    </p>
    <p>
      contrib\poco\Foundation\src
    </p>
    <p>
      line 588 - 591
    </p>
  </body>
</html></richcontent>
<node CREATED="1531723389541" ID="ID_946567477" LINK="ClickHouse/contrib/poco/Foundation/src/ThreadPool.cpp" MODIFIED="1531723856001">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      ThreadPool* ThreadPoolSingletonHolder::pool(ThreadPool::ThreadAffinityPolicy affinityPolicy = ThreadPool::TAP_DEFAULT)
    </p>
    <p>
      contrib\poco\Foundation\src
    </p>
    <p>
      line 562 - 574
    </p>
  </body>
</html></richcontent>
<node CREATED="1531724291445" ID="ID_1638470596" MODIFIED="1531724421157" TEXT="ThreadPool(int minCapacity = 2,&#xa;&#x9;&#x9;int maxCapacity = 16,&#xa;&#x9;&#x9;int idleTime = 60,&#xa;&#x9;&#x9;int stackSize = POCO_THREAD_STACK_SIZE,&#xa;&#x9;&#x9;ThreadAffinityPolicy affinityPolicy = TAP_DEFAULT)&#xa;contrib\poco\Foundation\src&#xa;line 283 - 314"/>
<node CREATED="1531724389279" FOLDED="true" ID="ID_305131959" MODIFIED="1531726923960" TEXT="description">
<node CREATED="1531726904214" ID="ID_1723732305" MODIFIED="1531726912068" TEXT="start 2 threads"/>
</node>
<node CREATED="1531724389791" FOLDED="true" ID="ID_283904853" MODIFIED="1531726885129" TEXT="code">
<node CREATED="1531724392481" ID="ID_451322440" MODIFIED="1531724396261" TEXT="ThreadPool::ThreadPool(const std::string&amp; rName,&#xa;&#x9;int minCapacity,&#xa;&#x9;int maxCapacity,&#xa;&#x9;int idleTime,&#xa;&#x9;int stackSize,&#xa;&#x9;ThreadAffinityPolicy affinityPolicy):&#xa;&#x9;_name(rName),&#xa;&#x9;_minCapacity(minCapacity),&#xa;&#x9;_maxCapacity(maxCapacity),&#xa;&#x9;_idleTime(idleTime),&#xa;&#x9;_serial(0),&#xa;&#x9;_age(0),&#xa;&#x9;_stackSize(stackSize),&#xa;&#x9;_affinityPolicy(affinityPolicy),&#xa;&#x9;_lastCpu(0)&#xa;{&#xa;&#x9;poco_assert (minCapacity &gt;= 1 &amp;&amp; maxCapacity &gt;= minCapacity &amp;&amp; idleTime &gt; 0);&#xa;&#xa;&#x9;int cpu = -1;&#xa;&#x9;int cpuCount = Poco::Environment::processorCount();&#xa;&#x9;for (int i = 0; i &lt; _minCapacity; i++)&#xa;&#x9;{&#xa;&#x9;&#x9;if (_affinityPolicy == TAP_UNIFORM_DISTRIBUTION)&#xa;&#x9;&#x9;{&#xa;&#x9;&#x9;&#x9;cpu = _lastCpu.value() % cpuCount;&#xa;&#x9;&#x9;&#x9;_lastCpu++;&#xa;&#x9;&#x9;}&#xa;&#x9;&#x9;PooledThread* pThread = createThread();&#xa;&#x9;&#x9;_threads.push_back(pThread);&#xa;&#x9;&#x9;pThread-&gt;start(cpu);&#xa;&#x9;}&#xa;}"/>
</node>
</node>
<node CREATED="1531723815253" ID="ID_21893094" MODIFIED="1531735375620" TEXT="description"/>
<node CREATED="1531723815463" FOLDED="true" ID="ID_343932921" MODIFIED="1531726918534" TEXT="code">
<node CREATED="1531723818362" ID="ID_1061715463" MODIFIED="1531723823114" TEXT="ThreadPool* pool(ThreadPool::ThreadAffinityPolicy affinityPolicy = ThreadPool::TAP_DEFAULT)&#xa;&#x9;{&#xa;&#x9;&#x9;FastMutex::ScopedLock lock(_mutex);&#xa;&#x9;&#x9;&#xa;&#x9;&#x9;if (!_pPool)&#xa;&#x9;&#x9;{&#xa;&#x9;&#x9;&#x9;_pPool = new ThreadPool(&quot;default&quot;);&#xa;&#x9;&#x9;&#x9;_pPool-&gt;setAffinityPolicy(affinityPolicy);&#xa;&#x9;&#x9;&#x9;if (POCO_THREAD_STACK_SIZE &gt; 0)&#xa;&#x9;&#x9;&#x9;&#x9;_pPool-&gt;setStackSize(POCO_THREAD_STACK_SIZE);&#xa;&#x9;&#x9;}&#xa;&#x9;&#x9;return _pPool;&#xa;&#x9;}"/>
</node>
</node>
<node CREATED="1531723543601" ID="ID_575558312" MODIFIED="1531735370749" TEXT="description"/>
<node CREATED="1531723544140" FOLDED="true" ID="ID_1673727736" MODIFIED="1531724667486" TEXT="code">
<node CREATED="1531723548111" ID="ID_1736212902" MODIFIED="1531723559965">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      ThreadPool&amp; ThreadPool::defaultPool(ThreadAffinityPolicy affinityPolicy)
    </p>
    <p>
      {
    </p>
    <p>
      &#160;&#160;&#160;&#160;return *sh.pool(affinityPolicy);
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1531723335462" ID="ID_1383673725" MODIFIED="1531735363346" TEXT="description"/>
<node CREATED="1531723337313" FOLDED="true" ID="ID_1402272825" MODIFIED="1531724661044" TEXT="code">
<node CREATED="1531723339333" ID="ID_1596673492" MODIFIED="1531723346776" TEXT="TaskManager::TaskManager(ThreadPool::ThreadAffinityPolicy affinityPolicy):&#xa;&#x9;_threadPool(ThreadPool::defaultPool(affinityPolicy))&#xa;{&#xa;}"/>
</node>
<node CREATED="1531735380801" ID="ID_1014209795" LINK="ClickHouse/contrib/poco/Util/src/Application.cpp" MODIFIED="1531735471366">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      void Application::initialize(Application&amp; self)
    </p>
    <p>
      contrib\poco\Util\src/Application.cpp
    </p>
    <p>
      line 180 - 188
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1531735474015" ID="ID_1510607510" MODIFIED="1531735478927" TEXT="description"/>
<node CREATED="1531735497300" FOLDED="true" ID="ID_429642771" MODIFIED="1531741741790" TEXT="code">
<node CREATED="1531735505854" ID="ID_944780648" MODIFIED="1531735510055" TEXT="void Application::initialize(Application&amp; self)&#xa;{&#xa;&#x9;for (SubsystemVec::iterator it = _subsystems.begin(); it != _subsystems.end(); ++it)&#xa;&#x9;{&#xa;&#x9;&#x9;_pLogger-&gt;debug(std::string(&quot;Initializing subsystem: &quot;) + (*it)-&gt;name());&#xa;&#x9;&#x9;(*it)-&gt;initialize(self);&#xa;&#x9;}&#xa;&#x9;_initialized = true;&#xa;}"/>
</node>
</node>
<node CREATED="1531470853440" ID="ID_1932008746" MODIFIED="1531937405488" TEXT="description">
<node CREATED="1531726935617" ID="ID_1868336174" MODIFIED="1531735772503">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      1. call task_manager.reset(new Poco::TaskManager) to start 2 threads
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1531735776382" ID="ID_379468115" MODIFIED="1531735782855" TEXT="2. initialize(self), initialize logger">
<icon BUILTIN="help"/>
</node>
<node CREATED="1531735784295" ID="ID_484411166" LINK="#ID_873630700" MODIFIED="1531737119770" TEXT="3. line 857 - 904 : extract 2 args from argv, and call setString to set property pair (&quot;config-file&quot;, &quot;/etc/clickhouse-server/config.xml&quot;) to variable &quot;map_config&quot;"/>
<node CREATED="1531737122480" ID="ID_1705173775" MODIFIED="1531737820338" TEXT="4. line 909 - 919 : check if _pConfig has property &quot;application.runAsDaemon&quot;, it has not"/>
<node CREATED="1531738649945" ID="ID_1462170135" MODIFIED="1531937435907" TEXT="5. call reloadConfiguration()">
<icon BUILTIN="pencil"/>
<node CREATED="1531738659170" ID="ID_1653757161" LINK="ClickHouse/libs/libdaemon/src/BaseDaemon.cpp" MODIFIED="1531738756687">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      void BaseDaemon::reloadConfiguration()
    </p>
    <p>
      \libs\libdaemon\src/BaseDaemon.cpp
    </p>
    <p>
      line 641 - 655
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1531738759310" ID="ID_406877902" MODIFIED="1531738761739" TEXT="description">
<node CREATED="1531738991837" HGAP="22" ID="ID_1916775598" MODIFIED="1531739046877" TEXT="config_path = config().getString(&quot;config-file&quot;, &quot;config.xml&quot;) gets path of our config file (i.e. &quot;/etc/clickhouse-server/config.xml&quot;)"/>
<node CREATED="1531739048355" ID="ID_639922319" MODIFIED="1531739103654" TEXT="ConfigProcessor constructor creates a new Poco::ConsoleChannel and creates a new logger set to that channel">
<icon BUILTIN="help"/>
</node>
<node CREATED="1531739107074" ID="ID_1286495948" MODIFIED="1531739107074" TEXT=""/>
</node>
<node CREATED="1531738762449" ID="ID_578222280" MODIFIED="1531739328829" TEXT="code">
<node CREATED="1531738764648" ID="ID_1358908721" MODIFIED="1531738781587" TEXT="void BaseDaemon::reloadConfiguration()&#xa;{&#xa;    /** If the program is not run in daemon mode and &apos;config-file&apos; is not specified,&#xa;      *  then we use config from &apos;config.xml&apos; file in current directory,&#xa;      *  but will log to console (or use parameters --log-file, --errorlog-file from command line)&#xa;      *  instead of using files specified in config.xml.&#xa;      * (It&apos;s convenient to log in console when you start server without any command line parameters.)&#xa;      */&#xa;    config_path = config().getString(&quot;config-file&quot;, &quot;config.xml&quot;);&#xa;    loaded_config = ConfigProcessor(config_path, false, true).loadConfig(/* allow_zk_includes = */ true);&#xa;    if (last_configuration != nullptr)&#xa;        config().removeConfiguration(last_configuration);&#xa;    last_configuration = loaded_config.configuration.duplicate();&#xa;    config().add(last_configuration, PRIO_DEFAULT, false);&#xa;}"/>
</node>
</node>
<node CREATED="1531941059961" ID="ID_1010023388" MODIFIED="1531941181084" TEXT="x. line 1075 - 1076 : create a thread to handle signals, does signal logging, and deal with the signals">
<node CREATED="1531941181916" ID="ID_1335782824" LINK="Thread3_what_it_is_doing_illustration.png" MODIFIED="1531942175576" TEXT="see illustration, typically the class inherits from class Runnable, but here BaseDaemon use a wrapper class SignalListener"/>
<node CREATED="1531941185136" ID="ID_1685141099" LINK="https://blog.csdn.net/WUDAIJUN/article/details/9821583" MODIFIED="1531941224909" TEXT="link"/>
</node>
<node CREATED="1531739350702" ID="ID_1538823273" MODIFIED="1531739350702" TEXT=""/>
</node>
<node CREATED="1531470854395" ID="ID_1969588080" MODIFIED="1531470895367" TEXT="code">
<node CREATED="1531470856397" ID="ID_1474734006" LINK="#ID_1053862261" MODIFIED="1531471083478" TEXT="see link"/>
</node>
</node>
<node CREATED="1531469875804" ID="ID_1427635047" MODIFIED="1531469928520" TEXT="description">
<node CREATED="1531727241358" ID="ID_476671171" MODIFIED="1531727254209" TEXT="initialize and starting logger">
<icon BUILTIN="idea"/>
<icon BUILTIN="pencil"/>
</node>
</node>
<node CREATED="1531469876617" FOLDED="true" ID="ID_1393814159" MODIFIED="1531470773678" TEXT="code">
<node CREATED="1531469880315" ID="ID_1307249492" MODIFIED="1531470666950" TEXT="void Server::initialize(Poco::Util::Application &amp; self)&#xa;{&#xa;    BaseDaemon::initialize(self);&#xa;    logger().information(&quot;starting up&quot;);&#xa;}&#xa;"/>
</node>
<node CREATED="1531741634268" ID="ID_1942730935" LINK="ClickHouse/dbms/programs/server/Server.cpp" MODIFIED="1531741731451">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int Server::main(const std::vector&lt;std::string&gt; &amp; /*args*/)
    </p>
    <p>
      \dbms\programs\server/Server.cpp
    </p>
    <p>
      line 90 - 615
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1531741683542" ID="ID_1119863810" MODIFIED="1531741685454" TEXT="description">
<node CREATED="1531741811156" ID="ID_1070167571" MODIFIED="1531741846867" TEXT="line 304 : loadMetadata(*global_context); create 8 threads to do loading, then join them">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1531741686672" ID="ID_1862381419" MODIFIED="1531741687664" TEXT="code">
<node CREATED="1531741688272" ID="ID_1914230352" LINK="#ID_1942730935" MODIFIED="1531741714687" TEXT="see link"/>
</node>
</node>
<node CREATED="1531468769910" ID="ID_43833007" MODIFIED="1531468856791" TEXT="description"/>
<node CREATED="1531468770964" FOLDED="true" ID="ID_1672881637" MODIFIED="1531741614289" TEXT="code">
<node CREATED="1531468772690" ID="ID_140100457" MODIFIED="1531468777624" TEXT="int Application::run()&#xa;{&#xa;&#x9;int rc = EXIT_CONFIG;&#xa;&#x9;initialize(*this);&#xa;&#xa;&#x9;try&#xa;&#x9;{&#xa;&#x9;&#x9;rc = EXIT_SOFTWARE;&#xa;&#x9;&#x9;rc = main(_unprocessedArgs);&#xa;&#x9;}&#xa;&#x9;catch (Poco::Exception&amp; exc)&#xa;&#x9;{&#xa;&#x9;&#x9;logger().log(exc);&#xa;&#x9;}&#xa;&#x9;catch (std::exception&amp; exc)&#xa;&#x9;{&#xa;&#x9;&#x9;logger().error(exc.what());&#xa;&#x9;}&#xa;&#x9;catch (...)&#xa;&#x9;{&#xa;&#x9;&#x9;logger().fatal(&quot;system exception&quot;);&#xa;&#x9;}&#xa;&#xa;&#x9;uninitialize();&#xa;&#x9;return rc;&#xa;}"/>
</node>
</node>
<node CREATED="1531468458814" FOLDED="true" ID="ID_245996379" MODIFIED="1531736707379" TEXT="description">
<node CREATED="1531468688632" ID="ID_68514532" MODIFIED="1531468698166" TEXT="direct call to Application::run()"/>
</node>
<node CREATED="1531468460103" FOLDED="true" ID="ID_63081967" MODIFIED="1531468700409" TEXT="code">
<node CREATED="1531468491408" ID="ID_611461241" MODIFIED="1531468507108">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int ServerApplication::run()
    </p>
    <p>
      {
    </p>
    <p>
      &#160;&#160;&#160;&#160;return Application::run();
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1531452825423" FOLDED="true" ID="ID_312335353" MODIFIED="1531736700060" TEXT="description">
<node CREATED="1531453143803" ID="ID_879878524" MODIFIED="1531468386815">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      1. check if isDaemon (where isDaemon checks if any element of pArgv is &quot;--daemon')
    </p>
    <p>
      2. then calls init(argc, pArgv)
    </p>
    <p>
      3. then it goes to return run();
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1531452826663" FOLDED="true" ID="ID_689928623" MODIFIED="1531468408997" TEXT="code">
<node CREATED="1531451515298" ID="ID_1078423150" MODIFIED="1531453120786" TEXT="int ServerApplication::run(int argc, char** pArgv)&#xa;{&#xa;&#x9;bool runAsDaemon = isDaemon(argc, pArgv);&#xa;&#x9;if (runAsDaemon)&#xa;&#x9;{&#xa;&#x9;&#x9;beDaemon();&#xa;&#x9;}&#xa;&#x9;try&#xa;&#x9;{&#xa;&#x9;&#x9;init(argc, pArgv);&#xa;&#x9;&#x9;if (runAsDaemon)&#xa;&#x9;&#x9;{&#xa;&#x9;&#x9;&#x9;int rc = chdir(&quot;/&quot;);&#xa;&#x9;&#x9;&#x9;if (rc != 0) return EXIT_OSERR;&#xa;&#x9;&#x9;}&#xa;&#x9;}&#xa;&#x9;catch (Exception&amp; exc)&#xa;&#x9;{&#xa;&#x9;&#x9;logger().log(exc);&#xa;&#x9;&#x9;return EXIT_CONFIG;&#xa;&#x9;}&#xa;&#x9;return run();&#xa;}"/>
</node>
</node>
<node CREATED="1531451491541" FOLDED="true" ID="ID_1079688850" MODIFIED="1531736704278" TEXT="description">
<node CREATED="1531452574289" ID="ID_1197145400" MODIFIED="1531452713465" TEXT="relay argc and argv to app.run()"/>
</node>
<node CREATED="1531451506639" FOLDED="true" ID="ID_1645334975" MODIFIED="1531462353464" TEXT="code">
<node CREATED="1531452513940" ID="ID_627487962" MODIFIED="1531452524109">
<richcontent TYPE="NODE"><html>
  <head>
    
  </head>
  <body>
    <p>
      int mainEntryClickHouseServer(int argc, char ** argv)
    </p>
    <p>
      {
    </p>
    <p>
      &#160;&#160;&#160;&#160;DB::Server app;
    </p>
    <p>
      &#160;&#160;&#160;&#160;try
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return app.run(argc, argv);
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
    <p>
      &#160;&#160;&#160;&#160;catch (...)
    </p>
    <p>
      &#160;&#160;&#160;&#160;{
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;std::cerr &lt;&lt; DB::getCurrentExceptionMessage(true) &lt;&lt; &quot;\n&quot;;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;auto code = DB::getCurrentExceptionCode();
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return code ? code : 1;
    </p>
    <p>
      &#160;&#160;&#160;&#160;}
    </p>
    <p>
      }
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
</node>
<node CREATED="1531452298150" FOLDED="true" ID="ID_272351442" MODIFIED="1531452329167" POSITION="right" TEXT="description">
<node CREATED="1531451554748" ID="ID_33355449" MODIFIED="1531452254465" TEXT="entry function, here find the pointer to mainEntryClickHouseServer(), and store it in main_func, and relay argc, argv to that funcion"/>
</node>
<node CREATED="1531452316653" FOLDED="true" ID="ID_885018091" MODIFIED="1531462321990" POSITION="right" TEXT="code">
<node CREATED="1531451515298" ID="ID_1147731170" MODIFIED="1531451531839" TEXT="int main(int argc_, char ** argv_)&#xa;{&#xa;    std::vector&lt;char *&gt; argv(argv_, argv_ + argc_);&#xa;&#xa;    /// Print a basic help if nothing was matched&#xa;    MainFunc main_func = printHelp;&#xa;&#xa;    for (auto &amp; application : clickhouse_applications)&#xa;    {&#xa;        if (isClickhouseApp(application.first, argv))&#xa;        {&#xa;            main_func = application.second;&#xa;            break;&#xa;        }&#xa;    }&#xa;&#xa;    return main_func(static_cast&lt;int&gt;(argv.size()), argv.data());&#xa;}&#xa;"/>
</node>
</node>
</map>
