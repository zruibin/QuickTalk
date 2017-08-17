DROP TABLE IF EXISTS
    `t_user`;
CREATE TABLE `t_user`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT 'uuid',
    `email` VARCHAR(20) NOT NULL COMMENT '登录用的电子邮箱',
    `phone` VARCHAR(20) NOT NULL COMMENT '登录用的手机',
    `nickname` VARCHAR(100) NOT NULL COMMENT '昵称',
    `detail` VARCHAR(200) NOT NULL COMMENT '简介',
    `qq` VARCHAR(20) NOT NULL COMMENT '用户QQ',
    `wechat` VARCHAR(40) NOT NULL COMMENT '微信',
    `weibo` VARCHAR(40) NOT NULL COMMENT '微博',
    `gender` TINYINT UNSIGNED NOT NULL COMMENT '性别',
    `area` VARCHAR(40) NOT NULL COMMENT '地区',
    `avatar` VARCHAR(200) NOT NULL COMMENT '头像',
    `career` VARCHAR(50) NOT NULL COMMENT '职业',
    `contact_phone` VARCHAR(20) NOT NULL COMMENT '联系手机',
    `contact_email` VARCHAR(20) NOT NULL COMMENT '联系邮箱',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_user` AUTO_INCREMENT=10000;

ALTER TABLE `t_user` ADD UNIQUE (`uuid`);
ALTER TABLE `t_user` ADD INDEX t_user_nickname ( `nickname` );
ALTER TABLE `t_user` ADD INDEX t_user_phone ( `phone` );
ALTER TABLE `t_user` ADD INDEX t_user_email ( `email` );

DROP TABLE IF EXISTS
    `t_user_auth`;
CREATE TABLE `t_user_auth`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `password` VARCHAR(100) NOT NULL COMMENT '用户密码加盐(md5)',
    `qq` VARCHAR(50) NOT NULL COMMENT '用户QQ授权',
    `wechat` VARCHAR(50) NOT NULL COMMENT '微信授权',
    `weibo` VARCHAR(50) NOT NULL COMMENT '微博授权',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_user_auth` ADD INDEX t_user_auth_uuid (`user_uuid`);

DROP TABLE IF EXISTS
    `t_user_user`;
CREATE TABLE `t_user_user`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型(1、关注者与粉丝，2、已交换联系方式的人)',
    `other_user_uuid` VARCHAR(100) NOT NULL COMMENT '被关联的用户uuid',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '关联时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_user_user` ADD INDEX t_user_auth_uuid (`user_uuid`);
ALTER TABLE `t_user_user` ADD INDEX t_user_type (`type`);

DROP TABLE IF EXISTS
    `t_user_setting`;
CREATE TABLE `t_user_setting`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `status` TINYINT UNSIGNED NOT NULL COMMENT '状态(开与关)',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_user_setting` ADD INDEX t_user_setting_uuid (`user_uuid`);

DROP TABLE IF EXISTS
    `t_user_eduction`;
CREATE TABLE `t_user_eduction`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `sorting` TINYINT UNSIGNED NOT NULL COMMENT '顺序',
    `school` VARCHAR(100) NOT NULL COMMENT '学校',
    `begin_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间戳',
    `end_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '结束时间戳',
    `major` VARCHAR(100) NOT NULL COMMENT '专业',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_user_eduction` ADD INDEX t_user_eduction_uuid (`user_uuid`);

DROP TABLE IF EXISTS
    `t_project`;
CREATE TABLE `t_project`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT '项目uuid',
    `title` VARCHAR(200) NOT NULL COMMENT '标题',
    `detail` TEXT NOT NULL COMMENT '详细介绍',
    `result` TEXT NOT NULL COMMENT '结果',
    `author_uuid` VARCHAR(100) NOT NULL COMMENT '创建者uuid',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间戳',
    `like` INT(11) NOT NULL COMMENT '点赞数量',
    `status` TINYINT UNSIGNED NOT NULL COMMENT '状态',
    `have_plan` TINYINT UNSIGNED NOT NULL COMMENT '是否含有计划列表',
    `medias_count` TINYINT UNSIGNED NOT NULL COMMENT '多媒体数量',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_project` ADD UNIQUE (`uuid`);
ALTER TABLE `t_project` ADD INDEX t_project_title ( `title` );
ALTER TABLE `t_project` ADD INDEX t_project_author_uuid ( `author_uuid` );

DROP TABLE IF EXISTS
    `t_project_user`;
CREATE TABLE `t_project_user`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `project_uuid` VARCHAR(100) NOT NULL COMMENT '项目uuid',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型(成员与关注者)',
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_project_user` ADD INDEX t_project_user_project_uuid ( `project_uuid` );
ALTER TABLE `t_project_user` ADD INDEX t_project_user_type ( `type` );
ALTER TABLE `t_project_user` ADD INDEX t_project_user_user_uuid ( `user_uuid` );

