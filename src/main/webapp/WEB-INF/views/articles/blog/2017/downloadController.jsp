<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<article>
<div class="last-modified">Last Modified 2017.10.31</div>

<h1>다운로드 컨트롤러</h1>

<p>
예제 소스 : <a href="https://github.com/kimjonghoon/downloadController">https://github.com/kimjonghoon/downloadController</a><br />
pom.xml 파일이 있는 곳에서 mvn jetty:run을 실행한 후, http://localhost:8080에 방문한다.
</p>

<h6 class="src">DownloadController.java</h6>
<pre class="prettyprint">
package net.java_school.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/file")
public class DownloadController {

	private static final String FILE_DIR = "./files/";

	@GetMapping("/download/{filename:.+}")
	public ResponseEntity&lt;InputStreamResource&gt; download(@PathVariable String filename, HttpServletRequest req) throws IOException {

		File file = new File(FILE_DIR + filename);
		
		InputStreamResource resource = new InputStreamResource(new FileInputStream(file));

		boolean ie = req.getHeader("User-Agent").indexOf("MSIE") != -1;
		if (ie) {
			filename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", " ");
		} else {
			filename = new String(filename.getBytes("UTF-8"), "8859_1");
		}

		return ResponseEntity.ok()
				.header(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=\"" + filename + "\"")
				.contentType(MediaType.APPLICATION_OCTET_STREAM).contentLength(file.length())
				.body(resource);
	}
	
	@PostMapping("/download")
	public void download(String filename, HttpServletRequest req, HttpServletResponse resp) {
		OutputStream outputStream = null;

		try {
			File file = new File(FILE_DIR + filename);

			String filetype = filename.substring(filename.indexOf(".") + 1, filename.length());

			if (filetype.trim().equalsIgnoreCase("txt")) {
				resp.setContentType("text/plain");
			} else {
				resp.setContentType("application/octet-stream");
			}

			resp.setContentLength((int) file.length());

			boolean ie = req.getHeader("User-Agent").indexOf("MSIE") != -1;
			if (ie) {
				filename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", " ");
			} else {
				filename = new String(filename.getBytes("UTF-8"), "8859_1");
			}

			resp.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

			outputStream = resp.getOutputStream();
			FileInputStream fis = null;

			try {
				fis = new FileInputStream(file);
				FileCopyUtils.copy(fis, outputStream);
			} finally {
				if (fis!= null) {
					fis.close();
				}
			}
		} catch (IOException e) {
			throw new RuntimeException(e);
		} finally {
			try {
				outputStream.close();
				resp.flushBuffer();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
</pre>

<h6 class="src">/WEB-INF/views/index.jsp</h6>
<pre class="prettyprint">
&lt;%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%&gt;
&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
&lt;meta charset="UTF-8" /&gt;
&lt;title&gt;Home&lt;/title&gt;
&lt;meta name="Keywords" content="Download Controller TEST" /&gt;
&lt;meta name="Description" content="Download Controller TEST" /&gt;
&lt;/head&gt;
&lt;body&gt;

&lt;form id="downForm" action="/file/download" method="post"&gt;
	&lt;input type="hidden" name="filename" value="Test.png" /&gt;
	&lt;input type="submit" value="POST Download" /&gt;
&lt;/form&gt;

&lt;div&gt;&lt;a href="/file/download/Test.png"&gt;GET Download&lt;/a&gt;&lt;/div&gt;

&lt;/body&gt;
&lt;/html&gt;
</pre>

<span id="refer">참고</span>
<ul id="references">
	<li><a href="http://www.boraji.com/spring-mvc-4-file-download-example">http://www.boraji.com/spring-mvc-4-file-download-example</a></li>
</ul>

</article>
