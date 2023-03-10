<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<article>
<div class="last-modified">Last Modified 2022.1.19</div>

<h1>Functional programming in Java 8</h1>

<p>
Since Java 8, Java supports functional programming. If the parameter type of a method is a functional interface, you can substitute a lambda expression or a method reference for it. A functional interface is an interface that has only one abstract method.
</p>

<p>
Create a movies.txt file as follows and copy it to the root directory.
</p>

<pre class="prettyprint">Butch Cassidy And The Sundance Kid,1969,8.1
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
Create a movie class as shown below.
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

<ul>
	<li>title: movie title</li>
	<li>releaseDate: release date</li>
	<li>userRatings: user ratings</li>
</ul>

<p>
Create a functional interface as shown below:
</p>

<pre class="prettyprint">package net.java_school.examples;

public interface Predicate&lt;T&gt; {
  boolean test(T t);
}
</pre>

<p class="note">
A predicate in mathematics refers to a function that takes a value and returns true or false.
</p>

<p>
Create a class that implements the Predicate functional interface as follows:
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
Create a class for testing as follows:
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
Compare the result with the original movie.txt. --The items highlighted below are in the results--
</p>

<pre style="border: 2px dotted #999; padding: 5px;"><strong>Butch Cassidy And The Sundance Kid,1969,8.1</strong>
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
So far, this is about Java 7.
</p>

<p>
In Java 8, you can instantiate a functional interface with a lambda expression. In MovieTest's main method, you can get the same result by modifying the List&lt;Movie&gt; result = filterMovies(movies, new Rated8OrAbovePredicate()) statement as below:
</p>

<pre class="prettyprint no-border">List&lt;Movie&gt; result = filterMovies(movies, (Movie movie) -&gt; movie.getUserRatings() &gt;= 8.0);</pre>

<p>
A lambda expression instance is not created from Rated8OrAbovePredicate. To verify, delete the class Rated8OrAbovePredicate and test again.
</p>

<p>
Java 8 has added a functional interface like Predicate to its API. Add the Predicate interface of API, delete the Predicate interface we created, and test again.
</p>

<pre class="prettyprint no-border">import java.util.function.Predicate;</pre>

<p>
You can also create a method reference with an instance of a functional interface. Add the following method to Movie.java to test the method reference.
</p>

<pre class="prettyprint">public static boolean isPopular(Movie movie) {
  return movie.getUserRatings() &gt;= 8.0;
}
</pre>

<p>
In MovieTest's main method, modify
</p>

<pre class="prettyprint no-border">List&lt;Movie&gt; result = filterMovies(movies, (Movie movie) -&gt; movie.getUserRatings() &gt;= 8.0);</pre>

<p>
to
</p>

<pre class="prettyprint no-border">List&lt;Movie&gt; result = filterMovies(movies, Movie::isPopular);</pre>

<p>
and test again.
</p>

<p>
Java 8 provides many functional interfaces in the java.util.function package so you can use them in various situations. Functional interface act as a signature of lambda expression or method reference. Functional interfaces are classified into three categories: Predicate, Consumer, and Function.
</p>

<p>
java.util.function.Consumer&lt;T&gt; interface defines the accept method that accepts a generic T object and returns void.
</p>

<p>
java.util.function.Function&lt;T,R&gt; interface defines the apply abstract method that accepts a generic T abject and returns generic R.
</p>

<p>
The Predicate interface provides the default methods: negate(), and(), or(). Add the negate() default method as shown below and test again.
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
Add the and() default method as shown below and test again.
</p>

<pre class="prettyprint">Predicate&lt;Movie&gt; popularMovies = Movie::isPopular;
List&lt;Movie&gt; result = filterMovies(movies, popularMovies.negate()<strong>.and(m -&gt; m.getReleaseDate() &gt; 2015)</strong>);
</pre>

<pre class="console"><strong class="console-result">Small Town Crime,2017,6.6
The Commuter,2018,6.3
Tschick,2016,7.0</strong></pre>

<p>
Due to Type inference, 
</p>

<pre class="prettyprint no-border">(Movie m) -&gt; m.getReleaseDate() &gt; 2015</pre>

<p>
can be abbreviated to
</p>

<pre class="prettyprint no-border">m -&gt; m.getReleaseDate() &gt; 2015</pre>

<p>
Final source: <a href="https://github.com/kimjonghoon/functionalProgramming">https://github.com/kimjonghoon/functionalProgramming</a>
</p>

<h3>How to run</h3>

<pre class="shell-prompt">
<strong>javac -d out -sourcepath src $(find src -name "*.java")</strong>
<strong>java -cp out net.java_school.examples.MovieTest</strong>
</pre>

<p>
Or
</p>

<pre class="shell-prompt">
<strong>cd src/net/java_school/examples/</strong>
<strong>javac -d ../../../../out *.java</strong>
<strong>cd -</strong>
<strong>java -cp out net.java_school.examples.MovieTest</strong>
</pre>

</article>
