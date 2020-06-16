package com.example.chatroom_.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class LoginController {
    @GetMapping("/login")
    public String showLogin() {
        return "login";
    }

    @GetMapping("/room")
    public ModelAndView showRoom(String nickname, String avatar) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("room");
        modelAndView.addObject("nickname", nickname);
        modelAndView.addObject("avatar", avatar);
        return modelAndView;
    }
}
