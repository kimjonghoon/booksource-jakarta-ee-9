<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<article>
<div class="last-modified">Last Modified 2019.3.4</div>

<h1>디폴트 메소드</h1>

<p>
디폴트 메소드는 메소드 구현을 포함하는 인터페이스를 정의할 수 있게 한다.
디폴트 메소드의 도입은 기존 자바와 호환성을 유지하면서 API를 바꾸기 위한 어쩔 수 없는 선택이었다.
이로써 자바는 다중 상속을 허용하는 언어가 되었다.
디폴트 메소드를 선언하려면 반환 타입 앞에 default를 붙인다.
</p>

<p>
C가 A와 B를 상속한다고 가정하자.
A와 B에 같은 메소드가 있다면, C가 상속하는 메소드는 다음 규칙으로 결정된다.
</p>

<ol>
    <li>클래스가 항상 이긴다. 클래스나 슈퍼 클래스에서 정의한 메소드가 디폴트 메소드를 이긴다.</li>
    <li>1번 규칙 이외 상황에서 서브 인터페이스가 이긴다.</li>
    <li>여전히 디폴트 메소드의 우선순위가 결정되지 않는다면, 명시적으로 디폴트 메소드를 오버라이드하고 호출해야 한다.</li>
</ol>

<h3>1. 클래스가 항상 이긴다.</h3>

<pre class="prettyprint">package net.java_school.examples;

public interface A1Interface {
	public default String hello() {
		return "A1 Interface says hello";
	}
}
</pre>

<pre class="prettyprint">package net.java_school.examples;

public class B1Class {
	public String hello() {
		return "B1 Class says hello";
	}
}
</pre>

<pre class="prettyprint">package net.java_school.examples;

public class C1Class extends B1Class implements A1Interface {

	public static void main(String[] args) {
		C1Class c1 = new C1Class();
		System.out.println(c1.hello());
	}

}
</pre>

<pre class="console"><strong class="console-result">B1 Class says hello</strong></pre>

<h3>2. 서브 인터페이스가 이긴다.</h3>

<pre class="prettyprint">package net.java_school.examples;

public interface A2Interface {
	public default String hello() {
		return "A2 Interface says hello";
	}
}
</pre>

<pre class="prettyprint">package net.java_school.examples;

public interface B2Interface extends A2Interface {
	@Override
	public default String hello() {
		return "B2 Interface says hello";
	}
}
</pre>

<pre class="prettyprint">package net.java_school.examples;

public class C2Class implements A2Interface,B2Interface {
	public static void main(String[] args) {
		C2Class c2 = new C2Class();
		System.out.println(c2.hello());
	}
}
</pre>

<pre class="console"><strong class="console-result">B2 Interface says hello</strong></pre>

<h3>3. 때때로, 명시적으로 메소드를 선택해 오버라이딩해야 한다.</h3>

<pre class="prettyprint">package net.java_school.examples;

public interface A3Interface {
	public default String hello() {
		return "A3 Interface says hello";
	}
}
</pre>

<pre class="prettyprint">package net.java_school.examples;

public interface B3Interface {
	public default String hello() {
		return "B3 Interface says hello";
	}
}
</pre>

<pre class="prettyprint">package net.java_school.examples;

public class C3Class implements A3Interface,B3Interface {

}
</pre>

<p>
C3Class 클래스 선언에서 Duplicate default methods named hello... 컴파일 에러가 발생한다.
컴파일 에러를 피하려면 명시적으로 메소드를 선택해 오버라이딩해야 한다.
</p>

<pre class="prettyprint">package net.java_school.examples;

public class C3Class implements A3Interface,B3Interface {

	@Override
	public String hello() {
		return <strong>B3Interface.super.hello()</strong>;//B3Interface의 hello() 선택
	}

	public static void main(String[] args) {
		C3Class c3 = new C3Class();
		System.out.println(c3.hello());
	}

}
</pre>

<pre class="console"><strong class="console-result">B3 Interface says hello</strong></pre>

<p>
최종 소스 : <a href="https://github.com/kimjonghoon/multipleInheritance">https://github.com/kimjonghoon/multipleInheritance</a>
</p>

<h3>실행 방법</h3>

<pre class="shell-prompt">~/multipleInheritance$ <strong>cd src/net/java_school/examples/</strong>
~/multipleInheritance/src/net/java_school/examples$ <strong>javac -d ../../../../bin *.java</strong>
~/multipleInheritance/src/net/java_school/examples$ <strong>cd -</strong>
~/multipleInheritance$ <strong>java -cp ./bin net.java_school.examples.Test</strong>
B1 Class says hello
B2 Interface says hello
B3 Interface says hello
</pre>

</article>
