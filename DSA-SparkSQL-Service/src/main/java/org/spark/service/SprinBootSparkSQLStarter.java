package org.spark.service;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

import java.util.logging.Logger;

@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
public class SprinBootSparkSQLStarter extends SpringBootServletInitializer {

    private static Logger logger = Logger.getLogger(SprinBootSparkSQLStarter.class.getName());

    public static void main(String[] args) throws Exception {

        System.setProperty("hadoop.home.dir", "C:\\hadoop");
        System.setProperty("HADOOP_HOME", "C:\\hadoop");
        System.setProperty("spark.sql.warehouse.dir", "file:///C:/tmp/spark-warehouse");

        logger.info("Loading ... SparkStarterService with Spark Default Settings ... DSA");

        SpringApplication.run(SprinBootSparkSQLStarter.class, args);
    }
}