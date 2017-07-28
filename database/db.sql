DROP TABLE IF EXISTS
    `t_user`;
CREATE TABLE `t_user`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `uuid` VARCHAR(100) NOT NULL COMMENT 'uuid',
    `nickname` VARCHAR(100) NOT NULL COMMENT '昵称',
    `detail` VARCHAR(200) NOT NULL COMMENT '简介',
    `phone` VARCHAR(20) NOT NULL COMMENT '手机',
    `qq` VARCHAR(20) NOT NULL COMMENT '用户QQ',
    `wechat` VARCHAR(40) NOT NULL COMMENT '微信',
    `email` VARCHAR(20) NOT NULL COMMENT '电子邮箱',
    `gender` TINYINT NOT NULL COMMENT '性别',
    `area` VARCHAR(40) NOT NULL COMMENT '地区',
    `avator` VARCHAR(200) NOT NULL COMMENT '头像',
    `career` VARCHAR(50) NOT NULL COMMENT '职业',
    `time` TIMESTAMP NOT NULL COMMENT '注册时间戳',
    PRIMARY KEY(`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 10000 DEFAULT CHARSET = utf8;