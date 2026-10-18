# JavaEye 运维脚本

JavaEye 网站服务器上用过的一组运维脚本：17 个 Shell 脚本，外加一个 Ruby 脚本 `v.rb`。都没有命令行参数，依赖当前目录，或者依赖脚本里写死的路径、日志格式和主机。

每个脚本开头有简短的中文注释，说明它做什么、读什么、以及能从代码里看出的假设。看不准的地方注释里会直接写明，而不是猜。

这些脚本会在失败后继续往下执行（例如 `grep` 没有匹配、从库计数变量没赋上）。因此没有加 `set -euo pipefail`，避免中途退出。路径、主机和口令都没改。

会清空日志、导出数据库、发邮件或 `scp` 的脚本，只应在原来的服务器上跑。

| 脚本 | 作用 | 用法 |
| --- | --- | --- |
| [`agent.sh`](agent.sh) | 统计常见浏览器 User-Agent，按次数写入 `agent.log` | `./agent.sh`（当前目录要有 `production.log`） |
| [`agent_stat.sh`](agent_stat.sh) | 把 `agent.log` 第一列次数加总后打印 | `./agent_stat.sh`（当前目录要有 `agent.log`） |
| [`app_user.sh`](app_user.sh) | 统计含 `200 OK` 且路径匹配 `/app/sub` 或 `/app/my_act` 的第 17 列去重个数 | `./app_user.sh`（当前目录要有 `production.log`） |
| [`bot.sh`](bot.sh) | 抽出不含常见浏览器关键字的 User-Agent，按次数写入 `bot.log` | `./bot.sh`（当前目录要有 `production.log`） |
| [`bot_stat.sh`](bot_stat.sh) | 把 `bot.log` 第一列次数加总后打印 | `./bot_stat.sh`（当前目录要有 `bot.log`） |
| [`daily_log_slave.sh`](daily_log_slave.sh) | 轮转本机 `production.log`，并把副本 scp 到 `webuser@iteye`（端口 33033） | `./daily_log_slave.sh` |
| [`daily_visit_report.sh`](daily_visit_report.sh) | 汇总昨日访问和发帖等数据，生成日报并邮件发给 fankai@gmail.com | `./daily_visit_report.sh`（在 `/home/webuser/log` 读取当天 `visit-YYYYMMDD.log.gz` 和 `production.log`） |
| [`dump.sh`](dump.sh) | 用 mysqldump 导出 `javaeye3`，gzip 到带日期的文件 | `./dump.sh`（写当前目录的 `javaeye3_YYYYMMDD.sql.gz`） |
| [`ip.sh`](ip.sh) | 统计 `production.log` 里 Processing 行第 4 列的不重复个数 | `./ip.sh`（当前目录要有 `production.log`） |
| [`log.sh`](log.sh) | 轮转 Rails 日志和访问日志，压缩当天访问日志，删除 14 天前的压缩包 | `./log.sh` |
| [`log_report.sh`](log_report.sh) | 统计状态码和独立 IP，生成简短日报并邮件发给 fankai@gmail.com | `./log_report.sh`（在 `/home/webuser/log` 读取 `production.log`） |
| [`memory.sh`](memory.sh) | 抽出非零内存消耗记录，按数值从大到小取前 500 行写入 `m.log` | `./memory.sh`（当前目录要有 `production.log`） |
| [`monitor_cpu.sh`](monitor_cpu.sh) | 检查 `webuser` 下 node 进程，CPU 达到或超过 30% 时打印告警（不杀进程） | `./monitor_cpu.sh` |
| [`stat.sh`](stat.sh) | 统计含 `200 OK` 的行的第 11 列，按次数取前 500 行写入 `stat.log` | `./stat.sh`（当前目录要有 `production.log`） |
| [`stat_ip.sh`](stat_ip.sh) | 把 Processing 行第 4 列按 IPv4 /24 归并并计数，取前 200 名写入 `stat_ip.log` | `./stat_ip.sh`（当前目录要有 `production.log`） |
| [`timing.sh`](timing.sh) | 整理 `200.log` 的耗时，按总时间取前 1000 行写入 `timing.log` | `./timing.sh`（当前目录要有 `200.log`；该文件不是本仓库生成的） |
| [`visit_ip.sh`](visit_ip.sh) | 把 `visit.log` 第一列按 IPv4 /24 归并、去重后写入 `visit_ip.log` | `./visit_ip.sh`（当前目录要有 `visit.log`） |
| [`v.rb`](v.rb) | 把 Processing、User-Agent、Referer、Completed 的部分字段拼成一行，打印到标准输出 | `ruby v.rb`（当前目录要有 `production.log`） |
