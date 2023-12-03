/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80034
 Source Host           : localhost:3306
 Source Schema         : studb

 Target Server Type    : MySQL
 Target Server Version : 80034
 File Encoding         : 65001

 Date: 03/12/2023 10:09:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for 临时表
-- ----------------------------
DROP TABLE IF EXISTS `临时表`;
CREATE TABLE `临时表`  (
  `临时编号` int NOT NULL AUTO_INCREMENT,
  `货物名` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `仓库号` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `货物数量` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `货物单位` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `货物类型` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`临时编号`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of 临时表
-- ----------------------------

-- ----------------------------
-- Table structure for 临时身份
-- ----------------------------
DROP TABLE IF EXISTS `临时身份`;
CREATE TABLE `临时身份`  (
  `用户名` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `密码` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `姓名` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `权限等级` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `性别` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `出生日期` date NOT NULL,
  `身份证号` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `家庭住址` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `联系电话` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`用户名`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of 临时身份
-- ----------------------------
INSERT INTO `临时身份` VALUES ('123', 'qqq', '刘某', '0', '男', '2023-12-03', '352524658745125687', '中国', '14578965412');

-- ----------------------------
-- Table structure for 仓库
-- ----------------------------
DROP TABLE IF EXISTS `仓库`;
CREATE TABLE `仓库`  (
  `仓库号` int NOT NULL,
  `仓库名称` char(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `地址` char(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `仓库容量` int NULL DEFAULT NULL,
  `已使用容量` int NULL DEFAULT NULL,
  PRIMARY KEY (`仓库号`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of 仓库
-- ----------------------------
INSERT INTO `仓库` VALUES (1, '仓库1', '硅谷', 5000, 763);
INSERT INTO `仓库` VALUES (2, '仓库2', 'A', 6870, 1521);
INSERT INTO `仓库` VALUES (3, '仓库3', '中国', 8000, 0);

-- ----------------------------
-- Table structure for 入库
-- ----------------------------
DROP TABLE IF EXISTS `入库`;
CREATE TABLE `入库`  (
  `入库单号` int NOT NULL AUTO_INCREMENT,
  `货物名` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `仓库号` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `货物数量` int NULL DEFAULT NULL,
  `管理员编号` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `入库时间` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `订单编号` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `货物单位` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `货物类型` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`入库单号`, `订单编号`, `仓库号`) USING BTREE,
  INDEX `管理员编号`(`管理员编号` ASC) USING BTREE,
  INDEX `货物号`(`货物名` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of 入库
-- ----------------------------
INSERT INTO `入库` VALUES (2, '苹果', '1', 1, NULL, '2023-12-03 08:12:17', '8ae4b898-8586-44f3-8624-ca32cf02cec0', '个', '1');

-- ----------------------------
-- Table structure for 出库
-- ----------------------------
DROP TABLE IF EXISTS `出库`;
CREATE TABLE `出库`  (
  `订单编号` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `仓库号` int NOT NULL,
  `货物名` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `货物数量` int NOT NULL,
  `出库时间` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of 出库
-- ----------------------------
INSERT INTO `出库` VALUES ('cbf0f99e-a63c-46dc-8035-f4ea32704a02', 1, '苹果', 11, '2023-12-03 02:35:41');
INSERT INTO `出库` VALUES ('c255cfaf-c48b-47ff-8c52-c3b12109f21b', 1, '1', 1, '2023-12-03 08:02:56');
INSERT INTO `出库` VALUES ('7645f5c8-7a95-42a7-bf9a-993b8de2d1ef', 1, '苹果', 1, '2023-12-03 08:03:18');
INSERT INTO `出库` VALUES ('ee324aa6-9e08-496b-880e-4d58a5ef98c0', 1, '苹果', 1, '2023-12-03 08:06:50');
INSERT INTO `出库` VALUES ('7d52376f-d719-4f41-a5ad-120b9b6e4424', 1, '苹果', 1, '2023-12-03 08:09:48');
INSERT INTO `出库` VALUES ('50fafff8-3fd7-44b3-9eb7-e8ec3f9c1e15', 1, '苹果', 1, '2023-12-03 08:10:54');

-- ----------------------------
-- Table structure for 库存
-- ----------------------------
DROP TABLE IF EXISTS `库存`;
CREATE TABLE `库存`  (
  `货物号` int NOT NULL,
  `仓库号` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `库存量` int NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of 库存
-- ----------------------------
INSERT INTO `库存` VALUES (1, '1', 541);
INSERT INTO `库存` VALUES (2, '2', 974);
INSERT INTO `库存` VALUES (3, '1', 222);
INSERT INTO `库存` VALUES (1, '2', 547);

-- ----------------------------
-- Table structure for 版本号
-- ----------------------------
DROP TABLE IF EXISTS `版本号`;
CREATE TABLE `版本号`  (
  `版本号` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`版本号`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of 版本号
-- ----------------------------
INSERT INTO `版本号` VALUES ('0.9');

-- ----------------------------
-- Table structure for 管理员
-- ----------------------------
DROP TABLE IF EXISTS `管理员`;
CREATE TABLE `管理员`  (
  `用户名` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `密码` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `姓名` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `权限等级` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `性别` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `出生日期` date NOT NULL,
  `身份证号` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `家庭住址` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `联系电话` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`用户名`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of 管理员
-- ----------------------------
INSERT INTO `管理员` VALUES ('123', 'qqq', '刘某', '0', '男', '2023-12-03', '352524658745125687', '中国', '14578965412');
INSERT INTO `管理员` VALUES ('333', '333', '朱某', '1', '男', '2023-12-05', '784521478954248745', '非洲', '15789487541');
INSERT INTO `管理员` VALUES ('666', '666', 'TinalNm', '2', '男', '2023-12-13', '741258963951753846', '埃及', '14785236985');
INSERT INTO `管理员` VALUES ('898236486', '9188821929', 'Joker', '3', '女', '2020-02-05', '478885966321445862', '美国', '14785203987');

-- ----------------------------
-- Table structure for 货物
-- ----------------------------
DROP TABLE IF EXISTS `货物`;
CREATE TABLE `货物`  (
  `货物号` int NOT NULL,
  `货物名` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `货物类型` char(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `货物拼音` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `货物单位` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`货物号`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of 货物
-- ----------------------------
INSERT INTO `货物` VALUES (1, '苹果', '水果', 'pingguo', '个');
INSERT INTO `货物` VALUES (2, '梨', '水果', 'li', '个');
INSERT INTO `货物` VALUES (3, '手机', '电子产品', 'shouji', '台');

SET FOREIGN_KEY_CHECKS = 1;
