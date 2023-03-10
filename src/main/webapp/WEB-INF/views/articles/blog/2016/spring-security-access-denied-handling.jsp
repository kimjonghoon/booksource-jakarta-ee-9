<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<article>
<div class="last-modified">Last Modified 2016.10.2</div>

<h1>스프링 시큐리티 - 접근 거부 핸들링</h1>

<h2>웹 요청 보안</h2>

<p>
ROLE_USER 권한만 가진 사용자가 http://localhost:8080/admin를 요청할 때
/WEB-INF/views/403.jsp 페이지로 포워딩하는 방법  
</p>

<h6 class="src">security.xml</h6>
<pre class="prettyprint">
&lt;http&gt;
	<strong>&lt;access-denied-handler error-page="/403" /&gt;</strong>
	&lt;intercept-url pattern="/users/bye_confirm" access="permitAll"/&gt;
	&lt;intercept-url pattern="/users/welcome" access="permitAll"/&gt;
	&lt;intercept-url pattern="/users/signUp" access="permitAll"/&gt;
	&lt;intercept-url pattern="/users/login" access="permitAll"/&gt;
	&lt;intercept-url pattern="/images/**" access="permitAll"/&gt;
	&lt;intercept-url pattern="/css/**" access="permitAll"/&gt;
	&lt;intercept-url pattern="/js/**" access="permitAll"/&gt;
	&lt;intercept-url pattern="/admin/**" access="hasRole('ROLE_ADMIN')"/&gt;
	&lt;intercept-url pattern="/users/**" access="hasAnyRole('ROLE_ADMIN','ROLE_USER')"/&gt;
	&lt;intercept-url pattern="/bbs/**" access="hasAnyRole('ROLE_ADMIN','ROLE_USER')"/&gt;
	
	&lt;!--  생략 --&gt;
	  
</pre>

<p>
&lt;access-denied-handler error-page="/403" /&gt;만으로 권한이 없는 사용자를 /WEB-INF/views/403.jsp 페이지로 보내지 않는다.<br />
컨트롤러에서 매핑하지 않으면, 결국 http://localhost:8080/403을 요청하게 되고, web.xml에서 설정한 404 에러 페이지를 보게 된다.<br />
WEB-INF/views/403.jsp 파일을 만들고 HomeController에 다음 메소드를 추가한다.<br />

스프링 시큐리티 태그를 사용할 수 있으므로 header.jsp 파일을 인클루드하고 있다.<br />
</p>

<h6 class="src">/403.jsp</h6>
<pre class="prettyprint">
&lt;%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%&gt;
&lt;%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%&gt;
&lt;%@ page import="net.java_school.user.User" %&gt;
&lt;!DOCTYPE html&gt;
&lt;html lang="ko"&gt;
&lt;head&gt;
&lt;meta charset="UTF-8" /&gt;
&lt;title&gt;403&lt;/title&gt;
&lt;link rel="stylesheet" href="/css/screen.css" type="text/css" /&gt;
&lt;script type="text/javascript" src="/js/jquery-3.2.1.min.js"&gt;&lt;/script&gt;
&lt;/head&gt;
&lt;body&gt;
&lt;div id="wrap"&gt;

    &lt;div id="header"&gt;
        <strong>&lt;%@ include file="inc/header.jsp" %&gt;</strong>
    &lt;/div&gt;
    
    &lt;div id="main-menu"&gt;
        &lt;%@ include file="inc/main-menu.jsp" %&gt;
    &lt;/div&gt;
    
    &lt;div id="container"&gt;
        &lt;div id="content" style="min-height: 800px;"&gt;
            &lt;div id="content-categories"&gt;Error&lt;/div&gt;
            &lt;h1&gt;403&lt;/h1&gt;
            Access is Denied.
        &lt;/div&gt;
    &lt;/div&gt;
    
    &lt;div id="sidebar"&gt;
        &lt;h1&gt;Error&lt;/h1&gt;
    &lt;/div&gt;
    
    &lt;div id="extra"&gt;
        &lt;%@ include file="inc/extra.jsp" %&gt;    
    &lt;/div&gt;
    
    &lt;div id="footer"&gt;
        &lt;%@ include file="inc/footer.jsp" %&gt;
    &lt;/div&gt;
        
&lt;/div&gt;

&lt;/body&gt;
&lt;/html&gt;
</pre>

<h6 class="src">HomeController.java</h6>
<pre class="prettyprint">
@RequestMapping(value="/403", method={RequestMethod.GET,RequestMethod.POST})
public String error403() {
	return "403";
}
</pre>

<p>
참고로, 다음은 web.xml의 에러 페이지 설정이다.
</p>

<h6 class="src">web.xml</h6>
<pre class="prettyprint">
&lt;error-page&gt;
	&lt;error-code&gt;404&lt;/error-code&gt;
	&lt;location&gt;/WEB-INF/views/404.jsp&lt;/location&gt;
&lt;/error-page&gt;

&lt;error-page&gt;
	&lt;error-code&gt;500&lt;/error-code&gt;
	&lt;location&gt;/WEB-INF/views/500.jsp&lt;/location&gt;
