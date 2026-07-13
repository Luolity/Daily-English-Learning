package com.english.learning.service;

import com.english.learning.model.Role;
import com.english.learning.model.ERole;

import java.util.Optional;

public interface RoleService {
    Optional<Role> findByName(ERole name);
    
    Role save(Role role);
} 