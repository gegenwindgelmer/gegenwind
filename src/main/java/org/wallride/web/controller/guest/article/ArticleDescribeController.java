package org.wallride.web.controller.guest.article;

import org.joda.time.LocalDate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.wallride.core.domain.Article;
import org.wallride.core.service.ArticleService;
import org.wallride.web.support.HttpNotFoundException;

import javax.inject.Inject;

@Controller
@RequestMapping("/{language}/{year:[0-9]{4}}/{month:[0-9]{2}}/{day:[0-9]{2}}/{code:.+}")
public class ArticleDescribeController {

	@Inject
	private ArticleService articleService;

	@RequestMapping
	public String describe(
			@PathVariable String language,
			@PathVariable int year,
			@PathVariable int month,
			@PathVariable int day,
			@PathVariable String code,
			Model model,
			RedirectAttributes redirectAttributes) {
		Article article = articleService.readArticleByCode(code, language);
		if (article == null) {
			throw new HttpNotFoundException();
		}

		LocalDate date = new LocalDate(year, month, day);
		if (!article.getDate().toLocalDate().equals(date)) {
			redirectAttributes.addAttribute("language", language);
			redirectAttributes.addAttribute("year", article.getDate().getYear());
			redirectAttributes.addAttribute("month", article.getDate().getMonthOfYear());
			redirectAttributes.addAttribute("day", article.getDate().getDayOfMonth());
			redirectAttributes.addAttribute("code", code);
			return "redirect:/{language}/{year}/{month}/{day}/{code}";
		}

		model.addAttribute("article", article);
		return "/article/describe";
	}
}
