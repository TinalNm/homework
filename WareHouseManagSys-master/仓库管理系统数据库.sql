USE `mydatabase`;

CREATE TABLE `仓库` (
  `仓库编号` char(255) NOT NULL,
  `仓库名称` char(255) DEFAULT NULL,
  `仓库地址` char(255) DEFAULT NULL,
  PRIMARY KEY (`仓库编号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `仓库` (`仓库编号`, `仓库名称`, `仓库地址`) VALUES 
('A ', '武汉仓库 ', '武汉 '),
('B ', '上海仓库 ', '上海 '),
('C ', '杭州仓库 ', '杭州 '),
('D ', '深圳仓库 ', '深圳 '),
('E ', '北京仓库 ', '北京 '),
('F ', '广州仓库 ', '广州 '),
('G ', '天门仓库 ', '天门 '),
('H ', '苏州仓库 ', '苏州 '),
('I ', '洛阳仓库 ', '洛阳 ');

CREATE TABLE `管理员` (
  `管理员编号` char(255) NOT NULL,
  `姓名` varchar(255) DEFAULT NULL,
  `密码` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`管理员编号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `管理员` (`管理员编号`, `姓名`, `密码`) VALUES 
('ad1 ', '刘备', '123456'),
('ad2 ', '关羽', '23456'),
('ad3 ', '张飞', '123456'),
('ad4 ', '赵云', '123456'),
('admin', '诸葛亮', '123');

CREATE TABLE `供应商` (
  `供应商编号` char(255) NOT NULL,
  `姓名` varchar(255) NOT NULL,
  `地址` varchar(255) DEFAULT NULL,
  `电话` char(255) DEFAULT NULL,
  PRIMARY KEY (`供应商编号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `供应商` (`供应商编号`, `姓名`, `地址`, `电话`) VALUES 
('00001', '阿里', '北京', '18062795547'),
('00002', '百度', '北京', '13751256211'),
('00003', '腾讯', '深圳', '18065324125'),
('00004', '淘宝', '武汉', '12345678902'),
('00005', '立得', '武汉', '12345678903'),
('00006', '谷歌', '纽约', '74185296301'),
('00007', '外婆桥', '湖北', '18062354785'),
('00008', '地信', '长达', '18062124123'),
('00009', '美团', '天津', '13835421265');
CREATE TABLE `货物`(
    `货物编号` char(5) NOT NULL,
    `货物名称` char(20) NOT NULL,
    `货物类型` char(5) NULL,
    `供应商编号` char(5) NULL,
    PRIMARY KEY (`货物编号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `货物` (`货物编号`, `货物名称`, `货物类型`, `供应商编号`) VALUES 
('10001', '苹果', '水果', '00001'),
('10002', '电脑', '电器', '00002'),
('10003', '床', '家具', '00005'),
('10004', '梨子', '水果', '00001'),
('10005', '香蕉', '水果', '00009'),
('10008', '大米', '食物', '00003');

CREATE TABLE `库存`(
    `货物编号` char(5) NOT NULL,
    `仓库编号` char(5) NOT NULL,
    `库存量` int NULL,
    PRIMARY KEY (`货物编号`, `仓库编号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `库存` (`货物编号`, `仓库编号`, `库存量`) VALUES 
('10001', 'A', 21),
('10001', 'B', 400),
('10001', 'C', 380),
('10002', 'B', 171),
('10003', 'A', 541),
('10003', 'B', 50),
('10004', 'A', 53),
('10005', 'A', 7),
('10008', 'A', 181),
('10008', 'B', 123),
('10008', 'C', 431);

DELIMITER //
CREATE PROCEDURE `login_proc` (IN `user` CHAR(5), IN `pws` VARCHAR(10), OUT `status` INT)
BEGIN
    SELECT COUNT(*) INTO `status` FROM `管理员` WHERE `密码`=TRIM(`pws`) AND `管理员编号`=TRIM(`user`);
    IF `status`=1 THEN SET `status`=0;
    ELSE
        BEGIN
            SELECT COUNT(*) INTO `status` FROM `管理员` WHERE `管理员编号`=TRIM(`user`);
            IF `status`=0 THEN SET `status`=1;
            ELSE SET `status`=2;
            END IF;
        END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `admin_proc` (IN `choice` INT, IN `num` CHAR(5), IN `name` VARCHAR(20), IN `pws` VARCHAR(10), OUT `status` INT)
BEGIN
    IF(`num` <>'') THEN
        BEGIN
            IF(`choice` =1) THEN
                BEGIN
                    IF(`name`<>'' AND `num` NOT IN(SELECT `管理员编号` FROM `管理员`)) THEN
                        INSERT INTO `管理员` VALUES(`num`,`name`,`pws`);
                        SET `status`=0;
                    END IF;
                END;
            ELSEIF(`choice`=2) THEN
                BEGIN
                    UPDATE `管理员` SET `姓名`=`name` ,`密码`=`pws` WHERE `num`=`管理员编号`;
                    SET `status`=1;
                END;
            ELSEIF(`choice`=3) THEN
                BEGIN
                    IF(`num` <>'admin') THEN
                        BEGIN
                            DELETE FROM `管理员` WHERE `num`=`管理员编号`;
                            SET `status`=2;
                        END;
                    ELSE
                        BEGIN
                            SET `status`=4;
                        END;
                    END IF;
                END;
            END IF;
        END;
    ELSE SET `status`=3;
    END IF;
END//
DELIMITER ;
DELIMITER //
CREATE PROCEDURE `SelecHuowu_proc` (IN `choice` INT, IN `huowu` CHAR(5), IN `name` CHAR(20), IN `type` CHAR(5), IN `gongying` CHAR(5), OUT `status` INT)
BEGIN
    IF(`choice`=1) THEN
        BEGIN
            DELETE FROM `货物` WHERE `huowu`=`货物编号`;
            SET `status`=2;
        END;
    ELSEIF(`choice`=2) THEN
        BEGIN
            IF(`huowu` NOT IN(SELECT `货物编号` FROM `货物`)) THEN
                BEGIN
                    INSERT INTO `货物` VALUES(`huowu`,`name`,`type`,`gongying`);
                    SET `status`=1;
                END;
            ELSE SET `status`=0;
            END IF;
        END;
    ELSE SET `status`=3;
    END IF;
END//
DELIMITER ;

CREATE VIEW `kucun_view` AS
    SELECT `库存`.`仓库编号`, `库存`.`货物编号`, `货物名称`, `货物类型`, `库存量`, `供应商`.`姓名`
    FROM `库存`, `货物`, `供应商`
    WHERE `库存`.`货物编号`=`货物`.`货物编号` AND `货物`.`供应商编号`=`供应商`.`供应商编号`;

CREATE VIEW `huowu_view` AS
    SELECT `货物编号`, `货物名称`, `货物类型`, `货物`.`供应商编号`, `姓名` AS `供应商名称`
    FROM `货物`, `供应商`
    WHERE `货物`.`供应商编号`=`供应商`.`供应商编号`;

CREATE TABLE `借还`(
    `借条号` VARCHAR(10) NOT NULL,
    `仓库编号` CHAR(5) NOT NULL,
    `货物编号` CHAR(5) NOT NULL,
    `借还量` INT NOT NULL,
    `管理员编号` CHAR(5) NULL,
    `借入人` VARCHAR(5) NULL,
    `借出日期` DATETIME NULL,
    `归还日期` DATETIME NULL,
    PRIMARY KEY (`借条号`, `货物编号`, `仓库编号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE `库存设置`(
    `货物编号` CHAR(5) NOT NULL,
    `仓库编号` CHAR(5) NOT NULL,
    `最小值` INT NULL,
    `最大值` INT NULL,
    PRIMARY KEY (`货物编号`, `仓库编号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `库存设置` (`货物编号`, `仓库编号`, `最小值`, `最大值`) VALUES ('10001', 'A    ', 10, 800);
INSERT INTO `库存设置` (`货物编号`, `仓库编号`, `最小值`, `最大值`) VALUES ('10001', 'B    ', 0, 999);
INSERT INTO `库存设置` (`货物编号`, `仓库编号`, `最小值`, `最大值`) VALUES ('10001', 'C    ', 0, 1000);
INSERT INTO `库存设置` (`货物编号`, `仓库编号`, `最小值`, `最大值`) VALUES ('10002', 'A    ', 0, 1500);
INSERT INTO `库存设置` (`货物编号`, `仓库编号`, `最小值`, `最大值`) VALUES ('10002', 'A    ', 0, 1500);
INSERT INTO `库存设置` (`货物编号`, `仓库编号`, `最小值`, `最大值`) VALUES ('10002', 'B   ', 0, 1000);
INSERT INTO `库存设置` (`货物编号`, `仓库编号`, `最小值`, `最大值`) VALUES ('10003', 'A    ', 0, 1000);
INSERT INTO `库存设置` (`货物编号`, `仓库编号`, `最小值`, `最大值`) VALUES ('10003', 'B    ', 0, 1000);
INSERT INTO `库存设置` (`货物编号`, `仓库编号`, `最小值`, `最大值`) VALUES ('10004', 'A    ', 50, 2000);
INSERT INTO `库存设置` (`货物编号`, `仓库编号`, `最小值`, `最大值`) VALUES ('10005', 'A    ', 0, 1000);
INSERT INTO `库存设置` (`货物编号`, `仓库编号`, `最小值`, `最大值`) VALUES ('10008', 'A    ', 0, 1000);
INSERT INTO `库存设置` (`货物编号`, `仓库编号`, `最小值`, `最大值`) VALUES ('10008', 'B    ', 0, 1000);
INSERT INTO `库存设置` (`货物编号`, `仓库编号`, `最小值`, `最大值`) VALUES ('10008', 'C    ', 0, 1000);

CREATE TABLE `入库`(
    `入库单号` VARCHAR(10) NOT NULL,
    `仓库编号` CHAR(5) NOT NULL,
    `货物编号` CHAR(5) NOT NULL,
    `入库量` INT NOT NULL,
    `管理员编号` CHAR(5) NULL,
    `入库时间` DATETIME NULL,
    PRIMARY KEY (`入库单号`, `仓库编号`, `货物编号`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


INSERT INTO `入库` (`入库单号`, `仓库编号`, `货物编号`, `入库量`, `管理员编号`, `入库时间`) VALUES ('IA16010101', 'A    ', '10001', 10, 'ad1  ', '2016-01-13 11:10:56');
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IA16010102', N'A    ', N'10003', 451, N'ad1  ', CAST(0x0000A584010375FB AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IA16010103', N'A    ', N'10008', 200, N'ad2  ', CAST(0x0000A58401033CAC AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IA16010104', N'A    ', N'10001', 1, N'ad1  ', CAST(0x0000A58700CC0FF6 AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IA16010105', N'A    ', N'10001', 100, N'ad1  ', CAST(0x0000A586012C301A AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IA16010106', N'A    ', N'10001', 10, N'ad3  ', CAST(0x0000A58800FCB6D9 AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IA16010107', N'A    ', N'10004', 50, N'ad1  ', CAST(0x0000A58A00AB4CA0 AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IA16010108', N'A    ', N'10004', 3, N'ad1  ', CAST(0x0000A58B00BD6B10 AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IA16010109', N'A    ', N'10005', 7, N'ad1  ', CAST(0x0000A58B00BDECF5 AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IB16010101', N'B    ', N'10002', 222, N'ad2  ', CAST(0x0000A5840103BF30 AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IB16010102', N'B    ', N'10008', 123, N'ad2  ', CAST(0x0000A58401033A4F AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IB16010103', N'B    ', N'10001', 500, N'ad1  ', CAST(0x0000A58800FE69F6 AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IB16010104', N'B    ', N'10003', 50, N'ad1  ', CAST(0x0000A58B00B33978 AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IC16010101', N'C    ', N'10001', 10, N'ad2  ', CAST(0x0000A58601058AB7 AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IC16010102', N'C    ', N'10001', 321, N'ad1  ', CAST(0x0000A584010334DC AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IC16010103', N'C    ', N'10008', 451, N'ad1  ', CAST(0x0000A584010337AE AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IC16010104', N'C    ', N'10001', 50, N'ad1  ', CAST(0x0000A588010BD929 AS DateTime))
INSERT [dbo].[入库] ([入库单号], [仓库编号], [货物编号], [入库量], [管理员编号], [入库时间]) VALUES (N'IC16010105', N'C    ', N'10001', 50, N'ad1  ', CAST(0x0000A588010C0849 AS DateTime))
/****** Object:  Table [dbo].[出库]    Script Date: 01/13/2016 11:10:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[出库](
	[出库单号] [varchar](10) NOT NULL,
	[仓库编号] [char](5) NOT NULL,
	[货物编号] [char](5) NOT NULL,
	[出库量] [int] NOT NULL,
	[客户号] [varchar](5) NULL,
	[管理员编号] [char](5) NULL,
	[出库时间] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[出库单号] ASC,
	[仓库编号] ASC,
	[货物编号] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[出库] ([出库单号], [仓库编号], [货物编号], [出库量], [客户号], [管理员编号], [出库时间]) VALUES (N'OA16010101', N'A    ', N'10001', 10, N'王五 ', N'ad1  ', CAST(0x0000A58700E70E4C AS DateTime))
INSERT [dbo].[出库] ([出库单号], [仓库编号], [货物编号], [出库量], [客户号], [管理员编号], [出库时间]) VALUES (N'OA16010102', N'A    ', N'10001', 100, N'张三 ', N'ad1  ', CAST(0x0000A58700CD3E2E AS DateTime))
INSERT [dbo].[出库] ([出库单号], [仓库编号], [货物编号], [出库量], [客户号], [管理员编号], [出库时间]) VALUES (N'OA16010103', N'A    ', N'10003', 10, N'刘六 ', N'ad1  ', CAST(0x0000A58700F8D89B AS DateTime))
INSERT [dbo].[出库] ([出库单号], [仓库编号], [货物编号], [出库量], [客户号], [管理员编号], [出库时间]) VALUES (N'OA16010104', N'A    ', N'10001', 100, N'Jim  ', N'ad2  ', CAST(0x0000A588010F7452 AS DateTime))
INSERT [dbo].[出库] ([出库单号], [仓库编号], [货物编号], [出库量], [客户号], [管理员编号], [出库时间]) VALUES (N'OA16010105', N'A    ', N'10008', 19, N'黄盖 ', N'admin', CAST(0x0000A58A00B10EBC AS DateTime))
INSERT [dbo].[出库] ([出库单号], [仓库编号], [货物编号], [出库量], [客户号], [管理员编号], [出库时间]) VALUES (N'OB16010101', N'B    ', N'10002', 51, N'张三 ', N'ad1  ', CAST(0x0000A5860106FD0F AS DateTime))
INSERT [dbo].[出库] ([出库单号], [仓库编号], [货物编号], [出库量], [客户号], [管理员编号], [出库时间]) VALUES (N'OB16010102', N'B    ', N'10001', 100, N'Jim  ', N'ad2  ', CAST(0x0000A588011009C2 AS DateTime))
INSERT [dbo].[出库] ([出库单号], [仓库编号], [货物编号], [出库量], [客户号], [管理员编号], [出库时间]) VALUES (N'OC16010101', N'C    ', N'10001', 10, N'小明 ', N'ad1  ', CAST(0x0000A58600FE9ACD AS DateTime))
INSERT [dbo].[出库] ([出库单号], [仓库编号], [货物编号], [出库量], [客户号], [管理员编号], [出库时间]) VALUES (N'OC16010102', N'C    ', N'10008', 10, N'Jack ', N'ad1  ', CAST(0x0000A58801127107 AS DateTime))
INSERT [dbo].[出库] ([出库单号], [仓库编号], [货物编号], [出库量], [客户号], [管理员编号], [出库时间]) VALUES (N'OC16010103', N'C    ', N'10001', 21, N'Jack ', N'ad1  ', CAST(0x0000A58801130702 AS DateTime))
/****** Object:  StoredProcedure [dbo].[huowu_proc]    Script Date: 01/13/2016 11:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[huowu_proc] @status int,@huowu char(5)
as
	if(@status =0 ) begin select * from huowu_view end
	if(@status =1) begin select * from huowu_view where 货物编号=@huowu end
GO
/****** Object:  StoredProcedure [dbo].[kucun_proc]    Script Date: 01/13/2016 11:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[kucun_proc] @choice int,@cangku char(5),@huowu char(5)
as
	if(@choice =0) begin select * from dbo.kucun_view order by 仓库编号 end
	if(@choice =1) begin select * from dbo.kucun_view where @cangku=仓库编号 end
	if(@choice =2) begin select * from dbo.kucun_view where @huowu=货物编号 end
	if(@choice =3) begin select * from dbo.kucun_view order by 货物编号 end
GO
/****** Object:  StoredProcedure [dbo].[selectJieH_proc]    Script Date: 01/13/2016 11:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[selectJieH_proc] @jie int,@para varchar(10)
as															---------------借还信息查询
	if(@jie =0) 
		begin select 借条号,仓库编号,货物编号,借还量,管理员编号,借入人,借出日期,归还日期=
				case	
					when CAST(归还日期 as int)=0 then '未归还'
					else '已归还'
					end
				from 借还 end
	if(@jie =1) 
		begin select 借条号,仓库编号,货物编号,借还量,管理员编号,借入人,借出日期,归还日期=
				case	
					when CAST(归还日期 as int)=0 then '未归还'
					else '已归还'
					end
				from 借还  where @para=仓库编号 end-------------查仓库借还情况
	if(@jie =2) 
		begin select 借条号,仓库编号,货物编号,借还量,管理员编号,借入人,借出日期,归还日期=
				case	
					when CAST(归还日期 as int)=0 then '未归还'
					else '已归还'
					end
				from 借还 where @para=借条号 end--------------查借条号情况
	if(@jie =3) 
		begin select 借条号,仓库编号,货物编号,借还量,管理员编号,借入人,借出日期,归还日期=
				case	
					when CAST(归还日期 as int)=0 then '未归还'
					else '已归还'
					end
				from 借还 
		where CONVERT(varchar(4),Year(借出日期))+'年'+convert(varchar(2),Month(借出日期))+'月'+ convert(varchar(2),Day(借出日期) )+'日 '+DateName(hour,借出日期)+'：'+DateName(MINUTE,借出日期) like @para+'%' end
	if(@jie =4) 
		begin 
		select 借条号,仓库编号,货物编号,借还量,管理员编号,借入人,借出日期,归还日期='未归还'
		from 借还 
		where CAST(归还日期 as int)=0
	end
GO
/****** Object:  StoredProcedure [dbo].[alterkucun_proc]    Script Date: 01/13/2016 11:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[alterkucun_proc] @cangku char(5),@huowu char(5),@min int,@max int,@status int output
as
	if(@cangku <>'' and @huowu<>'')
	begin
		update 库存设置 set 最小值=@min,最大值=@max where @cangku=仓库编号 and @huowu=货物编号
		set @status=0-------------修改成功
	end
	else set @status=1--------请选择仓库和货物编号
GO
/****** Object:  StoredProcedure [dbo].[selec_proc]    Script Date: 01/13/2016 11:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[selec_proc] @in int,@status int
as
	if(@in =1 )
		begin 
		if(@status =1) begin select distinct 入库单号 from 入库 end
		if(@status =2) begin select distinct 仓库编号 from 入库 end
		if(@status =3) begin select distinct CONVERT(varchar(4),Year(入库时间))+'年'+convert(varchar(2),Month(入库时间))+'月'+ convert(varchar(2),Day(入库时间) )+'日 ' from 入库 end
		end
	else if(@in =0)
		begin
		if(@status =1) begin select distinct 出库单号 from 出库 end	
		if(@status =2) begin select distinct 仓库编号 from 出库 end	
		if(@status =3) begin select distinct CONVERT(varchar(4),Year(出库时间))+'年'+convert(varchar(2),Month(出库时间))+'月'+ convert(varchar(2),Day(出库时间) )+'日 ' from 出库 end
		end
GO
/****** Object:  StoredProcedure [dbo].[out_proc]    Script Date: 01/13/2016 11:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[out_proc] (@cangku char(5),@huowu char(5),@num int,@kehu char(5),@admin varchar(5),@status int output)
as				-----------------------出库
	if(@cangku not in(select 仓库编号 from 仓库)) begin set @status=4 end--------无此仓库		
	else if(@huowu not in(select 货物编号 from 库存 where @cangku=仓库编号))
		begin	set @status=1 end-----------------该仓库无此货物					
	else 
		begin
			declare @nowkucun int
			set @nowkucun=(select 库存量 from 库存 where @cangku=库存.仓库编号 and @huowu=库存.货物编号)
			if(@nowkucun <@num) begin set @status=2 end---------库存不足
			else 
				begin
					declare @No varchar(10)
					set @No= (select MAX(CAST(substring(出库单号,3,LEN(出库单号)-1) as int))+1 from 出库 where @cangku=仓库编号 )
					if(@No is null) set @No='O'+rtrim(ltrim(@cangku))+'16010101'
					else set @No= 'O'+rtrim(ltrim(@cangku)) + @No											
					insert into 出库(出库单号,仓库编号,货物编号,出库量,客户号,管理员编号)
					values(@No,@cangku,@huowu,@num,@kehu,@admin)
					update 库存 set 库存量=库存量-@num
					where @cangku=库存.仓库编号 and @huowu=库存.货物编号
					set @status=3   -----------------出库成功 						
				end
		end
GO
/****** Object:  StoredProcedure [dbo].[jiechu_proc]    Script Date: 01/13/2016 11:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[jiechu_proc] (@cangku char(5),@huowu char(5),@num int,@person char(5),@admin varchar(5),@status1 int output,@No varchar(10) output)
as											--------------借出
begin
	if(@cangku not in(select 仓库编号 from 库存)) begin set @status1=4 end ----仓库不存在
	else if(@huowu not in(select 货物编号 from 库存 where 仓库编号=@cangku)) begin set @status1=1 end---该仓库没有此货物
	else if(@num >(select 库存量 from 库存 where @cangku=仓库编号 and @huowu=货物编号)) begin set @status1=2 end---库存不足
	else 
		begin
		set @No= (select MAX(CAST(substring(借条号,3,LEN(借条号)-1) as int))+1 from 借还  )
		set @No= 'JT' + @No
		set @No= ISNULL(@No,'JT00001')	
		insert into 借还(借条号,仓库编号,货物编号,借还量,借入人,管理员编号)
		values(@No,@cangku,@huowu,@num,@person,@admin)		
		insert into 出库(出库单号,仓库编号,货物编号,出库量,客户号,管理员编号)
					values(@No,@cangku,@huowu,@num,@person,@admin)
		update 库存 set 库存量=库存量-@num
		where @cangku=库存.仓库编号 and @huowu=库存.货物编号
					set @status1=3   -----------------出库成功 			
		end		
end
GO
/****** Object:  StoredProcedure [dbo].[InOutStatus_proc]    Script Date: 01/13/2016 11:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InOutStatus_proc] @in int,@status int,@para varchar(10)
as								--------------查询出入库信息
	if(@in = 1) 
		begin
			if(@status =0)	begin select * from 入库 end
			if(@status =1)	begin select *from 入库 where @para=入库单号 end
			if(@status =2)	begin select *from 入库 where @para=仓库编号 end
			if(@status =3)  begin select *from 入库 
			where CONVERT(varchar(4),Year(入库时间))+'年'+convert(varchar(2),Month(入库时间))+'月'+ convert(varchar(2),Day(入库时间) )+'日 '+DateName(hour,入库时间)+'：'+DateName(MINUTE,入库时间) like @para+'%' end
		end
	else if(@in =0)
		begin
			if(@status=0) begin select * from 出库 end
			if(@status=1) begin select * from 出库 where @para=出库单号 end
			if(@status=2) begin select * from 出库 where @para=仓库编号 end
			if(@status=3) begin select * from 出库 
			where CONVERT(varchar(4),Year(出库时间))+'年'+convert(varchar(2),Month(出库时间))+'月'+ convert(varchar(2),Day(出库时间) )+'日 '+DateName(hour,出库时间)+'：'+DateName(MINUTE,出库时间) like @para+'%' end
		end
GO
/****** Object:  StoredProcedure [dbo].[in_proc]    Script Date: 01/13/2016 11:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[in_proc] @cangku char(5),@huowu char(5),@num int,@admin varchar(5),@status int output
as								----------入库
			if(@cangku not in(select 仓库编号 from 仓库)) begin set @status=3 end ------无此仓库
			else if(@huowu not in(select 货物编号 from 货物)) begin set @status=4 end ------无此货物
			else if(@huowu not in(select 货物编号 from 库存设置 where 仓库编号=@cangku) and @num>1000)
					begin insert into 库存设置(仓库编号,货物编号) values(@cangku,@huowu)
							set @status=0 end------------------数量超过默认设置，请先修改设置再入库		
			else			
				begin
				declare @nowkucun int,@max_kucun int
				set @nowkucun=(select 库存量 from 库存 where @cangku=仓库编号 and @huowu=货物编号)
				if(@nowkucun is null) set @nowkucun=0
				set @max_kucun=(select 最大值 from 库存设置 where @cangku=库存设置.仓库编号 and @huowu=库存设置.货物编号)
				if(@nowkucun+@num >@max_kucun) 
					begin	set @status=1 end-----------入库后超过容量
				else begin
					declare @No varchar(10)
					set @No= (select MAX(CAST(substring(入库单号,3,LEN(入库单号)-1) as int))+1 from 入库 where @cangku=仓库编号 )
					if(@No is null) set @No='I'+rtrim(ltrim(@cangku))+'16010101'-----第一个入库单号
					else set @No= 'I'+rtrim(ltrim(@cangku)) + @No					
					insert into 入库(入库单号,仓库编号,货物编号,入库量,管理员编号)
					values(@No,@cangku,@huowu,@num,@admin)
					update 库存 set 库存量=库存量+ @num
					where @cangku=库存.仓库编号 and @huowu=库存.货物编号
					set @status=2 end-------------------入库成功
				end
GO
/****** Object:  StoredProcedure [dbo].[guihuan_proc]    Script Date: 01/13/2016 11:10:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[guihuan_proc] (@No varchar(10),@admin varchar(5),@status int output)
as
begin				--有借条并符合信息才能归还，否则无法归还
	declare @num int,@cangku char(5),@huowu char(5)
	if(@No in (select 借条号 from 借还 where 归还日期=0))
		begin
			set @num=(select 借还量 from 借还 where @No=借条号)
			set @cangku=(select 仓库编号 from 借还 where @No=借条号)
			set @huowu=(select 货物编号 from 借还 where @No=借条号)
			declare @nowkucun int,@max_kucun int
			set @nowkucun=(select 库存量 from 库存 where @cangku=库存.仓库编号 and @huowu=库存.货物编号)
			set @max_kucun=(select 最大值 from 库存设置 where @cangku=库存设置.仓库编号 and @huowu=库存设置.货物编号)
			if(@nowkucun+@num >@max_kucun) 
			begin	set @status=1 end-----------------------------归还后超过容量	
			else begin		
				insert into 入库(入库单号,仓库编号,货物编号,入库量,管理员编号)
				values(@No,@cangku,@huowu,@num,@admin)								
				update 借还 set 归还日期=GETDATE() where @cangku=仓库编号 and @huowu=货物编号 and @No=借条号
				update 库存 set 库存量=库存量+ @num where @cangku=库存.仓库编号 and @huowu=库存.货物编号
				set @status=2--------------------------------------归还成功
				end			
		end
	else
		begin set @status=3 end	---------此借条无法归还------	
end
GO
/****** Object:  Default [DF__出库__出库时间__6D0D32F4]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[出库] ADD  DEFAULT (getdate()) FOR [出库时间]
GO
/****** Object:  Default [DF__借还__借出日期__19DFD96B]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[借还] ADD  DEFAULT ((0)) FOR [借出日期]
GO
/****** Object:  Default [DF__借还__归还日期__1AD3FDA4]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[借还] ADD  DEFAULT ((0)) FOR [归还日期]
GO
/****** Object:  Default [DF__库存__库存量__3C34F16F]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[库存] ADD  DEFAULT ((0)) FOR [库存量]
GO
/****** Object:  Default [DF__库存设置__最小值__4F7CD00D]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[库存设置] ADD  DEFAULT ((0)) FOR [最小值]
GO
/****** Object:  Default [DF__库存设置__最大值__5070F446]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[库存设置] ADD  DEFAULT ((1000)) FOR [最大值]
GO
/****** Object:  Default [DF__入库__入库时间__76969D2E]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[入库] ADD  DEFAULT (getdate()) FOR [入库时间]
GO
/****** Object:  Check [CK__出库__出库量__6B24EA82]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[出库]  WITH CHECK ADD CHECK  (([出库量]>(0)))
GO
/****** Object:  Check [CK__供应商__电话__09DE7BCC]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[供应商]  WITH CHECK ADD CHECK  (([电话] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
/****** Object:  Check [CK__借还__借还量__17F790F9]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[借还]  WITH CHECK ADD CHECK  (([借还量]>(0)))
GO
/****** Object:  Check [CK__入库__入库量__74AE54BC]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[入库]  WITH CHECK ADD CHECK  (([入库量]>(0)))
GO
/****** Object:  ForeignKey [FK__出库__管理员编号__6C190EBB]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[出库]  WITH CHECK ADD FOREIGN KEY([管理员编号])
REFERENCES [dbo].[管理员] ([管理员编号])
GO
/****** Object:  ForeignKey [FK__货物__供应商编号__0EA330E9]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[货物]  WITH CHECK ADD FOREIGN KEY([供应商编号])
REFERENCES [dbo].[供应商] ([供应商编号])
GO
/****** Object:  ForeignKey [FK__借还__管理员编号__18EBB532]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[借还]  WITH CHECK ADD FOREIGN KEY([管理员编号])
REFERENCES [dbo].[管理员] ([管理员编号])
GO
/****** Object:  ForeignKey [FK__库存__仓库编号__3B40CD36]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[库存]  WITH CHECK ADD FOREIGN KEY([仓库编号])
REFERENCES [dbo].[仓库] ([仓库编号])
GO
/****** Object:  ForeignKey [FK__库存设置__仓库编号__4E88ABD4]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[库存设置]  WITH CHECK ADD FOREIGN KEY([仓库编号])
REFERENCES [dbo].[仓库] ([仓库编号])
GO
/****** Object:  ForeignKey [FK__库存设置__货物编号__4D94879B]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[库存设置]  WITH CHECK ADD FOREIGN KEY([货物编号])
REFERENCES [dbo].[货物] ([货物编号])
GO
/****** Object:  ForeignKey [FK__入库__管理员编号__75A278F5]    Script Date: 01/13/2016 11:10:56 ******/
ALTER TABLE [dbo].[入库]  WITH CHECK ADD FOREIGN KEY([管理员编号])
REFERENCES [dbo].[管理员] ([管理员编号])
GO
