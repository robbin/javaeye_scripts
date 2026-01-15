#!/bin/bash

export LC_CTYPE=en_US.UTF-8

today=`date +%Y-%m-%d`
#yesterday=`date -v-2d +%Y-%m-%d`
yesterday=`date -d "-1 day" +%Y-%m-%d`

cd /home/webuser/log
timestamp=`date +%Y%m%d`

gunzip -c visit-$timestamp.log.gz > visit.log

# stat rails log
grep Completed production.log > all.log
request_all=`cat all.log | wc -l`
request_200=`grep -c "200 OK" all.log`
request_301=`grep -c "301 Moved Permanently" all.log`
request_302=`grep -c "302 Found" all.log`
request_304=`grep -c "304 Not Modified" all.log`
request_401=`grep -c "401 Unauthorized" all.log`
request_403=`grep -c "403 Forbidden" all.log`
request_404=`grep -c "404 Not Found" all.log`
request_500=`grep -c "500 Internal Server Error" production.log`
request_rss=`grep -c "/rss" all.log`
request_api=`grep -c "http://api.iteye.com" all.log`
cat production.log > production_all.log

# stat rails log on salve server
if [ -s production_slave.log ]; then
  grep Completed production_slave.log > all.log
  request_all_s=`cat all.log | wc -l`
  request_200_s=`grep -c "200 OK" all.log`
  request_301_s=`grep -c "301 Moved Permanently" all.log`
  request_302_s=`grep -c "302 Found" all.log`
  request_304_s=`grep -c "304 Not Modified" all.log`
  request_401_s=`grep -c "401 Unauthorized" all.log`
  request_403_s=`grep -c "403 Forbidden" all.log`
  request_404_s=`grep -c "404 Not Found" all.log`
  request_500_s=`grep -c "500 Internal Server Error" production_slave.log`
  request_rss_s=`grep -c "/rss" all.log`
  request_api_s=`grep -c "http://api.iteye.com" all.log`
  cat production_slave.log >> production_all.log
fi
request_ip=`grep Processing production_all.log |awk '{print $4}'| sort | uniq  | wc -l`
rm all.log

# stat real user visit
uniq_ip=`awk '{print $1}' visit.log | sort | uniq  | wc -l`
login_user=`grep "LOGIN_USER" visit.log | awk '{print $1}' | sort | uniq  | wc -l`
login_user_pv=`grep "LOGIN_USER" visit.log | wc -l`
anonymous_user=`grep "ANONYMOUS_USER" visit.log | awk '{print $1}' | sort | uniq  | wc -l`
anonymous_user_pv=`grep "ANONYMOUS_USER" visit.log | wc -l`

awk '{print $4}' visit.log | grep -v '^$' | grep -v '^file:\/\/' > url.log
grep 'http://www.iteye.com' url.log | grep -v 'http://www.iteye.com/api' > main.log
grep "http://my.iteye.com" url.log > app.log
grep -v -E 'http://(www|my|api).iteye.com' url.log | grep -v 'http://.*.group.iteye.com' > blog.log
grep -E 'http://.*.group.iteye.com' url.log > group.log
awk '{print $5}' visit.log | grep -v '^$' | grep -v '^NO_REFERER$' > referer.log

all=`cat url.log | wc -l`
main=`cat main.log | wc -l`

homepage=`grep -c -v 'http://www.iteye.com/[a-zA-Z\?]' main.log`
news=`grep -c 'http://www.iteye.com/news' main.log`
magazine=`grep -c 'http://www.iteye.com/magazines' main.log`
forum=`grep -c -E 'http://www.iteye.com/(forums|topic|post)' main.log`
ask=`grep -c -E 'http://www.iteye.com/(ask|problem)' main.log`
wblog=`grep -c 'http://www.iteye.com/wiki/blog' main.log`
wtopic=`grep -c 'http://www.iteye.com/wiki/topic' main.log`
wproblem=`grep -c 'http://www.iteye.com/wiki/problem' main.log`
blogs=`grep -c 'http://www.iteye.com/blogs' main.log`
groups=`grep -c 'http://www.iteye.com/groups' main.log`
jobs=`grep -c -E 'http://www.iteye.com/(job|companies)' main.log`
search=`grep -c -E '/search|/google_search' main.log`
login=`grep -c -E '/login|/signup|/users' url.log`