DROP TABLE IF EXISTS
    `t_project_media`;
CREATE TABLE `t_project_media`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `project_uuid` VARCHAR(100) NOT NULL COMMENT '项目uuid',
    `sorting` TINYINT UNSIGNED NOT NULL COMMENT '顺序',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `media_name` VARCHAR(100) NOT NULL COMMENT '媒体名称',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_project_media` ADD INDEX t_project_media_project_uuid ( `project_uuid` );

DROP TABLE IF EXISTS
    `t_project_plan`;
CREATE TABLE `t_project_plan`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT 'uuid',
    `project_uuid` VARCHAR(100) NOT NULL COMMENT '项目uuid',
    `sorting` TINYINT UNSIGNED NOT NULL COMMENT '顺序',
    `content` TEXT NOT NULL COMMENT '内容',
    `start_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间戳',
    `finish_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '结束时间戳',
    `medias_count` TINYINT UNSIGNED NOT NULL COMMENT '多媒体数量',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_project_plan` ADD INDEX t_project_plan_project_uuid ( `project_uuid` );

DROP TABLE IF EXISTS
    `t_project_plan_media`;
CREATE TABLE `t_project_plan_media`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `plan_uuid` VARCHAR(100) NOT NULL COMMENT '计划uuid',
    `project_uuid` VARCHAR(100) NOT NULL COMMENT '项目uuid',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `sorting` TINYINT UNSIGNED NOT NULL COMMENT '顺序',
    `media_name` VARCHAR(100) NOT NULL COMMENT '媒体名称',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_project_plan_media` ADD INDEX t_project_plan_media_plan_uuid ( `plan_uuid` );
ALTER TABLE `t_project_plan_media` ADD INDEX t_project_plan_media_project_uuid ( `project_uuid` );

DROP TABLE IF EXISTS
    `t_comment`;
CREATE TABLE `t_comment`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT 'uuid',
    `project_uuid` VARCHAR(100) NOT NULL COMMENT '项目uuid',
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `content` TEXT NOT NULL COMMENT '内容',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间戳',
    `like` INT(11) NOT NULL COMMENT '点赞数量',
    `is_reply` INT(11) NOT NULL COMMENT '是否回复',
    `reply_user_uuid` VARCHAR(100) NOT NULL COMMENT '回复者uuid',
    `reply_comment_id` INT DEFAULT NULL COMMENT '回复的评论的id',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_comment` ADD UNIQUE (`uuid`);
ALTER TABLE `t_comment` ADD INDEX t_comment_project_uuid ( `project_uuid` );
ALTER TABLE `t_comment` ADD INDEX t_comment_user_uuid ( `user_uuid` );

DROP TABLE IF EXISTS
    `t_project_journal`;
CREATE TABLE `t_project_journal`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT '日志uuid',
    `project_uuid` VARCHAR(100) NOT NULL COMMENT '项目uuid',
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `content` TEXT NOT NULL COMMENT '内容',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间戳',
    `like` INT(11) UNSIGNED NOT NULL COMMENT '点赞数量',
    `medias_count` TINYINT UNSIGNED NOT NULL COMMENT '多媒体数量',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_project_journal` ADD UNIQUE (`uuid`);
ALTER TABLE `t_project_journal` ADD INDEX t_project_journal_project_uuid ( `project_uuid` );

DROP TABLE IF EXISTS
    `t_project_journal_media`;
CREATE TABLE `t_project_journal_media`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `journal_uuid` VARCHAR(100) NOT NULL COMMENT '日志uuid',
    `project_uuid` VARCHAR(100) NOT NULL COMMENT '项目uuid',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `sorting` TINYINT UNSIGNED NOT NULL COMMENT '顺序',
    `media_name` VARCHAR(100) NOT NULL COMMENT '媒体名称',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_project_journal_media` ADD INDEX t_project_journal_media_journal_uuid ( `journal_uuid` );


DROP TABLE IF EXISTS
    `t_message_like`;
CREATE TABLE `t_message_like`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `content_uuid` VARCHAR(100) NOT NULL COMMENT '内容的uuid',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '产生消息的时间戳',
    `owner_user_uuid` VARCHAR(100) NOT NULL COMMENT '拥有内容的用户uuid',
    `status` TINYINT UNSIGNED NOT NULL COMMENT '状态(是否已读)',
    `content` VARCHAR(200) DEFAULT NULL COMMENT '消息内容',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_message_like` ADD INDEX t_message_like_user_uuid ( `user_uuid` );

DROP TABLE IF EXISTS
    `t_message_project`;
CREATE TABLE `t_message_project`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `content_uuid` VARCHAR(100) NOT NULL COMMENT '内容的uuid',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '产生消息的时间戳',
    `owner_user_uuid` VARCHAR(100) NOT NULL COMMENT '拥有内容的用户uuid',
    `status` TINYINT UNSIGNED NOT NULL COMMENT '状态(是否已读)',
    `content` VARCHAR(200) DEFAULT NULL COMMENT '消息内容',
    `action` TINYINT UNSIGNED NOT NULL COMMENT '行为(是否已通过)',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_message_project` ADD INDEX t_message_project_user_uuid ( `user_uuid` );

