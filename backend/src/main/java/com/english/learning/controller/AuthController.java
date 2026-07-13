package com.english.learning.controller;

import com.english.learning.model.Role;
import com.english.learning.model.User;
import com.english.learning.model.ERole;
import com.english.learning.payload.request.LoginRequest;
import com.english.learning.payload.request.SignupRequest;
import com.english.learning.payload.response.JwtResponse;
import com.english.learning.payload.response.MessageResponse;
import com.english.learning.security.jwt.JwtUtils;
import com.english.learning.security.services.UserDetailsImpl;
import com.english.learning.service.RoleService;
import com.english.learning.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import lombok.extern.slf4j.Slf4j;

import javax.validation.Valid;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@CrossOrigin(originPatterns = "*", maxAge = 3600)
@RestController
@RequestMapping({"/auth", "/api/auth"})
@Slf4j
public class AuthController {
    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    UserService userService;

    @Autowired
    RoleService roleService;

    @Autowired
    PasswordEncoder encoder;

    @Autowired
    JwtUtils jwtUtils;

    @PostMapping("/signin")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

            SecurityContextHolder.getContext().setAuthentication(authentication);
            String jwt = jwtUtils.generateJwtToken(authentication);

            UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
            List<String> roles = userDetails.getAuthorities().stream()
                    .map(item -> item.getAuthority())
                    .collect(Collectors.toList());

            return ResponseEntity.ok(new JwtResponse(jwt,
                                                     userDetails.getId(),
                                                     userDetails.getUsername(),
                                                     userDetails.getEmail(),
                                                     userDetails.getNickname(),
                                                     userDetails.getAvatar(),
                                                     roles));
        } catch (org.springframework.security.core.AuthenticationException e) {
            log.error("Authentication failed: {}", e.getMessage());
            return ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED)
                    .body(new MessageResponse("Error: Unauthorized - Invalid username or password"));
        }
    }

    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@Valid @RequestBody SignupRequest signUpRequest) {

        try {
            if (userService.existsByUsername(signUpRequest.getUsername())) {
                log.debug("用户名已存在: {}", signUpRequest.getUsername());
                return ResponseEntity
                        .badRequest()
                        .body(new MessageResponse("Error: Username is already taken!"));
            }

            if (userService.existsByEmail(signUpRequest.getEmail())) {
                log.debug("邮箱已存在: {}", signUpRequest.getEmail());
                return ResponseEntity
                        .badRequest()
                        .body(new MessageResponse("Error: Email is already in use!"));
            }

            log.debug("创建新用户: {}", signUpRequest.getUsername());
            User user = new User(signUpRequest.getUsername(),
                                signUpRequest.getEmail(),
                                encoder.encode(signUpRequest.getPassword()));

            if (signUpRequest.getNickname() != null && !signUpRequest.getNickname().trim().isEmpty()) {
                user.setNickname(signUpRequest.getNickname());
            } else {
                user.setNickname(signUpRequest.getUsername());
            }

            Set<String> strRoles = signUpRequest.getRoles();
            Set<Role> roles = new HashSet<>();

            if (strRoles == null) {
                try {
                    Role userRole = roleService.findByName(ERole.ROLE_USER)
                            .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                    roles.add(userRole);
                } catch (Exception e) {
                    log.error("获取默认角色失败: {}", e.getMessage(), e);
                    return ResponseEntity
                            .badRequest()
                            .body(new MessageResponse("Error: Role system is not properly initialized."));
                }
            } else {
                log.debug("指定了角色: {}", strRoles);
                try {
                    strRoles.forEach(role -> {
                        switch (role) {
                        case "admin":
                            Role adminRole = roleService.findByName(ERole.ROLE_ADMIN)
                                    .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                            roles.add(adminRole);
                            break;
                        case "mod":
                            Role modRole = roleService.findByName(ERole.ROLE_MODERATOR)
                                    .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                            roles.add(modRole);
                            break;
                        default:
                            Role userRole = roleService.findByName(ERole.ROLE_USER)
                                    .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                            roles.add(userRole);
                        }
                    });
                } catch (Exception e) {
                    log.error("获取角色失败: {}", e.getMessage(), e);
                    return ResponseEntity
                            .badRequest()
                            .body(new MessageResponse("Error: Role system is not properly initialized."));
                }
            }

            user.setRoles(roles);
            userService.save(user);
            log.debug("用户注册成功: {}", user.getUsername());

            return ResponseEntity.ok(new MessageResponse("User registered successfully!"));
        } catch (Exception e) {
            log.error("注册过程中发生错误: {}", e.getMessage(), e);
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: " + e.getMessage()));
        }
    }
}
