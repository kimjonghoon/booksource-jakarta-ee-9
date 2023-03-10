<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<article>
<div class="last-modified">Last Modified 2021.8.31</div>

<h1>자바 8의 함수형 프로그래밍 지원</h1>

<p>
자바 8부터 자바는 함수형 프로그래밍을 지원한다.
메소드의 파라미터 타입이 함수형 인터페이스라면 그 자리에 람다식이나 메소드 레퍼런스가 대신 올 수 있다.
함수형 인터페이스란 추상 메소드가 한 개인 인터페이스를 말한다.
</p>

<h3>예제</h3>

<p>
movies.txt 파일을 아래 내용으로 생성하고 루트 디렉터리에 복사한다.
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

<p>
영화 클래스를 아래와 같이 생성한다.
</p>

<pre class="prettyprint">package net.java_school.examples;

public class Movie {
  private final String title;
  private final int releaseDate;
  private final double userRatings;

  public Movie(String title, int releaseDate, double userRatings) {
    this.title = title;
    this.releaseDate = releaseDate;
    this.userRatings = userRatings;
  }

  public String getTitle() {
    return title;
  }

  public int getReleaseDate() {
    return releaseDate;
  }

  public double getUserRatings() {
    return userRatings;
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append(this.getTitle());
    sb.append(",");
    sb.append(this.getReleaseDate());
    sb.append(",");
    sb.append(this.getUserRatings());

    return sb.toString();
  }
}
</pre>

<p>
title은 영화 제목을, releaseDate는 개봉일을, userRatings는 IMDb의 사용자 평점을 나타낸다.
</p>

<p>
함수형 인터페이스를 다음과 같이 작성한다.
</p>

<pre class="prettyprint">package net.java_school.examples;

public interface Predicate&lt;T&gt; {
  boolean test(T t);
}
</pre>

<p>
Predicate는 수학 용어로 값을 받아 true나 false를 반환하는 함수를 말한다.
Predicate 함수형 인터페이스를 구현한 클래스를 아래처럼 생성한다.
</p>

<pre class="prettyprint">package net.java_school.examples;

public class Rated8OrAbovePredicate implements Predicate&lt;Movie&gt; {

  @Override
  public boolean test(Movie movie) {
    return movie.getUserRatings() &gt;= 8.0;
  }
}
</pre>

<p>
테스트를 위한 클래스를 다음과 같이 작성한다.
</p>

<pre class="prettyprint">package net.java_school.examples;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

public class MovieTest {

	static List&lt;Movie&gt; filterMovies(List&lt;Movie&gt; movies, Predicate&lt;Movie&gt; p) {
		List&lt;Movie&gt; result = new ArrayList&lt;&gt;();
		for (Movie movie : movies) {
			if (p.test(movie)) {
				result.add(movie);
			}
		}

		return result;
	}

	public static void main(String[] args) throws Exception {
		String fileName = "movies.txt";
		String str = null;
		List&lt;Movie&gt; movies = new ArrayList&lt;&gt;();

		try (BufferedReader br = new BufferedReader(new FileReader(fileName))) {
			while ((str = br.readLine()) != null) {
				String[] arr = str.split(",");
				Movie movie = new Movie(arr[0], Integer.parseInt(arr[1]), Double.parseDouble(arr[2]));
				movies.add(movie);
			}
		}

		List&lt;Movie&gt; result = filterMovies(movies, new Rated8OrAbovePredicate());

		for (Movie movie : result) {
			System.out.println(movie);
		}

	}

}
</pre>

<pre class="console"><strong class="console-result">Butch Cassidy And The Sundance Kid,1969,8.1
Blade Runner 2049,2017,8.1
Twelve Monkeys,1995,8.0
The Dark Knight,2008,9.0
The Dark Knight Rises,2012,8.4
The Terminator,1984,8.0
Terminator 2,1991,8.5
Roman Holiday,1953,8.1
Ben Hur,1959,8.1
The Battle of Algiers,1966,8.1
Jaws,1975,8.0
Blade Runner,1982,8.2
The Silence Of The Lambs,1991,8.6
Scent of a Woman,1992,8.0
The Shawshank Redemption,1994,9.3
Heat,1995,8.2
Knockin On Heavens Door,1997,8.0
Eternal Sunshine of the Spotless Mind,2004,8.3
No Country for Old Men,2007,8.1
Rocky,1976,8.1</strong></pre>

