# Copyright (c) 2015-present, xuxueli.

CREATE database if NOT EXISTS `xxl_job` default character set utf8mb4 collate utf8mb4_unicode_ci;
use `xxl_job`;

SET NAMES utf8mb4;

CREATE TABLE `xxl_job_info` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `job_group` int(11) NOT NULL COMMENT '작업 그룹 ID',
                                `job_desc` varchar(255) NOT NULL,
                                `add_time` datetime DEFAULT NULL,
                                `update_time` datetime DEFAULT NULL,
                                `author` varchar(64) DEFAULT NULL COMMENT '작성자',
                                `alarm_email` varchar(255) DEFAULT NULL COMMENT '알람 메일',
                                `schedule_type` varchar(50) NOT NULL DEFAULT 'NONE' COMMENT '일정 유형',
                                `schedule_conf` varchar(128) DEFAULT NULL COMMENT '스케줄러 설정, 값의 의미는 스케줄러 종류에 따라 달라집니다.',
                                `misfire_strategy` varchar(50) NOT NULL DEFAULT 'DO_NOTHING' COMMENT '실패시 정책',
                                `executor_route_strategy` varchar(50) DEFAULT NULL COMMENT 'Executor 경로 정책',
                                `executor_handler` varchar(255) DEFAULT NULL COMMENT 'Executor handler 이름',
                                `executor_param` varchar(512) DEFAULT NULL COMMENT 'Executor 파라미터',
                                `executor_block_strategy` varchar(50) DEFAULT NULL COMMENT 'Executor 차단 정책',
                                `executor_timeout` int(11) NOT NULL DEFAULT '0' COMMENT 'Executor timeout',
                                `executor_fail_retry_count` int(11) NOT NULL DEFAULT '0' COMMENT 'Executor 실패 재시도 횟수',
                                `glue_type` varchar(50) NOT NULL COMMENT 'GLUE 타입',
                                `glue_source` mediumtext COMMENT 'GLUE 소스코드',
                                `glue_remark` varchar(128) DEFAULT NULL COMMENT 'GLUE 설명',
                                `glue_updatetime` datetime DEFAULT NULL COMMENT 'GLUE 수정시간',
                                `child_jobid` varchar(255) DEFAULT NULL COMMENT '자식 job ID, 쉼표로 구분하여 여러개 입력 가능',
                                `trigger_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '스케쥴러 상태 0-정지，1-실행',
                                `trigger_last_time` bigint(13) NOT NULL DEFAULT '0' COMMENT '마지막 실행 시간',
                                `trigger_next_time` bigint(13) NOT NULL DEFAULT '0' COMMENT '다음 실행 시간',
                                PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_log` (
                               `id` bigint(20) NOT NULL AUTO_INCREMENT,
                               `job_group` int(11) NOT NULL COMMENT '작업 그룹 ID',
                               `job_id` int(11) NOT NULL COMMENT '작업 ID',
                               `executor_address` varchar(255) DEFAULT NULL COMMENT 'Executor 주소, 최근 실행 주소',
                               `executor_handler` varchar(255) DEFAULT NULL COMMENT 'Executor handler 이름',
                               `executor_param` varchar(512) DEFAULT NULL COMMENT 'Executor 파라미터',
                               `executor_sharding_param` varchar(20) DEFAULT NULL COMMENT 'Executor 샤딩 파라미터, 1/2 형식',
                               `executor_fail_retry_count` int(11) NOT NULL DEFAULT '0' COMMENT 'Executor 실패 재시도 횟수',
                               `trigger_time` datetime DEFAULT NULL COMMENT '호출 시간',
                               `trigger_code` int(11) NOT NULL COMMENT '호출 결과 코드',
                               `trigger_msg` text COMMENT '호출 결과 메시지',
                               `handle_time` datetime DEFAULT NULL COMMENT '실행 시간',
                               `handle_code` int(11) NOT NULL COMMENT '실행 결과 코드',
                               `handle_msg` text COMMENT '실행 결과 메시지',
                               `alarm_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '알람 발송 상태, 0-기본, 1-필요없음, 2-알람성공, 3-알람실패',
                               PRIMARY KEY (`id`),
                               KEY `I_trigger_time` (`trigger_time`),
                               KEY `I_handle_code` (`handle_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_log_report` (
                                      `id` int(11) NOT NULL AUTO_INCREMENT,
                                      `trigger_day` datetime DEFAULT NULL COMMENT '호출 일자',
                                      `running_count` int(11) NOT NULL DEFAULT '0' COMMENT '실행중-로그갯수',
                                      `suc_count` int(11) NOT NULL DEFAULT '0' COMMENT '실행성공-로그갯수',
                                      `fail_count` int(11) NOT NULL DEFAULT '0' COMMENT '실행실패-로그갯수',
                                      `update_time` datetime DEFAULT NULL,
                                      PRIMARY KEY (`id`),
                                      UNIQUE KEY `i_trigger_day` (`trigger_day`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_logglue` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `job_id` int(11) NOT NULL COMMENT '작업 ID',
                                   `glue_type` varchar(50) DEFAULT NULL COMMENT 'GLUE 타입',
                                   `glue_source` mediumtext COMMENT 'GLUE 소스코드',
                                   `glue_remark` varchar(128) NOT NULL COMMENT 'GLUE 설명',
                                   `add_time` datetime DEFAULT NULL,
                                   `update_time` datetime DEFAULT NULL,
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_registry` (
                                    `id` int(11) NOT NULL AUTO_INCREMENT,
                                    `registry_group` varchar(50) NOT NULL,
                                    `registry_key` varchar(255) NOT NULL,
                                    `registry_value` varchar(255) NOT NULL,
                                    `update_time` datetime DEFAULT NULL,
                                    PRIMARY KEY (`id`),
                                    KEY `i_g_k_v` (`registry_group`,`registry_key`,`registry_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_group` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `app_name` varchar(64) NOT NULL COMMENT 'Executor AppName',
                                 `title` varchar(12) NOT NULL COMMENT 'Executor 제목',
                                 `address_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Executor 주소 유형 0=자동 등록, 1=수동 입력',
                                 `address_list` text COMMENT 'Executor 주소 목록, 쉼표로 구분하여 여러개 등록 가능',
                                 `update_time` datetime DEFAULT NULL,
                                 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_user` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `username` varchar(50) NOT NULL COMMENT '로그인 ID',
                                `password` varchar(50) NOT NULL COMMENT '비밀번호',
                                `role` tinyint(4) NOT NULL COMMENT '사용자 구분, 0-일반사용자, 1-관리자',
                                `permission` varchar(255) DEFAULT NULL COMMENT '권한, 작업 그룹 ID 쉼표로 구분하여 여러개 등록 가능',
                                PRIMARY KEY (`id`),
                                UNIQUE KEY `i_username` (`username`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_lock` (
                                `lock_name` varchar(50) NOT NULL COMMENT 'LOCK NAME',
                                PRIMARY KEY (`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `xxl_job_group`(`id`, `app_name`, `title`, `address_type`, `address_list`, `update_time`) VALUES (1, 'xxl-job-executor-sample', '示例执行器', 0, NULL, '2018-11-03 22:21:31' );
INSERT INTO `xxl_job_info`(`id`, `job_group`, `job_desc`, `add_time`, `update_time`, `author`, `alarm_email`, `schedule_type`, `schedule_conf`, `misfire_strategy`, `executor_route_strategy`, `executor_handler`, `executor_param`, `executor_block_strategy`, `executor_timeout`, `executor_fail_retry_count`, `glue_type`, `glue_source`, `glue_remark`, `glue_updatetime`, `child_jobid`) VALUES (1, 1, '测试任务1', '2018-11-03 22:21:31', '2018-11-03 22:21:31', 'XXL', '', 'CRON', '0 0 0 * * ? *', 'DO_NOTHING', 'FIRST', 'demoJobHandler', '', 'SERIAL_EXECUTION', 0, 0, 'BEAN', '', 'GLUE代码初始化', '2018-11-03 22:21:31', '');
INSERT INTO `xxl_job_user`(`id`, `username`, `password`, `role`, `permission`) VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 1, NULL);
INSERT INTO `xxl_job_lock` ( `lock_name`) VALUES ( 'schedule_lock');

commit;