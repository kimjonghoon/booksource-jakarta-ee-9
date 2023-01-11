package net.java_school.controller;

import java.io.File;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.Principal;
import java.text.DateFormat;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import jakarta.servlet.http.HttpServletRequest;

import net.java_school.board.Article;
import net.java_school.board.AttachFile;
import net.java_school.board.Board;
import net.java_school.board.BoardService;
import net.java_school.commons.NumbersForPaging;
import net.java_school.commons.Paginator;
import net.java_school.commons.WebContants;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;

@Controller
@RequestMapping("bbs")
public class BbsController extends Paginator {

	@Autowired
	private BoardService boardService;

	private String getBoardName(String boardCd, String lang) {
		Board board = boardService.getBoard(boardCd);

		switch (lang) {
			case "en":
				return board.getBoardNm();
			case "ko":
				return board.getBoardNm_ko();
			default:
				return board.getBoardNm();
		}
	}

	//list
	@GetMapping("{boardCd}")
	public String list(@CookieValue(value="numPerPage", defaultValue="10") String num, @PathVariable String boardCd, Integer page, String searchWord, Locale locale, Model model) {

		if (page == null) {
			page = 1;
		}

		int numPerPage = Integer.parseInt(num);
		int pagePerBlock = 10;

		int totalRecord = boardService.getTotalRecord(boardCd, searchWord);

		NumbersForPaging numbers = this.getNumbersForPaging(totalRecord, page, numPerPage, pagePerBlock);

		HashMap<String, String> map = new HashMap<>();

		map.put("boardCd", boardCd);
		map.put("searchWord", searchWord);

		//Oracle start
		Integer startRecord = (page - 1) * numPerPage + 1;
		Integer endRecord = page * numPerPage;
		map.put("start", startRecord.toString());
		map.put("end", endRecord.toString());
		//Oracle end

/*		
		//MySQL and MariaDB start
		Integer offset = (page - 1) * numPerPage;
		Integer rowCount = numPerPage;
		map.put("offset", offset.toString());
		map.put("rowCount", rowCount.toString());
		//MySQL and MariaDB end
*/
		List<Article> list = boardService.getArticleList(map);

		Integer listItemNo = numbers.getListItemNo();
		Integer prevPage = numbers.getPrevBlock();
		Integer nextPage = numbers.getNextBlock();
		Integer firstPage = numbers.getFirstPage();
		Integer lastPage = numbers.getLastPage();
		Integer totalPage = numbers.getTotalPage();

		model.addAttribute("list", list);
		model.addAttribute("listItemNo", listItemNo);
		model.addAttribute("prevPage", prevPage);
		model.addAttribute("nextPage", nextPage);
		model.addAttribute("firstPage", firstPage);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("totalPage", totalPage);

		String lang = locale.getLanguage();
		List<Board> boards = boardService.getBoards();
		String boardName = this.getBoardName(boardCd, lang);
		model.addAttribute("boards", boards);
		model.addAttribute("boardName", boardName);

		//Board code(boardCd) is no longer a parameter.
		model.addAttribute("boardCd", boardCd);

		return "bbs/list";
	}

