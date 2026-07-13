package com.english.learning.service;

import com.english.learning.config.FileStorageProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class FileStorageService {

    @Autowired
    private FileStorageProperties fileStorageProperties;

    public String storeAvatar(MultipartFile file, Long userId) throws IOException {
        String ext = resolveImageExtension(file);
        String filename = userId + "_" + UUID.randomUUID().toString().replace("-", "") + ext;

        Path dir = fileStorageProperties.getAvatarsPath();
        Files.createDirectories(dir);

        Path target = dir.resolve(filename).toAbsolutePath().normalize();
        try (InputStream inputStream = file.getInputStream()) {
            Files.copy(inputStream, target, StandardCopyOption.REPLACE_EXISTING);
        }

        return "/uploads/avatars/" + filename;
    }

    private String resolveImageExtension(MultipartFile file) {
        String original = file.getOriginalFilename();
        if (original != null && original.contains(".")) {
            String ext = original.substring(original.lastIndexOf('.')).toLowerCase();
            if (ext.matches("\\.(jpg|jpeg|png|gif|webp)")) {
                return ext;
            }
        }
        String contentType = file.getContentType();
        if ("image/png".equals(contentType)) {
            return ".png";
        }
        if ("image/gif".equals(contentType)) {
            return ".gif";
        }
        if ("image/webp".equals(contentType)) {
            return ".webp";
        }
        return ".jpg";
    }
}
