<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<article>
<div class="last-modified">Last Modified 2020.2.6</div>
	
<h1>제티 메이븐 플러그인</h1>

<p>
제티 메이븐 플러그인(Jetty Maven Plugin)을 사용하면 서버 설치없이 웹 앱을 테스트할 수 있다. 
</p>

<p>
메이븐 아키타입을 생성한다.
</p>

<strong class="screen-header"><b>C:\</b> Command Prompt</strong>
<pre class="screen">
mvn archetype:generate -Dfilter=maven-archetype-webapp
</pre>

<div style="margin-top: 2em;">
<strong class="screen-header"><b>C:\</b> Command Prompt</strong>
<pre class="screen">
Define value for property 'groupId': : net.java_school.test
Define value for property 'artifactId': : hello
Define value for property 'version':  1.0-SNAPSHOT: : 
Define value for property 'package':  net.java_school.hello: : 
</pre>
</div>

<p>
생성한 메이븐 프로젝트를 Import - Import - Existing Maven Project 선택하여 이클립스에 임포트한다.
</p>

<p>
web.xml 파일을 열고 아래와 같이 수정한다.
</p>

<strong class="filename">web.xml</strong>
<pre class="prettyprint">
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;!--
 Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
--&gt;
&lt;web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                      http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
  version="3.1"
  metadata-complete="true"&gt;
  
&lt;/web-app&gt;
</pre>

<p>
pom.xml 파일을 아래와 같이 수정한다.
</p>

<strong class="filename">pom.xml</strong>
<pre class="prettyprint">
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd"&gt;
	&lt;modelVersion&gt;4.0.0&lt;/modelVersion&gt;
	&lt;groupId&gt;net.java_school.test&lt;/groupId&gt;
	&lt;artifactId&gt;examples&lt;/artifactId&gt;
	&lt;packaging&gt;war&lt;/packaging&gt;
	&lt;version&gt;0.0.1-SNAPSHOT&lt;/version&gt;
	&lt;name&gt;hello&lt;/name&gt;
	&lt;url&gt;http://maven.apache.org&lt;/url&gt;

	&lt;properties&gt;
		&lt;jdk.version&gt;11&lt;/jdk.version&gt;
	&lt;/properties&gt;

	&lt;dependencies&gt;
		&lt;dependency&gt;
			&lt;groupId&gt;junit&lt;/groupId&gt;
			&lt;artifactId&gt;junit&lt;/artifactId&gt;
			&lt;version&gt;3.8.1&lt;/version&gt;
			&lt;scope&gt;test&lt;/scope&gt;
		&lt;/dependency&gt;
		&lt;!-- Servlet JSP JSTL --&gt;
		&lt;dependency&gt;
			&lt;groupId&gt;javax.servlet&lt;/groupId&gt;
			&lt;artifactId&gt;javax.servlet-api&lt;/artifactId&gt;
			&lt;version&gt;4.0.1&lt;/version&gt;
			&lt;scope&gt;provided&lt;/scope&gt;
		&lt;/dependency&gt;
		&lt;dependency&gt;
			&lt;groupId&gt;javax.servlet.jsp&lt;/groupId&gt;
			&lt;artifactId&gt;javax.servlet.jsp-api&lt;/artifactId&gt;
			&lt;version&gt;2.3.3&lt;/version&gt;
			&lt;scope&gt;provided&lt;/scope&gt;
		&lt;/dependency&gt;
		&lt;dependency&gt;
			&lt;groupId&gt;jstl&lt;/groupId&gt;
			&lt;artifactId&gt;jstl&lt;/artifactId&gt;
			&lt;version&gt;1.2&lt;/version&gt;
		&lt;/dependency&gt;
	&lt;/dependencies&gt;

	&lt;build&gt;
		&lt;finalName&gt;hello&lt;/finalName&gt;
		&lt;pluginManagement&gt;
			&lt;plugins&gt;
				&lt;plugin&gt;
					&lt;groupId&gt;org.apache.maven.plugins&lt;/groupId&gt;
					&lt;artifactId&gt;maven-compiler-plugin&lt;/artifactId&gt;
					&lt;version&gt;3.6.2&lt;/version&gt;
					&lt;configuration&gt;
						&lt;source&gt;${jdk.version}&lt;/source&gt;
						&lt;target&gt;${jdk.version}&lt;/target&gt;
						&lt;encoding&gt;UTF-8&lt;/encoding&gt;
					&lt;/configuration&gt;
				&lt;/plugin&gt;
				<strong>&lt;plugin&gt;
					&lt;groupId&gt;org.eclipse.jetty&lt;/groupId&gt;
					&lt;artifactId&gt;jetty-maven-plugin&lt;/artifactId&gt;
					&lt;version&gt;10.0.0&lt;/version&gt;
				&lt;/plugin&gt;</strong>
			&lt;/plugins&gt;
		&lt;/pluginManagement&gt;
	&lt;/build&gt;

&lt;/project&gt;
</pre>

<p>
<a href="https://mvnrepository.com/artifact/org.eclipse.jetty/jetty-maven-plugin">https://mvnrepository.com/artifact/org.eclipse.jetty/jetty-maven-plugin</a>
에서 가장 최신 jetty-maven-plugin 배포본을 선택하고 의존성이 아닌 플러그인에 추가한다. (위에서 강조한 부분 참조)
</p>


<p>
jetty를 실행한다.
</p>

<strong class="screen-header"><b>C:\</b> Command Prompt</strong>
<pre class="screen">
mvn jetty:run
</pre>

<p>
http://localhost:8080을 방문하여 <strong>Hello World!</strong>를 보면 성공이다.
</p>

<p>
실행에 아무런 문제가 없으나 이클립스에서 보이는 에러는, Project Explorer 뷰에서 프로젝트 선택 - 마우스 오른쪽 버튼 클릭 - Properties - Project Facets을 선택해서
Java 버전을 1.8로, Dynamic Web Module 버전을 3.1으로 바꾸면, 사라진다.
(윈도에서는 한 번에 하나씩만 바꿀 수 있다.)
</p>

<span id="refer">참고</span>
<ul id="references">
	<li><a href="http://www.eclipse.org/jetty/documentation/9.3.x/jetty-maven-plugin.html">http://www.eclipse.org/jetty/documentation/9.3.x/jetty-maven-plugin.html</a></li>
	<li><a href="https://mvnrepository.com/artifact/org.eclipse.jetty/jetty-maven-plugin">https://mvnrepository.com/artifact/org.eclipse.jetty/jetty-maven-plugin</a></li>
	<li><a href="https://mvnrepository.com/artifact/org.eclipse.jetty/jetty-maven-plugin/9.4.6.v20170531">https://mvnrepository.com/artifact/org.eclipse.jetty/jetty-maven-plugin/9.4.6.v20170531</a></li>
	<li><a href="https://maven.apache.org/plugins/maven-compiler-plugin/usage.html">https://maven.apache.org/plugins/maven-compiler-plugin/usage.html</a></li>
	<li><a href="https://maven.apache.org/plugins/maven-compiler-plugin/examples/set-compiler-source-and-target.html">https://maven.apache.org/plugins/maven-compiler-plugin/examples/set-compiler-source-and-target.html</a></li>
</ul>

</article>
