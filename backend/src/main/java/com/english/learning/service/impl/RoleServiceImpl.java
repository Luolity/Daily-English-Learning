package com.english.learning.service.impl;

import com.english.learning.mapper.RoleMapper;
import com.english.learning.model.ERole;
import com.english.learning.model.Role;
import com.english.learning.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    private RoleMapper roleMapper;

    @Override
    public Optional<Role> findByName(ERole name) {
        return Optional.ofNullable(roleMapper.findFirstByName(name.getValue()));
    }

    @Override
    @Transactional
    public Role save(Role role) {
        roleMapper.insert(role);
        return role;
    }
} 