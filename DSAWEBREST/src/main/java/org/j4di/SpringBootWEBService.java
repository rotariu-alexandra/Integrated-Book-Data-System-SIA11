package org.j4di;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

import java.util.logging.Logger;

@SpringBootApplication
public class SpringBootWEBService extends SpringBootServletInitializer {

	private static final Logger logger = Logger.getLogger(SpringBootWEBService.class.getName());

	public static void main(String[] args) {
		logger.info("Loading DSA-WEB-RESTService...");
		SpringApplication.run(SpringBootWEBService.class, args);
	}
}