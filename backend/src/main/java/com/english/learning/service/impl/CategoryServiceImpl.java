package com.english.learning.service.impl;

import com.english.learning.mapper.CategoryMapper;
import com.english.learning.model.Category;
import com.english.learning.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    private CategoryMapper categoryMapper;

    @Override
    public List<Category> getAllCategories() {
        return categoryMapper.selectList(null);
    }

    @Override
    public Optional<Category> getCategoryById(Long id) {
        return Optional.ofNullable(categoryMapper.selectById(id));
    }

    @Override
    public Optional<Category> getCategoryByName(String name) {
        return Optional.ofNullable(categoryMapper.findByName(name));
    }

    @Override
    @Transactional
    public Category createCategory(Category category) {
        if (categoryMapper.existsByName(category.getName())) {
            throw new IllegalArgumentException("Category already exists with name: " + category.getName());
        }
        categoryMapper.insert(category);
        return category;
    }

    @Override
    @Transactional
    public Category updateCategory(Long id, Category category) {
        Category existingCategory = categoryMapper.selectById(id);
        if (existingCategory == null) {
            throw new IllegalArgumentException("Category not found with id: " + id);
        }
        
        // 检查名称是否已存在（如果名称发生了更改）
        if (!existingCategory.getName().equals(category.getName()) && 
                categoryMapper.existsByName(category.getName())) {
            throw new IllegalArgumentException("Category already exists with name: " + category.getName());
        }
        
        existingCategory.setName(category.getName());
        existingCategory.setDescription(category.getDescription());
        
        categoryMapper.updateById(existingCategory);
        return existingCategory;
    }

    @Override
    @Transactional
    public void deleteCategory(Long id) {
        if (categoryMapper.selectById(id) == null) {
            throw new IllegalArgumentException("Category not found with id: " + id);
        }
        categoryMapper.deleteById(id);
    }

    @Override
    public boolean existsByName(String name) {
        return categoryMapper.existsByName(name);
    }
} 