group=`cat group.log | wc -l`
group_forum=`grep -c "/group/forum" group.log`
group_wiki=`grep -c "/group/wiki" group.log`
group_events=`grep -c "/group/events" group.log`
group_share=`grep -c "/group/share" group.log`
group_news=`grep -c "/group/news" group.log`
group_blogs=`grep -c "/group/blogs" group.log`
group_bbs=`grep -c "/group/bbs" group.log`
group_ask=`grep -c "/group/ask" group.log`

app=`cat app.log | wc -l`
app_feed=`grep -c "/feed" app.log`
app_chat=`grep -c "/chat" app.log`
app_notifications=`grep -c "/notifications" app.log`
app_messages=`grep -c "/messages" app.log`
app_groups=`grep -c "/mygroup" app.log`
app_resume=`grep -c "/myresume" app.log`

app_album=`grep -c "/admin/album" app.log`
app_link=`grep -c "/admin/link" app.log`
app_code=`grep -c "/admin/code" app.log`
app_weibo=`grep -c "/admin/weibo" app.log`

blog=`cat blog.log | wc -l`
blog_main=`grep -c -v 'iteye.com/[0-9a-zA-Z]' blog.log`
blog_category=`grep -c 'iteye.com/category' blog.log`
blog_subject=`grep -c 'iteye.com/blogs/subjects' main.log`
blog_visit=`grep -c 'iteye.com/blog/user_visits' blog.log`
blog_article=`grep -c '/blog/[0-9]' blog.log`
blog_profile=`grep -c "/blog/profile" blog.log`
blog_guest_book=`grep -c "/blog/guest_book" blog.log`
blog_picture=`grep -c -E "/picture|/album" blog.log`
blog_login=`grep -c -E "iteye.com/(login|signup|index)" blog.log`
blog_forum=`grep -c -E "/blog/(forum|article|news|solution|topic|post)" blog.log`
link_favorite=`grep -c "/link" blog.log`
code_favorite=`grep -c "/code" blog.log`
blog_weibo=`grep -c "/weibo" blog.log`

blog_admin=`grep -c "/admin" blog.log`
blog_admin_user=`grep "/admin" blog.log | awk 'sub(/http:\/\//,"",$1) sub(/\.(.*)/,"",$1) {print $1}' | sort | uniq | wc -l`

referer=`cat referer.log | wc -l`
iteye_referer=`grep -c iteye.com/ referer.log`
google_referer=`grep -c -E "^http(s?)://(\w+).google.com" referer.log`
baidu_referer=`grep -c baidu.com/ referer.log`
no_referer=`expr $all - $referer`
other_referer=`expr $referer - $iteye_referer - $google_referer - $baidu_referer`

