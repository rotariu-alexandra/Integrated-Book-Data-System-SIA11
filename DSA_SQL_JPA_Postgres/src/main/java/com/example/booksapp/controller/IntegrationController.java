package com.example.booksapp.controller;

import com.example.booksapp.dto.UserRatingBookItem;
import com.example.booksapp.dto.UserRatingStats;
import com.example.booksapp.dto.UserRatingsBooksView;
import com.example.booksapp.dto.UserWithRatingsView;
import com.example.booksapp.model.Rating;
import com.example.booksapp.repository.RatingRepository;
import com.example.booksapp.repository.UserRepository;
import com.example.booksapp.service.IntegrationService;
import com.example.booksapp.service.PostgresUserService;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/postgres")
public class IntegrationController {

    private final IntegrationService service;
    private final PostgresUserService postgresUserService;
    private final UserRepository userRepository;
    private final RatingRepository ratingRepository;

    public IntegrationController(IntegrationService service,
                                 PostgresUserService postgresUserService,
                                 UserRepository userRepository,
                                 RatingRepository ratingRepository) {
        this.service = service;
        this.postgresUserService = postgresUserService;
        this.userRepository = userRepository;
        this.ratingRepository = ratingRepository;
    }

    @GetMapping("/users")
    public List<Map<String, Object>> getUsers() {
        return userRepository.findAll()
                .stream()
                .limit(50)
                .map(user -> {
                    Map<String, Object> item = new HashMap<>();

                    item.put("userId", user.getUserId());
                    item.put("age", user.getAge() == null ? 0 : user.getAge());
                    item.put("location", user.getLocation() == null
                            ? "unknown"
                            : user.getLocation().replace(",", " "));

                    return item;
                })
                .toList();
    }

    @GetMapping("/ratings")
    public List<Rating> getRatings() {
        return ratingRepository.findAll()
                .stream()
                .limit(50)
                .toList();
    }

    @GetMapping("/analytics/top-users")
    public List<UserRatingStats> getTopUsers() {
        return service.getTopUsers();
    }

    @GetMapping("/users/{userId}/ratings")
    public List<UserRatingBookItem> getUserRatingItems(@PathVariable Integer userId) {
        return service.getUserRatingItems(userId);
    }

    @GetMapping("/users/{userId}/ratings/details")
    public UserRatingsBooksView getUserRatingsBooks(@PathVariable Integer userId) {
        return service.getUserRatingsBooks(userId);
    }

    @GetMapping("/integration/users-with-ratings")
    public List<UserWithRatingsView> getUsersWithRatings() {
        return postgresUserService.getUsersWithRatings();
    }
}