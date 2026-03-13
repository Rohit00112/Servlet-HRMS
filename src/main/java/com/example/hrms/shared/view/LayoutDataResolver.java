package com.example.hrms.shared.view;

import com.example.hrms.model.User;

public interface LayoutDataResolver {
    LayoutViewData resolve(User user);
}
