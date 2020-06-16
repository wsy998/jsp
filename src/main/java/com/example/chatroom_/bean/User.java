package com.example.chatroom_.bean;

public class User {
    private String nickname;
    private String avatar;

    public User() {
    }

    @Override
    public String toString() {
        return "User{" +
                "nickname='" + nickname + '\'' +
                ", avatar='" + avatar + '\'' +
                '}';
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public User(String nickname, String avatar) {
        this.nickname = nickname;
        this.avatar = avatar;
    }
}
