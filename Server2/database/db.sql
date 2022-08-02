
-- v1.0
-- Create By Ruibin.Chow

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

ALTER TABLE `t_quickTalk_user` AUTO_INCREMENT=10000;
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
    `t_quickTalk_topic_content`;
CREATE TABLE `t_quickTalk_topic_content`(
    `uuid` VARCHAR(100) NOT NULL COMMENT 'uuid',
    `content` TEXT NOT NULL COMMENT '内容'
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_topic_content` ADD UNIQUE (`uuid`);


DROP TABLE IF EXISTS
    `t_quickTalk_topic_comment`;
CREATE TABLE `t_quickTalk_topic_comment`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT 'uuid',
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `topic_uuid` VARCHAR(100) NOT NULL COMMENT 'topic uuid',
    `content` TEXT NOT NULL COMMENT '内容',
    `time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '评论产生时间戳',
    `update_time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '评论更新时间戳',
    `like` INT(11) NOT NULL COMMENT '点赞数量',
    `dislike` INT(11) NOT NULL COMMENT '不赞同数量',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_topic_comment` ADD UNIQUE (`uuid`);
ALTER TABLE `t_quickTalk_topic_comment` ADD INDEX t_comment_user_uuid ( `user_uuid` );
ALTER TABLE `t_quickTalk_topic_comment` ADD INDEX t_comment_topic_uuid ( `topic_uuid` );


INSERT INTO `t_quickTalk_user` (`id`, `uuid`, `nickname`, `phone`, `email`, `avatar`, `wechat`, `qq`, `weibo`, `time`) VALUES
(10000, 'cea8b1c3aebe31823fa86e069de496b9', '', '', '', '2017102011013512hgLe.png', '1234567', '', '', '2017-10-20 03:01:35'),
(10001, '22908c712545dca68ae6a09383f47bc3', '', '', '', '201710201102566Ieb5r.png', '100000', '', '', '2017-10-20 03:02:56'),
(10002, 'deb98a5555f6d5780467f7bebf61eb5b', '', '', '', '20171020110322gEJKj6.png', '100001', '', '', '2017-10-20 03:03:22');



-- v1.1
-- Create By Ruibin.Chow


ALTER TABLE `t_quickTalk_user` ADD gender INT NOT NULL Default 0;
ALTER TABLE `t_quickTalk_user` ADD area VARCHAR(100);
ALTER TABLE `t_quickTalk_user` ADD detail TEXT;
ALTER TABLE `t_quickTalk_topic` ADD read_count INT NOT NULL Default 0;

DROP TABLE IF EXISTS
    `t_quickTalk_user_auth`;
CREATE TABLE `t_quickTalk_user_auth`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `password` VARCHAR(100) NOT NULL COMMENT '用户密码加盐(md5)',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_user_auth` ADD INDEX t_user_auth_uuid (`user_uuid`);


DROP TABLE IF EXISTS
    `t_quickTalk_userPost`;
CREATE TABLE `t_quickTalk_userPost`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT 'uuid',
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `txt` TEXT COMMENT '内容',
    `title` TEXT NOT NULL COMMENT '标题',
    `content` TEXT NOT NULL COMMENT '数据内容',
    `img` TEXT NOT NULL COMMENT '图片地址',
    `time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '产生时间戳',
    `read_count` INT(11) NOT NULL COMMENT '阅读量',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_userPost` ADD UNIQUE (`uuid`);
ALTER TABLE `t_quickTalk_userPost` ADD INDEX t_circle_user_uuid ( `user_uuid` );


DROP TABLE IF EXISTS
    `t_quickTalk_userPost_comment`;
CREATE TABLE `t_quickTalk_userPost_comment`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT 'uuid',
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `userPost_uuid` VARCHAR(100) NOT NULL COMMENT 'userPost uuid',
    `content` TEXT NOT NULL COMMENT '内容',
    `isReply` INT NOT NULL Default 0 COMMENT '是否回复',
    `reply_uuid`  VARCHAR(100) COMMENT '被回复的评论的uuid',
    `time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '产生时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_userPost_comment` ADD UNIQUE (`uuid`);
ALTER TABLE `t_quickTalk_userPost_comment` ADD INDEX t_comment_user_uuid ( `user_uuid` );
ALTER TABLE `t_quickTalk_userPost_comment` ADD INDEX t_comment_userPost_uuid ( `userPost_uuid` );



-- v1.2
-- Create By Ruibin.Chow

DROP TABLE IF EXISTS
    `t_quickTalk_user_setting`;
CREATE TABLE `t_quickTalk_user_setting`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `status` TINYINT UNSIGNED NOT NULL COMMENT '状态(开与关)',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_user_setting` ADD INDEX t_quickTalk_user_setting_setting_uuid (`user_uuid`);

INSERT INTO t_quickTalk_user_setting (user_uuid, type, status) 
SELECT uuid AS user_uuid, 1, 1 FROM t_quickTalk_user
UNION ALL
SELECT uuid AS user_uuid, 2, 1 FROM t_quickTalk_user
UNION ALL
SELECT uuid AS user_uuid, 3, 1 FROM t_quickTalk_user
UNION ALL
SELECT uuid AS user_uuid, 4, 0 FROM t_quickTalk_user;



-- v1.3
-- Create By Ruibin.Chow

DROP TABLE IF EXISTS
    `t_quickTalk_user_user`;
CREATE TABLE `t_quickTalk_user_user`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `other_user_uuid` VARCHAR(100) NOT NULL COMMENT '被关联的用户uuid',
    `time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '关联时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_user_user` ADD INDEX t_quickTalk_user_user_user_uuid (`user_uuid`);
ALTER TABLE `t_quickTalk_user_user` ADD INDEX t_quickTalk_user_user_type (`type`);
ALTER TABLE `t_quickTalk_user_user` ADD INDEX t_quickTalk_user_user_other_user_uuid (`other_user_uuid`);

DROP TABLE IF EXISTS
    `t_quickTalk_message`;
CREATE TABLE `t_quickTalk_message`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '接收消息的用户的uuid',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `content_uuid` VARCHAR(100) NOT NULL COMMENT '内容的uuid',
    `time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '产生消息的时间戳',
    `generated_user_uuid` VARCHAR(100) NOT NULL COMMENT '产生消息的用户的uuid',
    `status` TINYINT UNSIGNED NOT NULL COMMENT '状态(是否已读)',
    `content` VARCHAR(200) DEFAULT NULL COMMENT '消息内容',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_message` ADD INDEX t_quickTalk_message_user_uuid ( `user_uuid` );
ALTER TABLE `t_quickTalk_message` ADD INDEX t_quickTalk_message_content_uuid ( `content_uuid` );
ALTER TABLE `t_quickTalk_message` ADD INDEX t_quickTalk_message_generated_user_uuid ( `generated_user_uuid` );

DROP TABLE IF EXISTS
    `t_quickTalk_like`;
CREATE TABLE `t_quickTalk_like`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `type` VARCHAR(20) NOT NULL COMMENT '类型',
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `content_uuid` VARCHAR(100) NOT NULL COMMENT '被赞的内容的uuid',
    `time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '产生时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_like` ADD INDEX t_like_content_uuid (`content_uuid`);
ALTER TABLE `t_quickTalk_like` ADD INDEX t_like_user_uuid ( `user_uuid` );

DROP TABLE IF EXISTS
    `t_quickTalk_collection`;
CREATE TABLE `t_quickTalk_collection`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `type` VARCHAR(20) NOT NULL COMMENT '类型',
    `content_uuid` VARCHAR(100) NOT NULL COMMENT '收藏的内容的uuid',
    `time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '产生时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_collection` ADD INDEX t_collection_content_uuid (`content_uuid`);
ALTER TABLE `t_quickTalk_collection` ADD INDEX t_collection_user_uuid ( `user_uuid` );

DROP TABLE IF EXISTS
    `t_quickTalk_notification_device`;
CREATE TABLE `t_quickTalk_notification_device`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `deviceId` VARCHAR(100) NOT NULL COMMENT '唯一对应一台设备',
    `time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '产生时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_notification_device` ADD INDEX t_notification_device_user_uuid (`user_uuid`);



-- v1.4
-- Create By Ruibin.Chow
INSERT INTO t_quickTalk_user_user (user_uuid, type, other_user_uuid, time) 
SELECT uuid AS user_uuid, 0, 'cfb43f1df01c74f24d1a68f583b36613', time FROM t_quickTalk_user

ALTER TABLE `t_quickTalk_notification_device` ADD type TINYINT NOT NULL Default 0;



-- V1.5
-- Create By Ruibin.Chow
DROP TABLE IF EXISTS
    `t_quickTalk_tag_userPost`;
CREATE TABLE `t_quickTalk_tag_userPost`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `userPost_uuid` VARCHAR(100) NOT NULL COMMENT 'userPost的uuid',
    `sorting` TINYINT UNSIGNED NOT NULL COMMENT '顺序',
    `tag` VARCHAR(200) DEFAULT NULL COMMENT '标签',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_tag_userPost` ADD INDEX t_quickTalk_tag_userPost_uuid ( `userPost_uuid` );
ALTER TABLE `t_quickTalk_tag_userPost` ADD INDEX t_quickTalk_tag_userPost_tag ( `tag` );


DROP TABLE IF EXISTS
    `t_quickTalk_user_read`;
CREATE TABLE `t_quickTalk_user_read`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户的uuid',
    `type` VARCHAR(20) NOT NULL COMMENT '类型',
    `uuid` VARCHAR(100) NOT NULL COMMENT '内容的uuid',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_quickTalk_user_read` ADD INDEX t_quickTalk_user_read_uuid ( `uuid` );
ALTER TABLE `t_quickTalk_user_read` ADD INDEX t_quickTalk_user_read_user_uuid ( `user_uuid` );


ALTER TABLE `t_quickTalk_userPost` ADD `type` VARCHAR(10) NOT NULL DEFAULT '0' COMMENT '类型';


