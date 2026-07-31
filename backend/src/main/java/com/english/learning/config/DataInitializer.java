package com.english.learning.config;

import com.english.learning.mapper.RoleMapper;
import com.english.learning.mapper.UserRoleMapper;
import com.english.learning.model.ERole;
import com.english.learning.model.Role;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.Comparator;
import java.util.List;

@Component
@Slf4j
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private RoleMapper roleMapper;

    @Autowired
    private UserRoleMapper userRoleMapper;

    @Override
    public void run(String... args) {
        deduplicateRoles();
        initRoles();
        log.info("数据初始化完成!");
    }

    private void initRoles() {
        for (ERole roleName : ERole.values()) {
            if (roleMapper.findFirstByName(roleName.getValue()) == null) {
                roleMapper.insert(new Role(roleName));
                log.info("已初始化角色: {}", roleName);
            }
        }
    }

    private void deduplicateRoles() {
        for (ERole roleName : ERole.values()) {
            List<Role> duplicates = roleMapper.findAllByName(roleName.getValue());
            if (duplicates.size() <= 1) {
                continue;
            }

            duplicates.sort(Comparator.comparing(Role::getId));
            Role canonical = duplicates.get(0);
            for (int i = 1; i < duplicates.size(); i++) {
                Role duplicate = duplicates.get(i);
                userRoleMapper.remapRoleId(duplicate.getId(), canonical.getId());
                userRoleMapper.deleteByRoleId(duplicate.getId());
                roleMapper.deleteById(duplicate.getId());
                log.info("已合并重复角色 {}: 删除 id={}, 保留 id={}", roleName, duplicate.getId(), canonical.getId());
            }
        }
    }
}