DROP TABLE IF EXISTS
    `t_message_comment`;
CREATE TABLE `t_message_comment`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `content_uuid` VARCHAR(100) NOT NULL COMMENT '内容的uuid',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '产生消息的时间戳',
    `owner_user_uuid` VARCHAR(100) NOT NULL COMMENT '拥有内容的用户uuid',
    `status` TINYINT UNSIGNED NOT NULL COMMENT '状态(是否已读)',
    `content` VARCHAR(200) DEFAULT NULL COMMENT '消息内容',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_message_comment` ADD INDEX t_message_comment_user_uuid ( `user_uuid` );

DROP TABLE IF EXISTS
    `t_message_start`;
CREATE TABLE `t_message_start`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `content_uuid` VARCHAR(100) NOT NULL COMMENT '内容的uuid',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '产生消息的时间戳',
    `owner_user_uuid` VARCHAR(100) NOT NULL COMMENT '拥有内容的用户uuid',
    `status` TINYINT UNSIGNED NOT NULL COMMENT '状态(是否已读)',
    `content` VARCHAR(200) DEFAULT NULL COMMENT '消息内容',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_message_start` ADD INDEX t_message_start_user_uuid ( `user_uuid` );

DROP TABLE IF EXISTS
    `t_message_contact`;
CREATE TABLE `t_message_contact`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `content_uuid` VARCHAR(100) NOT NULL COMMENT '内容的uuid',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '产生消息的时间戳',
    `owner_user_uuid` VARCHAR(100) NOT NULL COMMENT '拥有内容的用户uuid',
    `status` TINYINT UNSIGNED NOT NULL COMMENT '状态(是否已读)',
    `content` VARCHAR(200) DEFAULT NULL COMMENT '消息内容',
    `action` TINYINT UNSIGNED NOT NULL COMMENT '行为(是否已通过)',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_message_contact` ADD INDEX t_message_contact_user_uuid ( `user_uuid` );


DROP TABLE IF EXISTS
    `t_tag_user`;
CREATE TABLE `t_tag_user`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_uuid` VARCHAR(100) NOT NULL COMMENT '用户uuid',
    `sorting` TINYINT UNSIGNED NOT NULL COMMENT '顺序',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `content` VARCHAR(200) DEFAULT NULL COMMENT '内容',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_tag_user` ADD INDEX t_tag_user_user_uuid ( `user_uuid` );

DROP TABLE IF EXISTS
    `t_tag_project`;
CREATE TABLE `t_tag_project`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `project_uuid` VARCHAR(100) NOT NULL COMMENT '项目uuid',
    `sorting` TINYINT UNSIGNED NOT NULL COMMENT '顺序',
    `type` TINYINT UNSIGNED NOT NULL COMMENT '类型',
    `content` VARCHAR(200) DEFAULT NULL COMMENT '内容',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_tag_project` ADD INDEX t_tag_project_project_uuid ( `project_uuid` );


DROP TABLE IF EXISTS
    `t_backoffice_user`;
CREATE TABLE `t_backoffice_user`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `nickname` VARCHAR(100) NOT NULL COMMENT '昵称',
    `detail` VARCHAR(200) NOT NULL COMMENT '简介',
    `phone` VARCHAR(20) NOT NULL COMMENT '手机',
    `email` VARCHAR(20) NOT NULL COMMENT '电子邮箱',
    `qq` VARCHAR(20) NOT NULL COMMENT '用户QQ',
    `wechat` VARCHAR(40) NOT NULL COMMENT '微信',
    `gender` TINYINT UNSIGNED NOT NULL COMMENT '性别',
    `area` VARCHAR(40) NOT NULL COMMENT '地区',
    `avator` VARCHAR(200) NOT NULL COMMENT '头像',
    `career` VARCHAR(50) NOT NULL COMMENT '职业',
    `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间戳',
    `password` VARCHAR(100) NOT NULL COMMENT '用户密码加盐(md5)',
    `level` TINYINT UNSIGNED NOT NULL COMMENT '级别',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_backoffice_user` ADD INDEX t_backoffice_user_nickname ( `nickname` );

INSERT INTO `t_backoffice_user`(`id`, `nickname`, `detail`, `phone`, `email`, `qq`, `wechat`, `gender`, `area`, `avator`, `career`, `time`, `password`,`level`)
    VALUES(1, 'zruibin', 'administration', '+8613113324024', 'ruibin.chow@qq.com', '328437740', 'z_ruibin', 1, '深圳', ' ', '程序员', '2017-07-31 06:17:40',
            'f8f235136f525e39e94f401424954c3a', 0);