&lt;/error-page&gt;
</pre>

<p>
mvn clean compile war:inplace로 컴파일하고,
톰캣을 재실행한 후 http://localhost:8080/admin을 요청한다.
로그인한 사용자가 ROLE_USER 권한만 가진 사용자라면 /WEB-INF/views/403.jsp가 보일 것이다.<br />
</p>

<h3>AccessDeniedHandler 구현</h3>

<p>
접근 권한이 없어 에러 페이지로 이동하는 상황에서 수행해야 할 비즈니스 로직이 있다면
org.springframework.security.web.access.AccessDeniedHandler를 구현해야 한다.<br />
security.xml 파일을 다음과 같이 수정한다.<br />
</p>

<h6 class="src">security.xml</h6>
<pre class="prettyprint">
&lt;access-denied-handler <strong>ref="my403"</strong> /&gt;
</pre>

<p>
security.xml에 다음을 추가한다.<br />
</p>

<h6 class="src">security.xml</h6>
<pre class="prettyprint">
&lt;beans:bean id="my403" class="net.java_school.spring.MyAccessDeniedHandler"&gt;
	&lt;beans:property name="errorPage" value="403" /&gt;
&lt;/beans:bean&gt;
</pre>

<p>
security.xml에 추가한 설정대로 AccessDeniedHandler를 구현하는 MyAccessDeniedHandler를 생성한다.<br />
</p>

<h6 class="src">MyAccessDeniedHandler.java</h6>
<pre class="prettyprint">
package net.java_school.spring;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

public class MyAccessDeniedHandler implements AccessDeniedHandler {

	private String errorPage;

	public void setErrorPage(String errorPage) {
		this.errorPage = errorPage;
	}

	@Override
	public void handle(HttpServletRequest req, HttpServletResponse resp, AccessDeniedException e)
			throws IOException, ServletException {
		//TODO 수행할 비즈니스 로직
		req.getRequestDispatcher(errorPage).forward(req, resp);
	}

}
</pre>

<p>
web.xml 설정으로 보이는 에러 페이지는 스프링 시큐리티 태그가 작동하지 않는다.
이유는 스프링 필터 체인에서 뷰 레벨 보안이 적용하기 위한 필터가 작동하기 전에 에러 페이지로 이동하기 때문이다.
</p>

<h2>메소드 보안</h2>

<p>
스프링 MVC에서 익셉션과 에러 페이지를 매핑하는 방법 중 SimpleMappingExceptionResolver를 사용하는 것이 가장 간단하다.
아래는 org.springframework.security.access.AccessDeniedException 익셉션이 발생할 때 error-403으로 매핑한다.
그 외 다른 익셉션이 발생하면 error로 매핑한다.
매핑은 우리가 설정한 뷰 리졸버에 의해 각각 /WEB-INF/views/error-403.jsp와 /WEB-INF/views/error.jsp로 해석된다.
컨트롤러가 이들을 매핑할 필요는 없다.
</p>

<h6 class="src">spring-bbs-servlet.xml</h6>
<pre class="prettyprint">
&lt;bean class="org.springframework.web.servlet.handler.SimpleMappingExceptionResolver"&gt;
	&lt;property name="defaultErrorView" value="error" /&gt;
	&lt;property name="exceptionMappings"&gt;
		&lt;props&gt;
			&lt;prop key="AccessDeniedException"&gt;
			error-403
			&lt;/prop&gt;
		&lt;/props&gt;
	&lt;/property&gt;
&lt;/bean&gt;
</pre>

<p>
im@gmail.org/1111로 로그인하고 탈퇴메뉴에서 hong@gmail.org와 1111를 입력하여 탈퇴를 시도하면
</p>

<h6 class="src">UserService.java</h6>
<pre class="prettyprint">
@PreAuthorize("hasAnyRole('ROLE_ADMIN','ROLE_USER') and <strong>#user.email == principal.username</strong>")
public void bye(User user);
</pre>

<p>
위의 강조된 부분이 작동하여 org.springframework.security.access.AccessDeniedException 익셉션이 발생하여 결국 /WEB-INF/views/error-403.jsp을 보게 된다.

다시 탈퇴메뉴에서 이번에는 im@gmail.org와 비밀번호를 틀리게 입력하면 
</p>

<h6 class="src">UserServiceImpl.java</h6>
<pre class="prettyprint">
@Override
public void bye(User user) {
	String encodedPassword = this.getUser(user.getEmail()).getPasswd();
	boolean check = this.bcryptPasswordEncoder.matches(user.getPasswd(), encodedPassword);
	
	if (check == false) {
		<strong>throw new AccessDeniedException("비밀번호가 틀립니다.");</strong>
	}
	
	userMapper.deleteAuthority(user.getEmail());
	userMapper.delete(user);
}
</pre>

<p>
위의 강조된 부분이 작동하여 org.springframework.security.access.AccessDeniedException 익셉션이 발생하여 결국 /WEB-INF/views/error-403.jsp을 보게 된다.
</p>

</article>
