package com.noasking.boot.presto.autoconfigure;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Created by MaJing on 2017/12/26.
 */
@ConfigurationProperties("presto.jdbc")
public class PrestoProperties {

    private String driver = "com.facebook.presto.jdbc.PrestoDriver";
    private String username = "root";
    private String password = "root";
    private String url;

    public String getDriver() {
        return driver;
    }

    public void setDriver(String driver) {
        this.driver = driver;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
