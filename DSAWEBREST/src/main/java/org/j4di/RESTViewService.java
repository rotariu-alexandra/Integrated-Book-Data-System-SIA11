package org.j4di;

import org.j4di.service.AnalyticsService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/OLAP")
public class RESTViewService {

	private final AnalyticsService analyticsService;

	public RESTViewService(AnalyticsService analyticsService) {
		this.analyticsService = analyticsService;
	}

	@GetMapping(value = "/BOOKS", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Map<String, Object>> getBooksPreview() {
		return analyticsService.getBooksPreview();
	}

	@GetMapping(value = "/TOP_RATED_BOOKS", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Map<String, Object>> getTopRatedBooks() {
		return analyticsService.getTopRatedBooks();
	}

	@GetMapping(value = "/USERS", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Map<String, Object>> getUsersPreview() {
		return analyticsService.getUsersPreview();
	}

	@GetMapping(value = "/RATINGS", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Map<String, Object>> getRatingsPreview() {
		return analyticsService.getRatingsPreview();
	}

	@GetMapping(value = "/DASHBOARD_SUMMARY", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Map<String, Object>> getDashboardSummary() {
		return analyticsService.getDashboardSummary();
	}

	@GetMapping(value = "/RECOMMENDATION_SCORES", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Map<String, Object>> getRecommendationScores() {
		return analyticsService.getRecommendationScores();
	}

	@GetMapping(value = "/BOOKS_BY_AGE", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Map<String, Object>> getBooksByAgeGroups() {
		return analyticsService.getBooksByAgeGroups();
	}

	@GetMapping(value = "/PUBLISHER_PERFORMANCE", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Map<String, Object>> getPublisherPerformance() {
		return analyticsService.getPublisherPerformance();
	}

	@GetMapping(value = "/USER_ACTIVITY_ANALYTICS", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Map<String, Object>> getUserActivityAnalytics() {
		return analyticsService.getUserActivityAnalytics();
	}

	@GetMapping(value = "/PUBLISHER_RECOMMENDATION", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Map<String, Object>> getPublisherRecommendationScore() {
		return analyticsService.getPublisherRecommendationScore();
	}

	@GetMapping(value = "/YEARS_ANALYTICS", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Map<String, Object>> getYearsAnalytics() {
		return analyticsService.getYearsAnalytics();
	}

	@GetMapping(value = "/RECOMMENDATION_SEGMENTS", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Map<String, Object>> getRecommendationSegments() {
		return analyticsService.getRecommendationSegments();
	}

	@GetMapping(value = "/HIGH_POTENTIAL_BOOKS", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Map<String, Object>> getHighPotentialBooks() {
		return analyticsService.getHighPotentialBooks();
	}
}