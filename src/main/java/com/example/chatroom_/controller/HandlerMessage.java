package com.example.chatroom_.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.example.chatroom_.bean.User;
import org.springframework.stereotype.Component;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.atomic.AtomicInteger;

@ServerEndpoint("/message/{nickname}/{avatar}")
@Component
public class HandlerMessage {
    private static final AtomicInteger connectionIds = new AtomicInteger(0);
    private static final Set<HandlerMessage> clientSet = new CopyOnWriteArraySet<>();
    private User user;
    private Session session;

    public HandlerMessage() {
    }

    @OnOpen
    public void onopen(Session session, @PathParam("nickname") String nickname, @PathParam("avatar") String avatar) {
        this.session = session;
        user = new User(nickname, avatar);
        connectionIds.getAndIncrement();
        // 将 WebSocket 客户端会话添加到集合中
        clientSet.add(this);
        JSONArray jsonArray = new JSONArray();
        for (HandlerMessage next : clientSet) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("nickname", next.user.getNickname());
            jsonObject.put("avatar", next.user.getAvatar());
            jsonArray.add(jsonObject);
        }
//        1.消息类型
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("type", 1);
        jsonObject.put("nickname", user.getNickname());
        jsonObject.put("avatar", user.getAvatar());
        jsonObject.put("user_list", jsonArray);
        // 发送消息
        broadcast(jsonObject.toJSONString());
    }

    @OnClose
    public void onclose() {

        clientSet.remove(this);
        JSONArray jsonArray = new JSONArray();
        for (HandlerMessage next : clientSet) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("nickname", next.user.getNickname());
            jsonObject.put("avatar", next.user.getAvatar());
            jsonArray.add(jsonObject);
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("type", 3);
        jsonObject.put("nickname", user.getNickname());
        jsonObject.put("user_list", jsonArray);
        // 发送消息
        broadcast(jsonObject.toJSONString());
    }

    public void onError(Throwable t) throws Throwable
    {
        System.out.println("WebSocket 服务端错误" + t);
    }

    @OnMessage
    public void onmessage(String message) {
//        JSONObject jsonObject = JSONObject.parseObject(message);
        JSONObject jsonObject = JSONObject.parseObject(message);
        jsonObject.put("type", 2);
        // 发送消息
        broadcast(jsonObject.toJSONString());
    }


    // 实现广播消息的工具方法
    private static void broadcast(String msg) {
        // 遍历服务器关联的所有客户端
        for (HandlerMessage client : clientSet) {
            try {
                synchronized (client) {
                    // 发送消息
                    client.session.getBasicRemote().sendText(msg);
                }
            } catch (IOException e) {
                System.out.println("聊天错误，向客户端" + client + "发送消息出现错误。");
                clientSet.remove(client);
                try {
                    client.session.close();
                } catch (IOException ignored) {
                }
            }
        }
    }



}
