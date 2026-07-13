package com.english.learning.security.services;

import com.english.learning.model.User;
import com.english.learning.model.Role;
import com.english.learning.mapper.UserMapper;
import com.english.learning.mapper.UserRoleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    @Autowired
    UserMapper userMapper;
    
    @Autowired
    UserRoleMapper userRoleMapper;

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userMapper.findByUsername(username);
        if (user == null) {
            throw new UsernameNotFoundException("User Not Found with username: " + username);
        }

        // 获取用户角色
        List<Role> roles = userRoleMapper.findRolesByUserId(user.getId());
        Set<Role> roleSet = new HashSet<>(roles);
        user.setRoles(roleSet);

        return UserDetailsImpl.build(user);
    }
} 