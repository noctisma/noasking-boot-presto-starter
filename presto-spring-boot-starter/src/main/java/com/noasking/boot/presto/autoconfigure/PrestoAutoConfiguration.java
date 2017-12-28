package com.noasking.boot.presto.autoconfigure;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Created by MaJing on 2017/12/26.
 */
@Configuration
@EnableConfigurationProperties(PrestoProperties.class)
public class PrestoAutoConfiguration {

    private static final Logger logger = LoggerFactory.getLogger(PrestoAutoConfiguration.class);

    @Autowired
    private PrestoProperties prestoProperties;

    @Bean
    PrestoJdbcUtils connectionFactory() {
        if (logger.isDebugEnabled()) {
            logger.debug("presto properties:{driver:" + prestoProperties.getDriver() + ",username:" +
                    prestoProperties.getUsername() + ",password:" +
                    prestoProperties.getPassword() + ",url:" + prestoProperties.getDriver() + "}");
        }
        return new PrestoJdbcUtils(prestoProperties.getDriver(), prestoProperties.getUsername(), prestoProperties
                .getPassword(), prestoProperties.getUrl());
    }

}
