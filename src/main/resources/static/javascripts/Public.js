/* 
* @Author: sublime text
* @Date:   2015-09-30 13:10:12
* @Last Modified by:   sublime text
* @Last Modified time: 2015-10-02 09:11:29
*/

$(() => {
// -------------------------登录页面---------------------------------------------------
    $('#login_form').on('submit', () => {
        let userName = $('#nickname'); // 用户昵称
        $('#avatar').val($('.login img').attr('portrait_id')); // 用户头像id
        if (userName.val() === '') { // 如果不填昵称就给 "User" + ID
            userName.val('User' + Math.floor(Math.random() * 10000000));
        }
    });
// --------------------聊天室内页面----------------------------------------------------
    // 发送图片
    $('.imgFileBtn').on('change', function () {
        const str = '<img src="images/chatimg/' + '1/201503/agafsdfeaef.jpg' + '" />';
        sends_message($(""), 1, str); // sends_message(昵称,头像id,聊天内容);
        // 滚动条滚到最下面
        let $_v = $('.scrollbar-macosx.scroll-content.scroll-scrolly_visible');
        $_v.animate({
            scrollTop: $_v.prop('scrollHeight')
        }, 500);
    });

    // 发送消息
    let input = $('.text input').keypress(e => {
        if (e.which === 13) $('#subxx').trigger('click');
    });

    input.focus();
    $('#subxx').on('click', function () {
        let str = input.val(); // 获取聊天内容
        str = str.replace(/\</g, '&lt;');
        str = str.replace(/\>/g, '&gt;');
        str = str.replace(/\n/g, '<br/>');
        str = str.replace(/\[em_([0-9]*)\]/g, '<img src="images/face/$1.gif" alt="" />');
        if (str !== '') {
            sends_message($('#nickname').val(), $('#avatar').val(), str); // sends_message(昵称,头像id,聊天内容);
            let $_v = $('.scrollbar-macosx.scroll-content.scroll-scrolly_visible');
            // 滚动条滚到最下面
            $_v.animate({
                scrollTop: $_v.prop('scrollHeight')
            }, 500);
        }
        input.val(''); // 清空输入框
        input.focus(); // 输入框获取焦点
    });


// -----下边的代码不用管---------------------------------------

    let ws = new WebSocket("ws://localhost:8080/message/" + $('#nickname').val() + "/" + $('#avatar').val());
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

    jQuery('.scrollbar-macosx').scrollbar();
    $('.topnavlist li a').on('click', function () {
        $('.topnavlist .popover').not($(this).next('.popover')).removeClass('show');
        $(this).next('.popover').toggleClass('show');
        if ($(this).next('.popover').attr('class') !== 'popover fade bottom in') {
            $('.clapboard').removeClass('hidden');
        } else {
            $('.clapboard').click();
        }
    });
    $('.clapboard').on('click', function () {
        $('.topnavlist .popover').removeClass('show');
        $(this).addClass('hidden');
        let $_ = $('.user_portrait img');

        $_.attr('portrait_id', $_.attr('ptimg'));
        $_.attr('src', 'images/user/' + $_.attr('ptimg') + '.png');
        $_.removeClass('t');
        $_.eq($_.attr('ptimg') - 1).addClass('t');
        $('.rooms .user_name input').val('');
    });
    $('.select_portrait img').hover(function () {
        const portrait_id = $(this).attr('portrait_id');
        $('.user_portrait img').attr('src', 'images/user/' + portrait_id + '.png');
    }, () => {
        let img = $('.user_portrait img');
        const t_id = img.attr('portrait_id');
        img.attr('src', 'images/user/' + t_id + '.png');
    }).on('click', function () {
        const portrait_id = $(this).attr('portrait_id');
        $('.user_portrait img').attr('portrait_id', portrait_id);
        $('.select_portrait img').removeClass('t');
        $(this).addClass('t');
    });
    $('.face_btn,.faces').hover(function () {
        $('.faces').addClass('show');
    }, function () {
        $('.faces').removeClass('show');
    });
    $('.faces img').on('click', function () {
        let input = $('.text input');
        if ($(this).attr('alt') !== '') {
            input.val(input.val() + '[em_' + $(this).attr('alt') + ']');
        }
        $('.faces').removeClass('show');
        input.focus();
    });

    function sends_message(userName, userPortrait, message) {
        if (message !== '') {

            let date = new Date();
            let hours = date.getHours();
            let minutes = date.getMinutes();
            ws.send(JSON.stringify({
                avatar: userPortrait,
                username: userName,
                message: message,
                datetime: `${hours}:${minutes}`
            }));
        }
    }


});
