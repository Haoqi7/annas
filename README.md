# 安娜的档案

这是主持annas-archive.org的代码，是书籍、论文、漫画、杂志等的搜索引擎。

## 本地运行

在一个终端窗口中，运行。

```bash
cp .env.dev .env
docker-compose up --build
```

现在打开http://localhost:8000。它应该给你一个错误，因为MySQL还没有被初始化。在另一个终端窗口，运行。

```bash
./run flask cli dbreset
```

现在重新启动上面的 "docker-compose up"，事情应该就可以了。

常见的问题。
* ElasticSearch数据的古怪权限。`sudo chmod 0777 -R .../allthethings-elastic-data/`。
* MariaDB想要太多的内存：在`mariadb-conf/my.cnf`中注释掉`key_buffer_size`。
* 请注意，这个例子的数据非常古怪，因为当只输出少量的记录时，一些连接的表没有很好地排成一列。
* 你可能需要调整ElasticSearch的堆大小，通过改变`docker-compose.yml`中的`ES_JAVA_OPTS`。

TODO:
* [导入实际数据](https://annas-software.org/AnnaArchivist/annas-archive/-/issues/4)

注意事项。
* 这个 repo 是基于 [docker-flask-example](https://github.com/nickjj/docker-flask-example)。

## 架构

大致上是这样的结构。
* 1个以上的网络服务器
* 在网络服务器前有大量的缓存（如Cloudflare）。
* 1个以上只读的MariaDB数据库，有MyISAM数据表（"mariadb"）。
* 1个读/写的MariaDB db，用于持久性数据（"mariapersist"）。

实际上，你也希望在网络服务器前面有代理服务器，这样你就可以控制谁收到DMCA通知。

## 导入所有数据

参见 [data-imports/README.md](data-imports/README.md)。

## 翻译

这些是正在进行的工作。目前，我们在.po _和.mo文件中检查。这个过程如下。
```sh
# 在更新了任何 "gettext "调用之后。
pybabel extract --omit-header -F babel.cfg -o messages.pot .
pybabel update --omit-header -i messages.pot -d allthethings/translations --no-fuzzy-matching

# 在改变任何翻译之后。
pybabel compile -f -d allthethings/translations

# 以上全部内容。
./update-translations.sh

# 要添加一个新的翻译文件。
pybabel init -i messages.pot -d allthethings/translations -l es
```