MYSQL_COMM="/usr/bin/mysql -u javaeye -peyeavaj -h database javaeye3 -e"
register_user=`$MYSQL_COMM "select count(*) as u from users\G" | grep "u:" | awk '{print $2}'`
online_user=`$MYSQL_COMM "select count(*) as u from user_sessions\G" | grep "u:"|awk '{print $2}'`
new_users=`$MYSQL_COMM "select count(*) as u from users u1 LEFT JOIN auths a1 ON u1.id = a1.user_id WHERE u1.created_at > '$yesterday' AND u1.created_at < '$today' AND u1.id IS NOT NULL AND a1.id IS NULL\G" | grep "u:" | awk '{print $2}'`
new_news=`$MYSQL_COMM "select count(*) as u from news where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_news_comments=`$MYSQL_COMM "select count(*) as u from news_comments where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_essences=`$MYSQL_COMM "select count(*) as u from essences where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_essence_comments=`$MYSQL_COMM "select count(*) as u from essence_comments where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_topics=`$MYSQL_COMM "select count(*) as u from new_topics where forum_id IS NOT NULL AND created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_posts=`$MYSQL_COMM "select count(*) as u from new_posts where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_blogs=`$MYSQL_COMM "select count(*) as u from blogs where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_digg_blogs=`$MYSQL_COMM "select count(*) as u from blogs where diggable = 1 AND created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_digg_nocomment_blogs=`$MYSQL_COMM "select count(*) as u from blogs where diggable = 1 AND comments_count = 0 AND created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_blog_comments=`$MYSQL_COMM "select count(*) as u from blog_comments where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_digg_blog_comments=`$MYSQL_COMM "select count(*) as u from blog_comments inner join blogs on blog_comments.blog_id = blogs.id where blogs.diggable = 1 AND blogs.created_at > '$yesterday' AND blogs.created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_problems=`$MYSQL_COMM "select count(*) as u from problems where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_problem_votes=`$MYSQL_COMM "select count(*) as u from user_ask_votes where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_problem_comments=`$MYSQL_COMM "select count(*) as u from problem_comments where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_solutions=`$MYSQL_COMM "select count(*) as u from solutions where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_solution_votes=`$MYSQL_COMM "select count(*) as u from user_solution_votes where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_solution_comments=`$MYSQL_COMM "select count(*) as u from solution_comments where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_user_favorites=`$MYSQL_COMM "select count(*) as u from user_favorites where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_user_code=`$MYSQL_COMM "select count(*) as u from code_favorites where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_group_topics=`$MYSQL_COMM "select count(*) as u from group_topics where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_group_posts=`$MYSQL_COMM "select count(*) as u from group_posts where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_pictures=`$MYSQL_COMM "select count(*) as u from pictures where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_subscriptions=`$MYSQL_COMM "select count(*) as u from subscriptions where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_twitters=`$MYSQL_COMM "select count(*) as u from twitters where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_messages=`$MYSQL_COMM "select count(*) as u from messages where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_activities=`$MYSQL_COMM "select count(*) as u from activities where created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
new_csdn_bind=`$MYSQL_COMM "select count(*) as u from auths where provider = 'csdn' AND created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
sum_csdn_bind=`$MYSQL_COMM "select count(*) as u from auths where provider = 'csdn'\G" | grep "u:" | awk '{print $2}'`
new_weibo_bind=`$MYSQL_COMM "select count(*) as u from auths where provider = 'weibo' AND created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
sum_weibo_bind=`$MYSQL_COMM "select count(*) as u from auths where provider = 'weibo'\G" | grep "u:" | awk '{print $2}'`
new_qq_bind=`$MYSQL_COMM "select count(*) as u from auths where provider = 'qzone' AND created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
sum_qq_bind=`$MYSQL_COMM "select count(*) as u from auths where provider = 'qzone'\G" | grep "u:" | awk '{print $2}'`
new_tqq_bind=`$MYSQL_COMM "select count(*) as u from auths where provider = 'tqq' AND created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
sum_tqq_bind=`$MYSQL_COMM "select count(*) as u from auths where provider = 'tqq'\G" | grep "u:" | awk '{print $2}'`
new_google_bind=`$MYSQL_COMM "select count(*) as u from auths where provider = 'google' AND created_at > '$yesterday' AND created_at < '$today'\G" | grep "u:" | awk '{print $2}'`
sum_google_bind=`$MYSQL_COMM "select count(*) as u from auths where provider = 'google'\G" | grep "u:" | awk '{print $2}'`

cat > daily_visit_report.log << EOF

根据ITeye流量统计系统报告 - $yesterday

独立IP      : $uniq_ip
登录用户IP  : $login_user   (`expr $login_user \* 100 / $uniq_ip`%)
匿名用户IP  : $anonymous_user  (`expr $anonymous_user \* 100 / $uniq_ip`%)

网站全部PV  : $all
登录用户PV  : $login_user_pv  (`expr $login_user_pv \* 100 / $all`%)
匿名用户PV  : $anonymous_user_pv (`expr $anonymous_user_pv \* 100 / $all`%)

----------------------------------
主域名      : $main (`expr $main \* 100 / $all`%)
  网站首页  : $homepage (`expr $homepage \* 100 / $all`%)
  新闻频道  : $news (`expr $news \* 100 / $all`%)
  精华频道  : $magazine (`expr $magazine \* 100 / $all`%)
  论坛频道  : $forum (`expr $forum \* 100 / $all`%)
  问答频道  : $ask (`expr $ask \* 100 / $all`%)
    相关博客: $wblog (`expr $wblog \* 100 / $all`%)
    相关文章: $wtopic (`expr $wtopic \* 100 / $all`%)
    相关问答: $wproblem (`expr $wproblem \* 100 / $all`%)
  博客频道  : $blogs
  群组频道  : $groups
  招聘频道  : $jobs (`expr $jobs \* 100 / $all`%)
  站内搜索  : $search (`expr $search \* 100 / $all`%)
  用户登录  : $login (`expr $login \* 100 / $all`%)

