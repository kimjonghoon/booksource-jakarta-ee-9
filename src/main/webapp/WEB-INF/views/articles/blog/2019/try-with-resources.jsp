<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<article>
<div class="last-modified">Last Modified 2019.3.4</div>

<h1>try with resources</h1>

<p>
자바 7에 도입된 try with resources 문은 try 다음에 괄호를 나오고, 괄호 안에 리소스가 생성하는 문이다.
(지금까지 try 키워드 다음에는 블록이 나왔다)
괄호 안에서 생성할 수 있는 리소스는 java.lang.AutoCloseable을 구현해야 한다.
try with resources 문은 리소스가 닫히는 것을 보장한다.
</p>

<p>
movies.txt 파일을 아래 내용으로 작성하고 /src 디렉터리에 복사한다.
</p>

<pre class="prettyprint">
Butch Cassidy And The Sundance Kid,1969,8.1
Lucy,2014,6.4
Asphalte,2015,7.1
Spy,2015,7.0
Blade Runner 2049,2017,8.1
Small Town Crime,2017,6.6
The Commuter,2018,6.3
Flashdance,1983,6.1
Midnight Run,1988,7.6
Twelve Monkeys,1995,8.0
As Good As It Gets,1997,7.7
Collateral,2004,7.5
Choke,2008,6.5
The Dark Knight,2008,9.0
The Dark Knight Rises,2012,8.4
Infinitely Polar Bear,2014,7.0
Mission Impossible 3,2006,6.9
Mission Impossible 4,2011,7.4
The Terminator,1984,8.0
Terminator 2,1991,8.5
Flight,2012,7.3
Our Brand Is Crisis,2015,6.1
The Rewrite,2014,6.2
The Secret Life of Walter Mitty,2013,7.3
Waterloo Bridge,1940,7.8
Roman Holiday,1953,8.1
Ben Hur,1959,8.1
The Battle of Algiers,1966,8.1
Love Story,1970,6.9
Jaws,1975,8.0
Operation Daybreak,1975,7.1
Blade Runner,1982,8.2
The Silence Of The Lambs,1991,8.6
Thelma and Louise,1991,7.4
Scent of a Woman,1992,8.0
The Shawshank Redemption,1994,9.3
Heat,1995,8.2
Jerry Maguire,1996,7.6
Knockin On Heavens Door,1997,8.0
28 Days,2000,6.0
Unbreakable,2000,7.3
Secondhand Lion,2003,7.6
Eternal Sunshine of the Spotless Mind,2004,8.3
Little Miss Sunshine,2006,7.8
No Country for Old Men,2007,8.1
The Lookout,2007,7.0
Doubt,2008,7.5
The Bank Job,2008,7.3
The Wrestler,2008,7.9
Agora,2009,7.2
Morning Glory,2010,6.5
Foxfire,2012,6.2
Drive,2011,7.8
Walk of Shame,2014,6.0
Truth,2015,6.8
Tschick,2016,7.0
Creed,2015,7.6
Rocky,1976,8.1
</pre>

<pre class="prettyprint">package net.java_school.examples;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class TryWithResourcesTest {

	static String readFirstLineFromFile(String path) throws IOException {
	    try (BufferedReader br = new BufferedReader(new FileReader(path))) {
	        return br.readLine();
	    }
	}

	public static void main(String[] args) throws IOException {
		String firstLine = null;
		firstLine = readFirstLineFromFile("./src/movies.txt");
		System.out.println(firstLine);
	}

}
</pre>

<pre class="console"><strong class="console-result">Butch Cassidy And The Sundance Kid,1969,8.1</strong></pre>

<p>
예제는 BufferedReader 인스턴스를 사용해 파일로부터 첫 라인을 읽는다.
BufferedReader은 프로그램이 끝날 때 반드시 닫혀야 하는 자원이다.
예제는 try with resources 문 안에 BufferedReader를 선언하고 있다.
자바 7부터 BufferedReader는 AutoCloseable 인터페이스를 구현한다.
try with resources 문 안에 AutoCloseable을 구현한 리소스을 선언하면, try 문이 정상적으로 수행되거나 비정상 종료를 하거나 상관없이 리소스는 닫힌다.
</p>

<p>
자바 7 이전, 정상적으로 수행하거나 비정상으로 종료하거나 상관없이 리소스 종료를 확실히 하려면 다음처럼 finally 블록을 사용했다.
</p>

<pre class="prettyprint">static String readFirstLineFromFileWithFinallyBlock(String path) throws IOException {
    BufferedReader br = new BufferedReader(new FileReader(path));
    try {
        return br.readLine();
    } finally {
    	if (br != null) br.close();
    }
}
</pre>

<p>
하지만 finally 블록에서도 BufferedReader의 close() 메소드는 IOException을 발생시킬 수 있다.
</p>

<p>
try with resources 문 안에 하나 이상의 리소스를 선언할 수 있다.
try with resources 문은 catch와 finally 블록을 가질 수 있는데, catch와 finally 블록은 선언된 리소스가 닫힌 후 작동한다.
</p>

<p>
최종 소스 : <a href="https://github.com/kimjonghoon/try-with-resources">https://github.com/kimjonghoon/try-with-resources</a>
</p>

<h3>실행 방법</h3>

<pre class="shell-prompt">~/try-with-resources$ <strong>cd src/net/java_school/examples/</strong>
~/try-with-resources/src/net/java_school/examples$ <strong>javac -d ../../../../bin *.java</strong>
~/try-with-resources/src/net/java_school/examples$ <strong>cd -</strong>
~/try-with-resources$ <strong>java -cp ./bin net.java_school.examples.Test</strong>
Butch Cassidy And The Sundance Kid,1969,8.1
</pre>

<span id="refer">참고</span>
<ul id="references">
	<li><a href="https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html">https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html</a></li>
</ul>

</article>
