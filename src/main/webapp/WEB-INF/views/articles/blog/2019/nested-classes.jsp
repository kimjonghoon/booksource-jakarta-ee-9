<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<article>
<div class="last-modified">Last Modified 2019.1.31</div>

<h1>내포된 클래스</h1>

<p>
<em><a href="https://docs.oracle.com/javase/tutorial/java/javaOO/nested.html">https://docs.oracle.com/javase/tutorial/java/javaOO/nested.html</a> 글을 참고했습니다.</em>
</p>

<p>
클래스 안에 클래스를 정의할 수 있다.<br />
클래스 안에 정의된 클래스를 내포된 클래스(Nested Classes)라 한다.
</p>

<pre class="prettyprint">//감싸는 클래스
class OuterClass {

	//내포된 클래스
	class NestedClass {
		//...
	}

}
</pre>

<p>
내포된 클래스는 감싸는 클래스의 멤버다.<br />
내포된 클래스가 정적이 아니라면 감싸는 클래스의 다른 멤버에 접근할 수 있다.
</p>

<p>
감싸는 클래스는 public 또는 package private 접근자로만 정의할 수 있는데 반해, 내포된 클래스는 public, protected, package private, private 모두를 사용해 정의할 수 있다.
패키지 자리에 아무것도 입력하지 않는 게 package private다.
</p>

<p>
내포된 클래스는 정적 내포된 클래스(Static nested classes)와 내부 클래스(Inner classes)로 나뉜다.
</p>

<pre class="prettyprint">class OuterClass {

	static class StaticNestedClass {
		//...
	}

	class InnerClass {
		//...
	}

}
</pre>

<p>
정적 내포된 클래스는 감싸는 클래스의 인스턴스 변수와 인스턴스 메소드에 접근할 수 없다.
</p>

<p>
내부 클래스의 로직이 감싸는 클래스에서만 사용된다면,
캡슐화가 증가하여 유지보수에 유리하므로 내부 클래스로 만드는 것이 좋다.
</p>

<p>
ArrayList&lt;E&gt; 클래스의 다음 부분 코드가 내부 클래스의 좋은 예다.
</p>

<pre class="prettyprint">public Iterator&lt;E&gt; iterator() {
	return new Itr();
}

private class Itr implements Iterator&lt;E&gt; {
	//...
}
</pre>

<p>
ArrayList&lt;E&gt;를 사용하는 데 Itr 내부 클래스를 알 필요 없다.
</p>

<p>
내부 클래스 중 무영 내부 클래스(Anonymous inner class)는 인스턴스 생성 후에 레퍼런스를 유지할 필요가 없을 때 사용한다.<br />
메소드 안에서 정의한 무명 내부 클래스는 final 지역 변수만 접근할 수 있도록 제한되어 있다.<br />
무명 내부 클래스가 final이 아닌 지역 변수에 접근하는 코드를 작성하면
Cannot refer to a non-final variable inside an inner class... 로 시작하는 컴파일 에러가 발생한다.<br />
자바가 이런 제한을 둔 이유는 내부 클래스의 생명주기가 메소드보다 길기 때문이다.<br />
알다시피 메소드와 그 메소드 안 지역 변수의 생명 주기는 같다.<br />
메소드 안 무명 내부 클래스가 final 지역 변수만을 접근할 수 있다는 제약을 두지 않는다면 생명 주기의 차이로 원하는 결과를 얻지 못하는 경우가 발생할 가능성이 생기고 이럴 때 버그를 찾기가 매우 힘들다.<br />
지역 변수가 final이면 내부 클래스는 값이 변하지 않을 것을 확신하고 변숫값의 복사본을 유지한다.
</p>

<span id="refer">참고</span>
<ul id="references">
	<li><a href="https://docs.oracle.com/javase/tutorial/java/javaOO/nested.html">https://docs.oracle.com/javase/tutorial/java/javaOO/nested.html</a></li>
</ul>

</article>
