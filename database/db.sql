DROP TABLE IF EXISTS
    `t_topic`;
CREATE TABLE `t_topic`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT 'uuid',
    `title` VARCHAR(200) NOT NULL COMMENT 'title',
    `detail` TEXT NOT NULL COMMENT '简介',
    `href` TEXT NOT NULL COMMENT '链接',
    `time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '注册时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_topic` ADD UNIQUE (`uuid`);


DROP TABLE IF EXISTS
    `t_topic_omment`;
CREATE TABLE `t_topic_omment`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT 'uuid',
    `topic_uuid` VARCHAR(100) NOT NULL COMMENT 'topic uuid',
    `content` TEXT NOT NULL COMMENT '内容',
    `time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00'  COMMENT '评论时间戳',
    `like` INT(11) NOT NULL COMMENT '点赞数量',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

ALTER TABLE `t_topic_omment` ADD UNIQUE (`uuid`);
ALTER TABLE `t_topic_omment` ADD INDEX t_comment_topic_uuid ( `topic_uuid` );





