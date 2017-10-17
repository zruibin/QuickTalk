DROP TABLE IF EXISTS
    `t_quickTalk_user`;
CREATE TABLE `t_quickTalk_user`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT 'uuid',
    `nickname` VARCHAR(200) NOT NULL COMMENT '昵称',
    `phone` VARCHAR(200) NOT NULL COMMENT '手机',
    `email` VARCHAR(200) NOT NULL COMMENT '邮箱',
    `avatar` TEXT NOT NULL COMMENT '头像',
    `wechat` VARCHAR(200) NOT NULL COMMENT '微信',
    `qq` VARCHAR(200) NOT NULL COMMENT 'QQ',
    `weibo` VARCHAR(200) NOT NULL COMMENT '微博',
    `time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '注册时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_user` ADD UNIQUE (`uuid`);


DROP TABLE IF EXISTS
    `t_quickTalk_topic`;
CREATE TABLE `t_quickTalk_topic`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT 'uuid',
    `title` VARCHAR(200) NOT NULL COMMENT 'title',
    `detail` TEXT NOT NULL COMMENT '简介',
    `href` TEXT NOT NULL COMMENT '链接',
    `time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '注册时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_topic` ADD UNIQUE (`uuid`);


DROP TABLE IF EXISTS
    `t_quickTalk_topic_comment`;
CREATE TABLE `t_quickTalk_topic_comment`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT 'uuid',
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `topic_uuid` VARCHAR(100) NOT NULL COMMENT 'topic uuid',
    `content` TEXT NOT NULL COMMENT '内容',
    `time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '评论时间戳',
    `like` INT(11) NOT NULL COMMENT '点赞数量',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_topic_comment` ADD UNIQUE (`uuid`);
ALTER TABLE `t_quickTalk_topic_comment` ADD INDEX t_comment_user_uuid ( `user_uuid` );
ALTER TABLE `t_quickTalk_topic_comment` ADD INDEX t_comment_topic_uuid ( `topic_uuid` );





