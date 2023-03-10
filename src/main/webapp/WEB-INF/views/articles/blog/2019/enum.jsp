<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<article>
<div class="last-modified">Last Modified 2019.3.4</div>

<h1>enum</h1>

<p>
enum 타입은 자바 5에 도입되었다.
</p>

<ul>
    <li>허용 가능한 값을 제한한다.</li>
    <li>값을  추가해도 수정해야 할 코드의 양이 최소화할 수 있다.</li>
    <li>자바 enum은 클래스다.</li>
</ul>

<p>
enum 타입은 상수 집합 정의를 위한 특별한 데이터 타입이다.<br />
enum 선언은 클래스를 정의한다.<br />
enum 클래스 바디는 메소드와 필드를 포함할 수 있다.<br />
컴파일러는 enum을 생성할 때 자동으로 values() 정적 메소드를 추가한다.<br />
values() 정적 메소드는 enum의 모든 값을 순서대로 저장한 배열을 반환한다.
</p>

<pre class="prettyprint">package net.java_school.examples;

public enum Day {

	SUNDAY,
	MONDAY,
	TUESDAY,
	WEDNESDAY,
	THURSDAY,
	FRIDAY,
	SATURDAY

}
</pre>

<pre class="prettyprint">package net.java_school.examples;

public class EnumTest {
	Day day;

	public EnumTest(Day day) {
		this.day = day;
	}

	public void tellItLikeItIs() {
		switch (day) {
		case MONDAY:
			System.out.println("Mondays are bad.");
			break;

		case FRIDAY:
			System.out.println("Fridays are better.");
			break;

		case SATURDAY: case SUNDAY:
			System.out.println("Weekends are best.");
			break;

		default:
			System.out.println("Midweek days are so-so.");
			break;
		}
	}

	public static void main(String[] args) {
		EnumTest firstDay = new EnumTest(Day.MONDAY);
		firstDay.tellItLikeItIs();
		EnumTest thirdDay = new EnumTest(Day.WEDNESDAY);
		thirdDay.tellItLikeItIs();
		EnumTest fifthDay = new EnumTest(Day.FRIDAY);
		fifthDay.tellItLikeItIs();
		EnumTest sixthDay = new EnumTest(Day.SATURDAY);
		sixthDay.tellItLikeItIs();
		EnumTest seventhDay = new EnumTest(Day.SUNDAY);
		seventhDay.tellItLikeItIs();

		for (Day day : Day.values()) {
			System.out.println(day);
		}
	}

}
</pre>

<pre class="console"><strong class="console-result">Mondays are bad.
Midweek days are so-so.
Fridays are better.
Weekends are best.
Weekends are best.
SUNDAY
MONDAY
TUESDAY
WEDNESDAY
THURSDAY
FRIDAY
SATURDAY</strong></pre>

<p>
값을 가진 enum 상수를 선언하는 방법은 다음과 같다.
</p>

<ul>
    <li>상수 선언 마지막에 ; 추가</li>
    <li>package-private나 private로 생성자 추가</li>
    <li>값을 얻기 위한 메소드 추가</li>
</ul>

<pre class="prettyprint">package net.java_school.examples;

public enum Day {

	SUNDAY("Sun"), //"Sun"이란 값을 생성자에 전달
	MONDAY("Mon"), 
	TUESDAY("Tue"),
	WEDNESDAY("Wed"), 
	THURSDAY("Thu"), 
	FRIDAY("Fri"),
	SATURDAY("Sat"); //마지막에 ; 추가
	
	private final String value;

	//생성자 추가
	private Day(String value) {
		this.value = value;
	}

	//값을 얻기 위한 메소드 추가
	public String getValue() {
		return value;
	}
}
</pre>

<p>
enum 상수와 연결된 값은 자바 데이터 타입 중 하나다.<br />
메인 메소드 마지막에 다음을 추가하여 예제를 테스트한다.
</p>

<pre class="prettyprint">System.out.println(Day.MONDAY);
System.out.println(Day.MONDAY.getValue());

for (Day day : Day.values()) {
	System.out.println(day.getValue());
}
</pre>

<pre class="console"><strong class="console-result">Sun
Mon
Tue
Wed
Thu
Fri
Sat</strong></pre>

<p>
최종 소스 : <a href="https://github.com/kimjonghoon/enum">https://github.com/kimjonghoon/enum</a>
</p>

<h3>실행 방법</h3>

<pre class="shell-prompt">~/enum$ <strong>cd src/net/java_school/examples/</strong>
~/enum/src/net/java_school/examples$ <strong>javac -d ../../../../bin *.java</strong>
~/enum/src/net/java_school/examples$ <strong>cd -</strong>
~/enum$ <strong>java -cp ./bin net.java_school.examples.EnumTest</strong>
1.
Mondays are bad.
Midweek days are so-so.
Fridays are better.
Weekends are best.
Weekends are best.

2.
SUNDAY
MONDAY
TUESDAY
WEDNESDAY
THURSDAY
FRIDAY
SATURDAY

3.
Sun
Mon
Tue
Wed
Thu
Fri
Sat
</pre>

<span id="refer">참고</span>
<ul id="references">
	<li><a href="https://docs.oracle.com/javase/tutorial/java/javaOO/enum.html">https://docs.oracle.com/javase/tutorial/java/javaOO/enum.html</a></li>
</ul>

</article>
