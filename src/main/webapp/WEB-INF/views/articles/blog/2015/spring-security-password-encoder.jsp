<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<article>
<div class="last-modified">Last Modified 2015.9.10</div>

<h1>스프링 시큐리티 - 비밀번호 암호화</h1>

<p>
비밀번호는 단순 텍스트로 저장해서는 안 된다.<br />
</p>

<h3>패스워드 인코더 설정</h3>

<p>
&lt;authentication-provider&gt; 엘리먼트에 &lt;password-encoder&gt; 엘리먼트를 추가한다.
</p>

<h6 class="src">security.xml</h6>
<pre class="prettyprint">
&lt;authentication-manager&gt;
  &lt;authentication-provider&gt;
    &lt;jdbc-user-service data-source-ref="dataSource"
      users-by-username-query="select 
          email as username,passwd as password,1 as enabled
        from member 
        where email = ?"
      authorities-by-username-query="select 
          email as username,authority
        from authorities 
        where email = ?" /&gt;
    <strong>&lt;password-encoder hash="bcrypt" /&gt;</strong>
  &lt;/authentication-provider&gt;
&lt;/authentication-manager&gt;
</pre>

<p>
hash="bcrypt"로 설정하면 인터페이스 PasswordEncoder의 구현체 중 bcrypt 알고리즘을 사용하는 BCryptPasswordEncoder가 설정된다.<br />
톰캣을 재실행하고 hong@gmail.org/1111으로 로그인을 시도하면 이전과 달리 로그인이 실패하게 된다.<br />
회원 테이블에 암호화가 안된 1111이 저장되어 있기 때문이다.<br />
권한 테이블과 회원 테이블을 모두 삭제한다.<br />
</p>

<pre class="shell-prompt">
sqlplus java/school

delete from authorities;

delete from member;

commit;
</pre>

<p>
이메일은 hong@gmail.org, 비밀번호는 1111로 회원가입한다.<br />
가입 후 로그인을 시도하면 역시 로그인이 실패한다.<br />
회원 테이블에 비밀번호가 여전히 단순 텍스트 1111로 저장되기 때문이다.<br />
비밀번호가 암호화하여 저장하기 위해 UserServiceImpl.java를 수정해야 한다.<br />
</p>

<h6 class="src">UserServiceImpl.java</h6>
<pre class="prettyprint">

<strong>import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;</strong>

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	private UserMapper userMapper;
	<strong>
	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;</strong>

	@Override
	public void addUser(User user) {
		<strong>user.setPasswd(this.bcryptPasswordEncoder.encode(user.getPasswd()));</strong>
		userMapper.insert(user);
	}
	
	//..생략..	
}	
</pre>

<p>
자바 소스를 수정했으니
컴파일(<em class="path">mvn clean compile war:inplace</em>)하고 톰캣을 재실행한다.<br />
이번에는 애플리케이션이 로딩되지 않는다.<br />
톰캣 로그를 확인해 보면,<br />
로딩에 실패한 원인은 UserServiceImpl에 BCryptPasswordEncoder를 주입할 수 없기 때문이다.<br />
BCryptPasswordEncoder를 Authentication Provider 밖에서도 참조하기 원한다면 
패스워드 인코더 설정을 수정해야 한다.<br />
</p>

<h6 class="src">security.xml</h6>
<pre class="prettyprint">
<strong>&lt;beans:bean id="bcryptPasswordEncoAccess Deniedder" 
  class="org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder" /&gt;
</strong>
&lt;authentication-manager&gt;
  &lt;authentication-provider&gt;
    &lt;jdbc-user-service data-source-ref="dataSource"
      users-by-username-query="select 
          email as username,passwd as password,1 as enabled
        from member 
        where email = ?"
      authorities-by-username-query="select 
          email as username,authority
        from authorities 
        where email = ?" /&gt;
    &lt;password-encoder <strong>ref="bcryptPasswordEncoder"</strong> /&gt;
  &lt;/authentication-provider&gt;
&lt;/authentication-manager&gt;
</pre>

<p>
톰캣을 재실행한 후 회원가입을 시도한다.<br />
이번에는 회원 테이블의 패스워드 컬럼의 길이때문에 SQLException이 발생하게 된다.<br />
member 테이블의 passwd 컬럼을 변경한다.<br />
</p>

<h6 class="src">Oracle</h6>
<pre class="prettyprint">
alter table member modify passwd varchar2(200);
</pre>

<h6 class="src">MySQL</h6>
<pre class="prettyprint">
alter table member modify passwd varchar(200) not null;
</pre>

<p>
이메일은 im@gmail.org, 비밀번호는 1111로 회원가입한다.<br />
이제는 로그인이 되어야 한다.<br />
</p>

<h3>회원 수정, 비밀번호 변경, 탈퇴</h3>

<p>
회원 수정, 비밀번호 변경, 탈퇴를 수정해야 한다.<br />
</p>

<h6 class="src">UsersController.java</h6>
<pre class="prettyprint">
@RequestMapping(value="/bye", method=RequestMethod.POST)
public String bye(String email, String passwd, HttpServletRequest req) 
        throws ServletException {
	User user = new User();
	user.setEmail(email);
	user.setPasswd(passwd);
	userService.bye(user);
	
	req.logout();

	return "redirect:/users/bye_confirm";
}
</pre>

<h6 class="src">UserServiceImpl.java</h6>
<pre class="prettyprint">
@Override
public int editAccount(User user) {
	String encodedPassword = this.getUser(user.getEmail()).getPasswd();   
	boolean check = this.bcryptPasswordEncoder.matches(user.getPasswd(), encodedPassword);

	if (check == false) {
		throw new AccessDeniedException("현재 비밀번호가 틀립니다.");
	}
	
	user.setPasswd(encodedPassword);

	return userMapper.update(user);
}

@Override
public int changePasswd(String currentPasswd, String newPasswd, String email) {
	String encodedPassword = this.getUser(email).getPasswd();
	boolean check = this.bcryptPasswordEncoder.matches(currentPasswd, encodedPassword);

	if (check == false) {
		throw new AccessDeniedException("현재 비밀번호가 틀립니다.");
	}
	
	newPasswd = this.bcryptPasswordEncoder.encode(newPasswd);
	
	return userMapper.updatePasswd(encodedPassword, newPasswd, email);
}

@Override
public void bye(User user) {
	String encodedPassword = this.getUser(user.getEmail()).getPasswd();
	boolean check = this.bcryptPasswordEncoder.matches(user.getPasswd(), encodedPassword);

	if (check == false) {
		throw new AccessDeniedException("현재 비밀번호가 틀립니다.");
	}
	
	userMapper.deleteAuthority(user.getEmail());
	userMapper.delete(user);
}
</pre>

<p>
UserService.java의 login(String email, String passwd) 메소드는 필요 없으니 삭제한다.<br />
UserServiceImpl.java와 UserMapper.java와 UserMapper.xml에서도 이 메소드와 관련된 부분을 함께 삭제한다.<br />
</p>

</article>