<p>
결과를 movies.txt 원본과 비교해 보자.
강조한 부분이 결과에 포함된다.
</p>

<pre style="border: 2px dotted #999; padding: 5px;">
<strong>Butch Cassidy And The Sundance Kid,1969,8.1</strong>
Lucy,2014,6.4
Asphalte,2015,7.1
Spy,2015,7.0
<strong>Blade Runner 2049,2017,8.1</strong>
Small Town Crime,2017,6.6
The Commuter,2018,6.3
Flashdance,1983,6.1
Midnight Run,1988,7.6
<strong>Twelve Monkeys,1995,8.0</strong>
As Good As It Gets,1997,7.7
Collateral,2004,7.5
Choke,2008,6.5
<strong>The Dark Knight,2008,9.0</strong>
<strong>The Dark Knight Rises,2012,8.4</strong>
Infinitely Polar Bear,2014,7.0
Mission Impossible 3,2006,6.9
Mission Impossible 4,2011,7.4
<strong>The Terminator,1984,8.0</strong>
<strong>Terminator 2,1991,8.5</strong>
Flight,2012,7.3
Our Brand Is Crisis,2015,6.1
The Rewrite,2014,6.2
The Secret Life of Walter Mitty,2013,7.3
Waterloo Bridge,1940,7.8
<strong>Roman Holiday,1953,8.1</strong>
<strong>Ben Hur,1959,8.1</strong>
<strong>The Battle of Algiers,1966,8.1</strong>
Love Story,1970,6.9
<strong>Jaws,1975,8.0</strong>
Operation Daybreak,1975,7.1
<strong>Blade Runner,1982,8.2</strong>
<strong>The Silence Of The Lambs,1991,8.6</strong>
Thelma and Louise,1991,7.4
<strong>Scent of a Woman,1992,8.0</strong>
<strong>The Shawshank Redemption,1994,9.3</strong>
<strong>Heat,1995,8.2</strong>
Jerry Maguire,1996,7.6
<strong>Knockin On Heavens Door,1997,8.0</strong>
28 Days,2000,6.0
Unbreakable,2000,7.3
Secondhand Lion,2003,7.6
<strong>Eternal Sunshine of the Spotless Mind,2004,8.3</strong>
Little Miss Sunshine,2006,7.8
<strong>No Country for Old Men,2007,8.1</strong>
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
<strong>Rocky,1976,8.1</strong>
</pre>

<p>
여기까지 자바 7의 이야기다.
</p>

<p>
자바 8에서는 함수형 인터페이스의 인스턴스를 람다식으로도 생성할 수 있다.
MovieTest의 메인 메소드에서 List&lt;Movie&gt; result = filterMovies(movies, new Rated8OrAbovePredicate()); 구문을 아래처럼 수정하고 테스트하면 위와 같은 결과를 얻는다.
</p>

<pre class="prettyprint no-border">List&lt;Movie&gt; result = filterMovies(movies, (Movie movie) -&gt; movie.getUserRatings() &gt;= 8.0);
</pre>

<p>
람다식으로 생성한 인스턴스가 Rated8OrAbovePredicate로부터 생성된 것이 아니다.
확인하기 위해서 Rated8OrAbovePredicate 클래스를 삭제하고 테스트한다.
</p>

<p>
자바 8부터 Predicate와 같은 함수형 인터페이스가 API에 추가되었다.
임포트 문으로 API에 있는 Predicate 인터페이스를 아래처럼 추가하고, 위에서 작성한 Predicate 인터페이스를 삭제한 후 테스트한다.
</p>

<pre class="prettyprint no-border">import java.util.function.Predicate;</pre>

<p>
함수형 인터페이스의 인스턴스는 메소드 레퍼런스로도 생성할 수 있다.
메소드 레퍼런스를 테스트하기 위해 Movie.java에 다음 메소드를 추가한다.
</p>

<pre class="prettyprint">public static boolean isPopular(Movie movie) {
	return movie.getUserRatings() >= 8.0;
}
</pre>