博客        : $blog (`expr $blog \* 100 / $all`%)
  博客首页  : $blog_main (`expr $blog_main \* 100 / $all`%)
  博客文章  : $blog_article (`expr $blog_article \* 100 / $all`%)
  博客专栏  : $blog_subject
  博客分类  : $blog_category
  博客资料  : $blog_profile
  博客留言板: $blog_guest_book
  博客访客  : $blog_visit
  博客相册  : $blog_picture
  文章收藏  : $link_favorite
  代码收藏  : $code_favorite
  博客帖子  : $blog_forum
  博客登录  : $blog_login
  博客微博  : $blog_weibo
  博客后台  : $blog_admin (`expr $blog_admin \* 100 / $all`%)
  博客用户  : $blog_admin_user 人

群组        : $group (`expr $group \* 100 / $all`%)
  讨论      : $group_forum
  专栏      : $group_wiki
  活动      : $group_events
  下载      : $group_share
  资讯      : $group_news
  博客      : $group_blogs
  论坛      : $group_bbs
  问答      : $group_ask

我的应用    : $app   (`expr $app \* 100 / $all`%)
  我的订阅  : $app_feed
  我的闲聊  : $app_chat
  我的提醒  : $app_notifications
  我的短信  : $app_messages
  我的群组  : $app_groups
  我的简历  : $app_resume
  我的相册  : $app_album
  我的收藏  : $app_link
  我的代码  : $app_code
  我的微博  : $app_weibo

注册会员     : $register_user
今天登录会员 : $online_user
今天注册会员 : $new_users
今天绑定CSDN会员: $new_csdn_bind (总计：$sum_csdn_bind)
今天绑定Google会员: $new_google_bind (总计：$sum_google_bind)
今天绑定weibo会员: $new_weibo_bind (总计：$sum_weibo_bind)
今天绑定QQ会员: $new_qq_bind (总计：$sum_qq_bind)
今天绑定腾讯微博会员: $new_tqq_bind (总计：$sum_tqq_bind)
新发布新闻   : $new_news
新的新闻评论 : $new_news_comments
新发布精华   : $new_essences
新的精华评论 : $new_essence_comments
新的论坛主题贴: $new_topics
新的所有回帖 : $new_posts
新的博客文章 : $new_blogs
新的首页博客文章 : $new_digg_blogs
新的首页无回复博客文章 : $new_digg_nocomment_blogs
新的博客回复 : $new_blog_comments
新的首页博客回复 : $new_digg_blog_comments
新的提问     : $new_problems
  新的提问投票 : $new_problem_votes
  新的提问评论 : $new_problem_comments
新的回答     : $new_solutions
  新的回答投票 : $new_solution_votes
  新的回答评论 : $new_solution_comments
新的收藏     : $new_user_favorites
新的代码     : $new_user_code
新的群组主题帖: $new_group_topics
新的群组回帖 : $new_group_posts
新的博客图片 : $new_pictures
新的订阅关系 : $new_subscriptions
新的闲聊     : $new_twitters
新的站内短信 : $new_messages
新的全站动态 : $new_activities

Referer     : $referer
ITeye.com : $iteye_referer  (`expr $iteye_referer \* 100 / $all`%)
Google      : $google_referer (`expr $google_referer \* 100 / $all`%)
Baidu       : $baidu_referer  (`expr $baidu_referer \* 100 / $all`%)
直接访问    : $no_referer  (`expr $no_referer \* 100 / $all`%)
其它来源    : $other_referer  (`expr $other_referer \* 100 / $all`%)

所有IP       : $request_ip
所有请求     : $request_all + $request_all_s = `expr $request_all + $request_all_s`
API请求      : $request_api + $request_api_s = `expr $request_api + $request_api_s`
RSS请求      : $request_rss + $request_rss_s = `expr $request_rss + $request_rss_s`
200正常访问  : $request_200 + $request_200_s = `expr $request_200 + $request_200_s`
301永久转向  : $request_301 + $request_301_s = `expr $request_301 + $request_301_s`
302临时转向  : $request_302 + $request_302_s = `expr $request_302 + $request_302_s`
304未改变    : $request_304 + $request_304_s = `expr $request_304 + $request_304_s`
401待验证    : $request_401 + $request_401_s = `expr $request_401 + $request_401_s`
403禁止访问  : $request_403 + $request_403_s = `expr $request_403 + $request_403_s`
404找不到    : $request_404 + $request_404_s = `expr $request_404 + $request_404_s`
500程序出错  : $request_500 + $request_500_s = `expr $request_500 + $request_500_s`

EOF
mail -s "daily log report" "fankai@gmail.com" < daily_visit_report.log
exit 0
