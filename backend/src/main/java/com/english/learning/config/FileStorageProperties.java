package com.english.learning.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.nio.file.Path;
import java.nio.file.Paths;

@Component
@ConfigurationProperties(prefix = "app.upload")
public class FileStorageProperties {

    /**
     * 上传根目录，使用绝对路径，避免 Tomcat 工作目录导致写入失败
     */
    private String baseDir = Paths.get(System.getProperty("user.dir"), "uploads").toAbsolutePath().toString();

    public String getBaseDir() {
        return baseDir;
    }

    public void setBaseDir(String baseDir) {
        this.baseDir = baseDir;
    }

    public Path getBasePath() {
        return Paths.get(baseDir).toAbsolutePath().normalize();
    }

    public Path getAvatarsPath() {
        return getBasePath().resolve("avatars");
    }
}
