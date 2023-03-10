<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<article>
<div class="last-modified">Last Modified 2019.2.1</div>

<h1>정적 임포트 문</h1>

<p>
    정적 임포트(static import) 문은 자바 5에 도입되었다.<br />
    정적 임포트 문을 사용하면 클래스 이름을 생략하고 정적 멤버를 사용할 수 있다.
</p>

<pre class="prettyprint">package net.java_school.examples;

<strong>import static java.lang.Math.*;</strong>

public class StaticImportTest {
	public static void main(String[] args) {
		System.out.println(<strong>sqrt(4)</strong>);//Math 클래스 이름을 생략할 수 있다.
	}
}
</pre>

<pre class="console"><strong class="console-result">2.0</strong></pre>

<p>
import java.util.*; 임포트 문에서 *는 java.util 패키지 안의 모든 타입을 의미한다.<br />
반면, <strong>import static java.lang.Math.*;</strong>에서 *는 Math 클래스의 모든 정적 멤버를 의미한다.<br />
예제에서 Math 클래스에서 sqrt() 메소드만 줄여 쓰기 원한다면 <strong>import static java.lang.Math.sqrt;</strong> 로 정적 임포트 문을 수정할 수 있다.
마지막 sqrt는 메소드를 의미하며 괄호 없이 써야 한다.
</p>

<span id="refer">참고</span>
<ul id="references">
	<li><a href="https://docs.oracle.com/javase/8/docs/technotes/guides/language/static-import.html">https://docs.oracle.com/javase/8/docs/technotes/guides/language/static-import.html</a></li>
</ul>

</article>