	//Detailed View
	@GetMapping("{boardCd}/{articleNo}")
	public String view(@CookieValue(value="numPerPage", defaultValue="10") String num, @PathVariable String boardCd, @PathVariable Integer articleNo,
			Integer page, String searchWord, Locale locale, HttpServletRequest req, Model model) {

		if (page == null) {
			page = 1;
		}
		String lang = locale.getLanguage();

		//Increasing the number of views using the views table:
		//articleNo, user'ip, yearMonthDayHour
		String ip = req.getRemoteAddr();
		LocalDateTime now = LocalDateTime.now();
		Integer year = now.getYear();
		Integer month = now.getMonthValue();
		Integer day = now.getDayOfMonth();
		Integer hour = now.getHour();
		String yearMonthDayHour = year.toString() + month.toString() + day.toString() + hour.toString();

		try {
			boardService.increaseHit(articleNo, ip, yearMonthDayHour);
		} catch (Exception e) {
		}

		Article article = boardService.getArticle(articleNo);//상세보기에서 볼 게시글
		List<AttachFile> attachFileList = boardService.getAttachFileList(articleNo);
		Article nextArticle = boardService.getNextArticle(articleNo, boardCd, searchWord);
		Article prevArticle = boardService.getPrevArticle(articleNo, boardCd, searchWord);
		//List<Comment> commentList = boardService.getCommentList(articleNo);
		String boardName = this.getBoardName(boardCd, lang);

		//Detailed Information of the article
		String title = article.getTitle();//title
		String content = article.getContent();//content
		//int hit = article.getHit();//the number of views
		String name = article.getName();//owner name
		String email = article.getEmail();//owner email

		Date date = article.getRegdate();
		DateFormat df = DateFormat.getDateInstance(DateFormat.MEDIUM, locale);
		String regdate = df.format(date);
		df = DateFormat.getTimeInstance(DateFormat.MEDIUM, locale);
		regdate = regdate + " " + df.format(date);

		//get the number of views
		int hit = boardService.getTotalViews(articleNo);

		model.addAttribute("title", title);
		model.addAttribute("content", content);
		model.addAttribute("hit", hit);
		model.addAttribute("name", name);
		model.addAttribute("email", email);
		model.addAttribute("regdate", regdate);
		model.addAttribute("attachFileList", attachFileList);
		model.addAttribute("nextArticle", nextArticle);
		model.addAttribute("prevArticle", prevArticle);
		//model.addAttribute("commentList", commentList);

		//to display article list on detailed view page
		int numPerPage = Integer.parseInt(num);//records per page
		int pagePerBlock = 10;//pages per block

		int totalRecord = boardService.getTotalRecord(boardCd, searchWord);

		NumbersForPaging numbers = this.getNumbersForPaging(totalRecord, page, numPerPage, pagePerBlock);

		HashMap<String, String> map = new HashMap<>();
		map.put("boardCd", boardCd);
		map.put("searchWord", searchWord);

		//Oracle start
		Integer startRecord = (page - 1) * numPerPage + 1;
		Integer endRecord = page * numPerPage;
		map.put("start", startRecord.toString());
		map.put("end", endRecord.toString());
		//Oracle end

/*
		//MySQL and MariaDB start
		Integer offset = (page - 1) * numPerPage;
		Integer rowCount = numPerPage;
		map.put("offset", offset.toString());
		map.put("rowCount", rowCount.toString());
		//MySQL and MariaDB end
*/
		List<Article> list = boardService.getArticleList(map);

		int listItemNo = numbers.getListItemNo();
		int prevPage = numbers.getPrevBlock();
		int nextPage = numbers.getNextBlock();
		int firstPage = numbers.getFirstPage();
		int lastPage = numbers.getLastPage();
		int totalPage = numbers.getTotalPage();

		model.addAttribute("list", list);
		model.addAttribute("listItemNo", listItemNo);
		model.addAttribute("prevPage", prevPage);
		model.addAttribute("firstPage", firstPage);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("nextPage", nextPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("boardName", boardName);

		List<Board> boards = boardService.getBoards();
		model.addAttribute("boards", boards);

		//articleNo and boardCd are not parameters.
		model.addAttribute("articleNo", articleNo);
		model.addAttribute("boardCd", boardCd);
		
		return "bbs/view";
	}

	//new article form
	@GetMapping("{boardCd}/new")
	public String writeForm(@PathVariable String boardCd, Locale locale, Model model) {
		String lang = locale.getLanguage();
		String boardName = this.getBoardName(boardCd, lang);
		List<Board> boards = boardService.getBoards();

		model.addAttribute("boardName", boardName);
		model.addAttribute("article", new Article());
		model.addAttribute("boards", boards);
		//boardCd 파라미터가 전달되지 않는다.
		model.addAttribute("boardCd", boardCd);

		return "bbs/write";
	}

	//new Post
	@PostMapping("{boardCd}")
	public String write(@Valid Article article,
			BindingResult bindingResult,
			@PathVariable String boardCd,
			Locale locale,
			Model model,
			@RequestParam("attachFile") MultipartFile attachFile,
			Principal principal) throws Exception {

		if (bindingResult.hasErrors()) {
			String boardName = this.getBoardName(boardCd, locale.getLanguage());
			model.addAttribute("boardName", boardName);
			List<Board> boards = boardService.getBoards();
			model.addAttribute("boards", boards);
			//boardCd is not a parameter.
			model.addAttribute("boardCd", boardCd);

			return "bbs/write";
		}

		article.setBoardCd(boardCd);
		article.setEmail(principal.getName());

		boardService.addArticle(article);

		if (!attachFile.isEmpty()) {
			//insert file information into table
			AttachFile file = new AttachFile();
			file.setFilename(attachFile.getOriginalFilename());
			file.setFiletype(attachFile.getContentType());
			file.setFilesize(attachFile.getSize());
			file.setArticleNo(article.getArticleNo());
			file.setEmail(principal.getName());
			boardService.addAttachFile(file);
	
			//save the uploaded file
			File myDir = new File(WebContants.UPLOAD_PATH + principal.getName());
			if (!myDir.exists()) myDir.mkdirs();
		
			Path path = Paths.get(WebContants.UPLOAD_PATH + principal.getName());
			
			try (InputStream inputStream = attachFile.getInputStream()) {
				Files.copy(inputStream, path.resolve(attachFile.getOriginalFilename()), StandardCopyOption.REPLACE_EXISTING);
			}
		}

		return "redirect:/bbs/" + article.getBoardCd() + "?page=1";
	}

	//edit form 
	@GetMapping("{boardCd}/{articleNo}/edit")
	public String modifyForm(@PathVariable String boardCd, @PathVariable Integer articleNo, Locale locale, Model model) {

		String lang = locale.getLanguage();
		Article article = boardService.getArticle(articleNo);
		String boardName = this.getBoardName(boardCd, lang);

		//Post information on the edit page
		model.addAttribute("article", article);
		model.addAttribute("boardName", boardName);

		List<Board> boards = boardService.getBoards();
		model.addAttribute("boards", boards);
		//boardCd and articleNo are not parameters
		model.addAttribute("boardCd", boardCd);
		model.addAttribute("articleNo", articleNo);

		return "bbs/modify";
	}

	//edit post
	@PostMapping("{boardCd}/{articleNo}")
	public String modify(@Valid Article article,
			BindingResult bindingResult,
			@PathVariable String boardCd,
			@PathVariable Integer articleNo,
			Integer page,
			String searchWord,
			MultipartFile attachFile,
			Locale locale,
			Model model) throws Exception {

		if (bindingResult.hasErrors()) {
			String boardName = this.getBoardName(article.getBoardCd(), locale.getLanguage());
			model.addAttribute("boardName", boardName);
			List<Board> boards = boardService.getBoards();
			model.addAttribute("boards", boards);
			model.addAttribute("boardCd", boardCd);
			model.addAttribute("articleNo", articleNo);

			return "bbs/modify";
		}

		article.setArticleNo(articleNo);
		article.setBoardCd(boardCd);
		//retain the owner of the post even if the administrator edits that 
		String email = boardService.getArticle(article.getArticleNo()).getEmail();
		article.setEmail(email);

		//edit the post
		boardService.modifyArticle(article);

		if (!attachFile.isEmpty()) {
			//insert the uploaded file information into the table 
			AttachFile file = new AttachFile();
			file.setFilename(attachFile.getOriginalFilename());
			file.setFiletype(attachFile.getContentType());
			file.setFilesize(attachFile.getSize());
			file.setArticleNo(article.getArticleNo());
			file.setEmail(article.getEmail());
			boardService.addAttachFile(file);
	
			//save the uploaded file
			File myDir = new File(WebContants.UPLOAD_PATH + email);
			if (!myDir.exists()) myDir.mkdirs();
		
			Path path = Paths.get(WebContants.UPLOAD_PATH + email);
			
			try (InputStream inputStream = attachFile.getInputStream()) {
				Files.copy(inputStream, path.resolve(attachFile.getOriginalFilename()), StandardCopyOption.REPLACE_EXISTING);
			}
		}
		
		searchWord = URLEncoder.encode(searchWord, "UTF-8");

		return "redirect:/bbs/"
			+ boardCd
			+ "/"
			+ articleNo
			+ "?page="
			+ page
			+ "&searchWord="
			+ searchWord;
	}

	@DeleteMapping("/{boardCd}/{articleNo}")
	public String deleteArticle(@PathVariable String boardCd, @PathVariable Integer articleNo, Integer page, String searchWord) {
		Article article = boardService.getArticle(articleNo);
		boardService.removeArticle(article);

		return "redirect:/bbs/"
			+ boardCd
			+ "?page="
			+ page
			+ "&searchWord="
			+ searchWord;
	}

	@DeleteMapping("deleteAttachFile")
	public String deleteAttachFile(Integer attachFileNo,
			Integer articleNo,
			String boardCd,
			Integer page,
			String searchWord) throws Exception {

		AttachFile attachFile = boardService.getAttachFile(attachFileNo);
		boardService.removeAttachFile(attachFile);

		searchWord = URLEncoder.encode(searchWord, "UTF-8");

		return "redirect:/bbs/"
			+ boardCd
			+ "/"
			+ articleNo
			+ "?page="
			+ page
			+ "&searchWord="
			+ searchWord;
	}
}
