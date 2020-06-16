# 基于springboot+websocket的聊天室

## 1. 前后端实时交互常用技术

| 应用技术                   | **说明**                                                     | **优点**                           | 缺点                                                         |
| -------------------------- | ------------------------------------------------------------ | ---------------------------------- | ------------------------------------------------------------ |
| **轮询（polling）**        | 这应该是最常见的一种实现数据交互的方式，开发人员控制客户端以一定时间间隔中向服务器发送Ajax查询请求大，但是也因此，当服务器端内容并没有显著变化时，这种连接方式将带来很多无效的请求，造成服务器资源损耗。适合并发量小，实时性要求低的应用模型，更像是定时任务。 | 实现最为简单，配置简单，出错几率小 | 每次都是一次完整的http请求，易延迟，有效请求命中率少，并发较大时，服务器资源损耗大 |
| **长轮询（long polling）** | 长轮询是对轮询的改进，客户端通过请求连接到服务器，并保持一段时间的连接状态，直到消息更新或超时才返回Response并中止连接，可以有效减少无效请求的次数。属于Comet实现 | 有效减少无效连接，实时性较高       | 客户端和服务器端保持连接造成资源浪费，服务器端信息更新频繁时，long polling并不比polling高效，并且当数据量很大时，会造成连续的polls不断产生，性能上反而更糟糕 |
| **iframe流**               | iframe流方式是在页面中插入一个隐藏的iframe，利用其src属性在服务器和客户端之间创建一条长链接，服务器向iframe传输数据（通常是HTML，内有负责插入信息的javascript），来实时更新页面。属于Comet实现 | 实时性高，浏览器兼容度好           | 服务器与客户端之间交换的数据包档头很小，节约带宽。全双工通信，服务器可以主动传送数据给客户端。 |
| ***WebSocket** | WebSocket是HTML5提供的一种在单个 TCP 连接上进行全双工通讯的协议，目前chrome、Firefox、Opera、Safari等主流版本均支持，Internet Explorer从10开始支持。另外因为WebSocket 提供浏览器一个原生的 socket实现，所以直接解決了 Comet 架构很容易出错的问题，而在整個架构的复杂度上也比传统的实现简单得多。 | 服务器与客户端之间交换的数据包档头很小，节约带宽。全双工通信，服务器可以主动传送数据给客户端。 |旧版浏览器不支持|

##  2. 依赖

```xml
 <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-websocket</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
            <exclusions>
                <exclusion>
                    <groupId>org.junit.vintage</groupId>
                    <artifactId>junit-vintage-engine</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
            <version>1.2.70</version>
        </dependency>
</dependencies>
```

## 3. 配置模板 ##

```yaml
spring:
  thymeleaf:
    suffix: .jsp
```



## 4. 开启springboot的websocket服务器

```java
package com.example.chatroom_.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.server.standard.ServerEndpointExporter;

@Configuration
public class WebSocketConfig {
    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        return new ServerEndpointExporter();
    }
}
```

## 5.创建显示模板的控制器

```java
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
```

## 6.创建Websocket代码 ##

| 注解            | 备注                              |
| --------------- | --------------------------------- |
| @ServerEndpoint | websocket服务的挂载点(从哪里访问) |
| @OnOpen         | 当客户端连接weisocket服务器时     |
| @OnClose        | 当客户端断开weisocket服务器时     |
|@OnMessage|当接收到客户端消息的时候(必须需要一个参数来接收通常是String)|
|@OnError| 当websocket服务器出错时(必须需要一个参数来接收throwable类型来获取异常) |


```java
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
    public void start(Session session, @PathParam("nickname") String nickname, @PathParam("avatar") String avatar) {
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
    public void end() {

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

    @OnMessage
    public void incoming(String message) {

        JSONObject jsonObject = JSONObject.parseObject(message);
        jsonObject.put("type", 2);
        // 发送消息
        broadcast(jsonObject.toJSONString());
    }
        @OnError
    public void onError(Throwable t) throws Throwable
    {
        System.out.println("WebSocket 服务端错误" + t);
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

                String message = String.format("[%s %s]", client.user.getNickname(), "已经被断开了连接");
                broadcast(message);
            }
        }
    }
}
```

## 7. 前端核心代码 ##

| 方法      | 备注                 |
| --------- | -------------------- |
| onopen    | 连接时自动触发       |
| onmessage | 获取服务器信息时触发 |
| onclose   | 断开时触发           |
| onerror   | 出错时触发           |
| send      | 用于发送消息         |



```js
 let ws = new WebSocket("ws://localhost:8080/message/" + $('#nickname').val() + "/" + $('#avatar').val()); //实例化一个WebSocket对象
    ws.onmessage = function (message) {
        let parse = JSON.parse(message.data);
        if (parse.type === 1) {
            let count = 0;
            $('.userlist ul').empty();

            $('.chat_info').html($('.chat_info').html() + `<li class="systeminfo"><span>【${parse.nickname}】加入了房间</span></li>`);
            parse.user_list.forEach(v => {
                let html = `<li><img src="images/user/${v.avatar}.png" alt="portrait_1"><b>${v.nickname}</b></li>`
                $('.userlist ul').append(html);
                count++;
            });
            $('#count').text(count);
        } else if (parse.type === 2) {
            if (parse.username === $("#nickname").val()) {
                $('.main .chat_info').html($('.main .chat_info').html() + '<li class="right"><img src="images/user/' + parse.avatar + '.png" alt=""><b>' + parse.username + '</b><i>' + parse.datetime + '</i><div class="aaa">' + parse.message + '</div></li>');
            } else {
                $('.main .chat_info').html($('.main .chat_info').html() + '<li class="left"><img src="images/user/' + parse.avatar + '.png" alt=""><b>' + parse.username + '</b><i>' + parse.datetime + '</i><div class="aaa">' + parse.message + '</div></li>');
            }

        } else if (parse.type === 3) {
            let count = 0;
            $('.chat_info').html($('.chat_info').html() + `<li class="systeminfo"><span>【${parse.nickname}】离开了房间</span></li>`);
            $('.userlist ul').empty();
            parse.user_list.forEach(v => {
                let html = `<li><img src="images/user/${v.avatar}.png" alt="portrait_1"><b>${v.nickname}</b></li>`
                $('.userlist ul').append(html);
                count++;
            });
            $('#count').text(count);
        }
    }
```

## 8.附录 ##

[github](https://github.com/wsy998/jsp)
[gitee](https://gitee.com/qq489402539/jsp)
![图片2](http://qq489402539.gitee.io/shop/图片2.jpg)