<p>
MovieTest의 메인 메소드에서
List&lt;Movie&gt; result = filterMovies(movies, (Movie movie) -&gt; movie.getUserRatings() &gt;= 8.0); 구문을
List&lt;Movie&gt; result = filterMovies(movies, Movie::isPopular);로 수정한 후 테스트한다.
</p>

<p>
자바 8은 java.util.function.Predicate뿐 아니라 다양한 상황에서 활용할 수 있는 함수형 인터페이스를 java.util.function 패키지로 제공한다.
대표적인 함수형 인터페이스는 Predicate, Consumer, Function이다.
</p>

<p>
java.util.function.Consumer&lt;T&gt; 인터페이스는 제네릭 T 객체를 받아서 void를 반환하는 accept 추상 메소드를 정의한다.
</p>

<p>
java.util.function.Function&lt;T,R&gt; 인터페이스는 제네릭 T를 아규먼트로 받아서 제네릭 R 객체를 반환하는 apply 추상 메소드를 정의한다.
</p>

<p>
함수형 인터페이스는 람다식이나 메소드 레퍼런스의 시그니처로 작동한다.
</p>

<p>
Predicate 인터페이스는 negate(), and(), or() 메소드를 제공한다.
이러한 메소드를 디폴트 메소드라 한다.
아래와 같이 negate() 디폴트 메소드를 추가한 후 테스트한다.
</p>

<pre class="prettyprint">Predicate&lt;Movie&gt; popularMovies = Movie::isPopular;
List&lt;Movie&gt; result = filterMovies(movies, popularMovies<strong>.negate()</strong>);
</pre>

<pre class="console"><strong class="console-result">Lucy,2014,6.4
Asphalte,2015,7.1
Spy,2015,7.0
Small Town Crime,2017,6.6
The Commuter,2018,6.3
Flashdance,1983,6.1
Midnight Run,1988,7.6
As Good As It Gets,1997,7.7
Collateral,2004,7.5
Choke,2008,6.5
Infinitely Polar Bear,2014,7.0
Mission Impossible 3,2006,6.9
Mission Impossible 4,2011,7.4
Flight,2012,7.3
Our Brand Is Crisis,2015,6.1
The Rewrite,2014,6.2
The Secret Life of Walter Mitty,2013,7.3
Waterloo Bridge,1940,7.8
Love Story,1970,6.9
Operation Daybreak,1975,7.1
Thelma and Louise,1991,7.4
Jerry Maguire,1996,7.6
28 Days,2000,6.0
Unbreakable,2000,7.3
Secondhand Lion,2003,7.6
Little Miss Sunshine,2006,7.8
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
Creed,2015,7.6</strong></pre>

<p>
아래와 같이 and() 디폴트 메소드를 추가한 후 테스트한다.
</p>

<pre class="prettyprint">Predicate&lt;Movie&gt; popularMovies = Movie::isPopular;
List&lt;Movie&gt; result = filterMovies(movies, popularMovies.negate()<strong>.and(m -&gt; m.getReleaseDate() &gt; 2015)</strong>);
</pre>

<pre class="console"><strong class="console-result">Small Town Crime,2017,6.6
The Commuter,2018,6.3
Tschick,2016,7.0</strong></pre>

<p>
타입 추론 기능때문에 (Movie m) -&gt; m.getReleaseDate() > 2015 을 m -&gt; m.getReleaseDate() &gt; 2015 으로 줄여 쓸 수 있다.
</p>

<p>
최종 소스 : <a href="https://github.com/kimjonghoon/functionalProgramming">https://github.com/kimjonghoon/functionalProgramming</a>
</p>

<h3>실행 방법</h3>

<pre class="shell-prompt">
<strong>javac -d out -sourcepath src $(find src -name "*.java")</strong>
<strong>java -cp out net.java_school.examples.MovieTest</strong>
</pre>

<p>
또는 
</p>

<pre class="shell-prompt">
<strong>cd src/net/java_school/examples/</strong>
<strong>javac -d ../../../../out *.java</strong>
<strong>cd -</strong>
<strong>java -cp out net.java_school.examples.MovieTest</strong>
</pre>

</article>
