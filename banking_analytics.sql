-- =====================================================
-- Retail Banking Transaction Analytics
-- Database: MySQL 8 (works on DB Fiddle: db-fiddle.com, choose MySQL 8.0)
-- Reference date used for "recent" analysis: 2025-06-30
-- All data is synthetic.
-- =====================================================

DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS branches;

-- ---------- SCHEMA ----------
CREATE TABLE branches (
    branch_id   INT PRIMARY KEY,
    branch_name VARCHAR(50) NOT NULL,
    city        VARCHAR(30) NOT NULL,
    manager     VARCHAR(50) NOT NULL
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name        VARCHAR(60) NOT NULL,
    city        VARCHAR(30) NOT NULL,
    join_date   DATE NOT NULL,
    branch_id   INT NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE accounts (
    account_id   INT PRIMARY KEY,
    customer_id  INT NOT NULL,
    account_type VARCHAR(20) NOT NULL CHECK (account_type IN ('Savings','Current','Salary')),
    balance      DECIMAL(12,2) NOT NULL CHECK (balance >= 0),
    opened_on    DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE transactions (
    txn_id     INT PRIMARY KEY,
    account_id INT NOT NULL,
    txn_type   VARCHAR(10) NOT NULL CHECK (txn_type IN ('credit','debit')),
    amount     DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    txn_date   DATE NOT NULL,
    channel    VARCHAR(10) NOT NULL CHECK (channel IN ('UPI','ATM','NEFT','POS')),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE loans (
    loan_id     INT PRIMARY KEY,
    customer_id INT NOT NULL,
    loan_type   VARCHAR(20) NOT NULL CHECK (loan_type IN ('Home','Personal','Auto','Education')),
    amount      DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    status      VARCHAR(10) NOT NULL CHECK (status IN ('Active','Closed','Overdue')),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Indexes for common join/filter columns
CREATE INDEX idx_accounts_customer ON accounts(customer_id);
CREATE INDEX idx_txn_account_date  ON transactions(account_id, txn_date);
CREATE INDEX idx_loans_customer    ON loans(customer_id);

-- ---------- SAMPLE DATA ----------
INSERT INTO branches VALUES
(1,'Mumbai Main','Mumbai','R. Nair'),
(2,'Pune Main','Pune','S. Bhatt'),
(3,'Nagpur Main','Nagpur','A. Kapoor'),
(4,'Delhi Main','Delhi','M. Rao'),
(5,'Bengaluru Main','Bengaluru','P. Menon');

INSERT INTO customers VALUES
(1,'Aarav Patil','Mumbai','2021-04-26',1),
(2,'Priya Iyer','Pune','2022-11-02',2),
(3,'Rohan Patil','Bengaluru','2023-06-05',5),
(4,'Sneha Joshi','Delhi','2024-01-17',4),
(5,'Vikram Sharma','Mumbai','2021-12-13',1),
(6,'Anjali Iyer','Bengaluru','2024-02-08',5),
(7,'Karan Gupta','Pune','2019-09-12',2),
(8,'Neha Iyer','Delhi','2021-04-13',4),
(9,'Arjun Sharma','Pune','2019-08-30',2),
(10,'Pooja Deshmukh','Nagpur','2022-08-29',3),
(11,'Rahul Iyer','Nagpur','2023-04-04',3),
(12,'Divya Patil','Delhi','2023-04-26',4),
(13,'Amit Deshmukh','Nagpur','2021-06-08',3),
(14,'Kavya Sharma','Delhi','2023-01-01',4),
(15,'Manish Reddy','Mumbai','2021-02-11',1),
(16,'Isha Joshi','Nagpur','2022-03-31',3),
(17,'Suresh Patil','Mumbai','2021-11-05',1),
(18,'Meera Singh','Mumbai','2021-10-16',1),
(19,'Nikhil Patil','Delhi','2021-04-14',4),
(20,'Riya Kulkarni','Nagpur','2022-07-30',3),
(21,'Sanjay Deshmukh','Nagpur','2022-01-19',3),
(22,'Tanvi Singh','Mumbai','2022-06-26',1),
(23,'Deepak Gupta','Pune','2022-07-27',2),
(24,'Shruti Kulkarni','Delhi','2021-05-17',4),
(25,'Varun Gupta','Pune','2020-10-06',2),
(26,'Pallavi Sharma','Pune','2024-01-16',2),
(27,'Harsh Deshmukh','Delhi','2021-05-26',4),
(28,'Nisha Patil','Pune','2020-11-15',2),
(29,'Yash Iyer','Delhi','2019-12-19',4),
(30,'Komal Kulkarni','Pune','2021-06-07',2);

INSERT INTO accounts VALUES
(1,1,'Salary',217074.74,'2021-06-02'),
(2,2,'Savings',113563.78,'2022-11-10'),
(3,3,'Current',127273.0,'2023-06-08'),
(4,4,'Salary',80656.45,'2024-01-27'),
(5,5,'Salary',213969.18,'2021-12-17'),
(6,6,'Savings',299964.77,'2024-03-08'),
(7,7,'Current',875416.62,'2019-11-06'),
(8,8,'Salary',341740.29,'2021-04-20'),
(9,9,'Current',506424.78,'2019-09-16'),
(10,10,'Salary',173386.86,'2022-09-16'),
(11,11,'Savings',229593.23,'2023-05-20'),
(12,12,'Salary',135377.58,'2023-05-28'),
(13,13,'Salary',256302.43,'2021-06-14'),
(14,14,'Salary',152730.17,'2023-02-10'),
(15,15,'Current',219074.44,'2021-03-06'),
(16,16,'Salary',271992.62,'2022-05-19'),
(17,17,'Salary',459654.28,'2021-12-13'),
(18,18,'Savings',14640.99,'2021-12-14'),
(19,19,'Savings',492734.08,'2021-06-04'),
(20,20,'Savings',33672.96,'2022-09-24'),
(21,21,'Current',116943.49,'2022-03-06'),
(22,22,'Savings',39260.2,'2022-08-13'),
(23,23,'Current',156896.43,'2022-09-07'),
(24,24,'Savings',277152.78,'2021-06-02'),
(25,25,'Current',565604.83,'2020-10-19'),
(26,26,'Salary',378856.27,'2024-02-29'),
(27,27,'Savings',159299.56,'2021-07-07'),
(28,28,'Current',422385.07,'2020-12-18'),
(29,29,'Savings',127713.28,'2019-12-23'),
(30,30,'Savings',296212.82,'2021-06-21'),
(31,5,'Current',56112.21,'2022-01-27'),
(32,8,'Current',244600.52,'2021-06-09'),
(33,24,'Savings',168562.1,'2021-06-18'),
(34,18,'Savings',336144.0,'2021-10-29'),
(35,27,'Current',664849.68,'2021-07-21'),
(36,9,'Current',451770.37,'2019-10-19');

INSERT INTO transactions VALUES
(1,1,'credit',12269.81,'2025-04-15','NEFT'),
(2,1,'debit',7111.97,'2025-04-01','UPI'),
(3,1,'debit',9763.46,'2025-06-22','UPI'),
(4,1,'debit',12048.77,'2025-04-14','UPI'),
(5,1,'credit',45221.43,'2025-03-05','UPI'),
(6,1,'credit',39697.11,'2025-04-19','UPI'),
(7,1,'debit',12868.31,'2025-04-24','UPI'),
(8,1,'debit',8200.7,'2025-01-13','UPI'),
(9,1,'debit',12760.7,'2025-01-24','UPI'),
(10,1,'debit',3363.46,'2025-04-15','NEFT'),
(11,1,'credit',5161.65,'2025-01-16','NEFT'),
(12,1,'debit',11819.91,'2025-03-09','ATM'),
(13,1,'debit',11011.48,'2025-04-19','POS'),
(14,1,'debit',2490.99,'2025-06-19','ATM'),
(15,1,'debit',8771.87,'2025-02-25','POS'),
(16,1,'debit',1046.05,'2025-01-16','POS'),
(17,1,'debit',12820.25,'2025-05-03','UPI'),
(18,1,'debit',1385.65,'2025-01-15','UPI'),
(19,1,'debit',10193.15,'2025-01-18','UPI'),
(20,1,'credit',71771.55,'2025-04-14','UPI'),
(21,1,'debit',9366.85,'2025-05-29','NEFT'),
(22,2,'debit',3223.04,'2025-03-22','ATM'),
(23,2,'credit',14815.87,'2025-03-03','ATM'),
(24,2,'credit',61389.84,'2025-04-28','UPI'),
(25,2,'debit',14977.13,'2025-01-03','UPI'),
(26,2,'debit',7687.09,'2025-01-19','UPI'),
(27,2,'debit',13213.2,'2025-03-31','ATM'),
(28,2,'credit',67530.87,'2025-03-14','ATM'),
(29,2,'debit',12145.08,'2025-06-06','POS'),
(30,2,'debit',8408.11,'2025-01-03','UPI'),
(31,2,'credit',71728.45,'2025-02-04','POS'),
(32,2,'credit',50362.24,'2025-02-09','ATM'),
(33,2,'debit',12823.11,'2025-02-22','POS'),
(34,2,'credit',73111.93,'2025-05-06','UPI'),
(35,2,'debit',12474.35,'2025-01-24','UPI'),
(36,2,'credit',14811.47,'2025-01-01','ATM'),
(37,2,'debit',8364.87,'2025-02-11','NEFT'),
(38,2,'credit',10643.29,'2025-05-24','UPI'),
(39,2,'credit',32691.2,'2025-05-20','POS'),
(40,2,'debit',819.07,'2025-02-07','ATM'),
(41,2,'debit',3309.13,'2025-01-11','UPI'),
(42,2,'credit',63508.72,'2025-06-20','NEFT'),
(43,2,'debit',13901.3,'2025-06-08','UPI'),
(44,3,'debit',566.84,'2025-02-15','ATM'),
(45,3,'debit',12988.15,'2025-04-16','UPI'),
(46,3,'credit',57595.86,'2025-03-10','NEFT'),
(47,3,'debit',3492.02,'2025-01-10','NEFT'),
(48,3,'credit',64650.91,'2025-03-31','UPI'),
(49,3,'credit',19484.73,'2025-02-27','ATM'),
(50,3,'debit',14509.96,'2025-03-13','ATM'),
(51,3,'debit',6115.24,'2025-03-31','POS'),
(52,3,'debit',1907.06,'2025-03-26','ATM'),
(53,3,'debit',14756.55,'2025-02-15','UPI'),
(54,3,'debit',5316.17,'2025-01-28','ATM'),
(55,3,'debit',7769.06,'2025-04-22','NEFT'),
(56,3,'credit',8328.99,'2025-05-28','NEFT'),
(57,3,'debit',12136.36,'2025-01-01','UPI'),
(58,3,'debit',14243.34,'2025-04-04','ATM'),
(59,3,'credit',68601.15,'2025-06-09','ATM'),
(60,4,'debit',5027.51,'2025-03-21','ATM'),
(61,4,'credit',36533.48,'2025-05-22','NEFT'),
(62,4,'debit',2775.6,'2025-06-23','POS'),
(63,4,'debit',12539.13,'2025-03-19','ATM'),
(64,4,'credit',63931.91,'2025-03-15','POS'),
(65,4,'credit',38133.95,'2025-06-17','UPI'),
(66,4,'debit',13537.48,'2025-05-11','UPI'),
(67,4,'credit',43658.9,'2025-06-18','POS'),
(68,4,'credit',76399.97,'2025-03-27','UPI'),
(69,4,'credit',65492.22,'2025-06-22','UPI'),
(70,4,'credit',78795.2,'2025-01-07','POS'),
(71,4,'debit',13314.83,'2025-01-19','POS'),
(72,4,'debit',5882.88,'2025-02-19','NEFT'),
(73,4,'credit',56571.68,'2025-03-04','UPI'),
(74,4,'credit',65308.24,'2025-04-19','POS'),
(75,4,'credit',23689.87,'2025-04-29','UPI'),
(76,4,'credit',39848.24,'2025-04-27','POS'),
(77,4,'debit',14260.59,'2025-05-24','NEFT'),
(78,4,'debit',13401.9,'2025-06-06','NEFT'),
(79,4,'debit',2555.54,'2025-05-21','NEFT'),
(80,4,'credit',23542.98,'2025-04-26','ATM'),
(81,4,'debit',3740.84,'2025-05-14','NEFT'),
(82,5,'credit',30188.57,'2025-03-15','POS'),
(83,5,'credit',22344.61,'2025-01-21','UPI'),
(84,5,'credit',36115.09,'2025-06-30','ATM'),
(85,6,'debit',3261.15,'2025-04-30','NEFT'),
(86,6,'debit',8844.38,'2025-04-10','UPI'),
(87,6,'credit',5442.21,'2025-05-28','ATM'),
(88,6,'debit',12831.03,'2025-03-18','NEFT'),
(89,6,'debit',8282.76,'2025-05-18','POS'),
(90,6,'debit',4239.44,'2025-02-26','NEFT'),
(91,6,'credit',55165.52,'2025-01-08','NEFT'),
(92,7,'debit',13809.22,'2025-02-12','POS'),
(93,7,'credit',34551.52,'2025-05-17','POS'),
(94,7,'credit',53206.22,'2025-06-19','UPI'),
(95,7,'credit',24511.72,'2025-04-29','ATM'),
(96,7,'debit',5195.01,'2025-02-24','NEFT'),
(97,7,'debit',12512.48,'2025-03-13','ATM'),
(98,7,'debit',11285.56,'2025-01-21','UPI'),
(99,7,'credit',10146.38,'2025-03-31','UPI'),
(100,8,'debit',3150.54,'2025-01-08','UPI'),
(101,8,'credit',14466.57,'2025-06-09','UPI'),
(102,8,'debit',7082.5,'2025-05-25','ATM'),
(103,8,'credit',50543.56,'2025-04-05','UPI'),
(104,8,'debit',1799.86,'2025-02-11','UPI'),
(105,8,'debit',13638.79,'2025-03-21','NEFT'),
(106,8,'debit',3135.28,'2025-04-12','POS'),
(107,8,'debit',3794.17,'2025-06-26','ATM'),
(108,8,'debit',1991.61,'2025-06-25','POS'),
(109,9,'credit',37128.35,'2025-01-11','ATM'),
(110,9,'debit',5250.22,'2025-01-18','NEFT'),
(111,9,'credit',77059.07,'2025-05-06','NEFT'),
(112,9,'debit',11060.17,'2025-02-09','ATM'),
(113,9,'debit',8164.96,'2025-06-07','NEFT'),
(114,9,'debit',11019.19,'2025-04-30','ATM'),
(115,9,'debit',12494.82,'2025-03-24','UPI'),
(116,9,'debit',3809.18,'2025-03-13','NEFT'),
(117,9,'debit',5809.04,'2025-05-26','UPI'),
(118,10,'credit',20908.99,'2025-03-25','ATM'),
(119,10,'credit',49711.63,'2025-03-29','ATM'),
(120,10,'credit',76104.69,'2025-05-23','UPI'),
(121,10,'debit',7430.95,'2025-03-03','UPI'),
(122,10,'debit',10735.27,'2025-06-26','NEFT'),
(123,10,'credit',21619.73,'2025-01-05','UPI'),
(124,11,'debit',7204.26,'2025-06-19','POS'),
(125,11,'debit',11239.84,'2025-03-30','ATM'),
(126,11,'debit',4209.56,'2025-04-01','ATM'),
(127,11,'credit',19443.82,'2025-03-01','UPI'),
(128,11,'debit',10414.42,'2025-05-18','UPI'),
(129,12,'credit',49219.02,'2025-05-04','POS'),
(130,12,'credit',12539.46,'2025-06-02','UPI'),
(131,12,'credit',18458.12,'2025-03-17','UPI'),
(132,12,'credit',8413.68,'2025-05-17','UPI'),
(133,13,'debit',2068.94,'2025-03-16','NEFT'),
(134,13,'debit',8696.15,'2025-01-27','NEFT'),
(135,13,'debit',2928.58,'2025-05-03','UPI'),
(136,13,'debit',7270.39,'2025-03-06','UPI'),
(137,13,'debit',8739.91,'2025-04-13','UPI'),
(138,13,'credit',47212.97,'2025-02-08','ATM'),
(139,13,'debit',1953.08,'2025-01-22','NEFT'),
(140,14,'debit',3540.17,'2025-06-02','POS'),
(141,14,'debit',6752.27,'2025-04-08','POS'),
(142,14,'credit',51577.05,'2025-04-20','POS'),
(143,14,'debit',3275.26,'2025-01-26','UPI'),
(144,14,'debit',2524.44,'2025-03-09','UPI'),
(145,14,'credit',5200.68,'2025-05-22','NEFT'),
(146,14,'debit',4510.64,'2025-06-26','UPI'),
(147,15,'credit',69470.5,'2025-06-30','UPI'),
(148,15,'credit',24841.6,'2025-06-25','POS'),
(149,15,'debit',3127.72,'2025-06-19','UPI'),
(150,15,'credit',16174.21,'2025-05-20','ATM'),
(151,15,'credit',17444.21,'2025-02-06','ATM'),
(152,16,'debit',6699.47,'2025-05-26','NEFT'),
(153,16,'credit',35188.14,'2025-06-26','ATM'),
(154,16,'debit',6678.83,'2025-05-09','POS'),
(155,16,'debit',11071.1,'2025-01-11','POS'),
(156,16,'credit',22169.33,'2025-03-06','POS'),
(157,16,'debit',14993.67,'2025-05-31','ATM'),
(158,16,'credit',61720.16,'2025-05-28','NEFT'),
(159,17,'debit',4316.72,'2025-06-16','POS'),
(160,17,'debit',7477.54,'2025-04-22','UPI'),
(161,17,'credit',29998.13,'2025-05-01','UPI'),
(162,17,'credit',57025.53,'2025-02-11','ATM'),
(163,17,'debit',12240.78,'2025-06-19','POS'),
(164,17,'debit',4854.85,'2025-01-10','ATM'),
(165,17,'debit',6181.79,'2025-01-30','POS'),
(166,18,'debit',8230.39,'2025-01-01','NEFT'),
(167,18,'credit',32133.45,'2025-01-14','NEFT'),
(168,18,'debit',963.85,'2025-06-10','ATM'),
(169,18,'credit',26602.19,'2025-05-21','NEFT'),
(170,18,'credit',52251.67,'2025-02-01','UPI'),
(171,18,'credit',6025.58,'2025-02-10','NEFT'),
(172,18,'credit',68105.43,'2025-01-24','UPI'),
(173,18,'debit',9786.1,'2025-04-29','UPI'),
(174,18,'debit',4519.55,'2025-05-08','ATM'),
(175,19,'debit',3807.22,'2025-05-04','POS'),
(176,19,'credit',74140.11,'2025-02-07','POS'),
(177,19,'debit',4288.46,'2025-02-04','NEFT'),
(178,19,'debit',7714.52,'2025-03-29','UPI'),
(179,19,'debit',12594.64,'2025-03-14','POS'),
(180,19,'debit',2399.21,'2025-06-18','POS'),
(181,20,'credit',62215.45,'2025-03-30','NEFT'),
(182,20,'debit',13070.1,'2025-04-27','UPI'),
(183,20,'credit',69200.97,'2025-05-27','NEFT'),
(184,20,'credit',40473.22,'2025-01-12','NEFT'),
(185,20,'debit',11927.43,'2025-04-09','UPI'),
(186,20,'debit',2068.44,'2025-05-07','POS'),
(187,21,'debit',6716.53,'2025-01-26','POS'),
(188,21,'credit',15811.66,'2025-04-27','UPI'),
(189,21,'debit',14544.21,'2025-01-20','ATM'),
(190,21,'debit',9817.58,'2025-06-09','ATM'),
(191,21,'debit',5824.14,'2025-06-22','ATM'),
(192,22,'debit',731.31,'2025-05-05','UPI'),
(193,22,'debit',13829.75,'2025-03-02','UPI'),
(194,22,'debit',1656.96,'2025-01-24','UPI'),
(195,22,'credit',27459.96,'2025-04-24','UPI'),
(196,22,'credit',9208.94,'2025-01-12','ATM'),
(197,22,'debit',3814.12,'2025-04-06','NEFT'),
(198,22,'debit',2864.84,'2025-05-25','UPI'),
(199,22,'debit',5861.66,'2025-01-21','UPI'),
(200,23,'credit',39586.24,'2025-05-30','ATM'),
(201,23,'credit',5704.81,'2025-04-28','NEFT'),
(202,23,'debit',2538.04,'2025-03-15','NEFT'),
(203,23,'debit',4627.48,'2025-03-30','NEFT'),
(204,23,'credit',68397.79,'2025-06-26','UPI'),
(205,23,'debit',1778.47,'2025-04-09','NEFT'),
(206,24,'debit',14891.84,'2025-04-02','ATM'),
(207,24,'debit',9941.8,'2025-01-06','ATM'),
(208,24,'debit',10349.83,'2025-01-03','UPI'),
(209,24,'debit',12526.02,'2025-06-05','ATM'),
(210,24,'debit',5414.35,'2025-02-28','UPI'),
(211,24,'credit',61668.3,'2025-06-08','UPI'),
(212,24,'credit',52059.36,'2025-06-10','UPI'),
(213,25,'credit',32364.59,'2025-04-23','UPI'),
(214,25,'debit',5035.44,'2025-01-24','NEFT'),
(215,25,'credit',63988.46,'2025-02-14','ATM'),
(216,25,'debit',4233.4,'2025-05-16','UPI'),
(217,25,'debit',14173.98,'2025-03-07','ATM'),
(218,26,'debit',7131.3,'2025-03-28','UPI'),
(219,26,'debit',3539.1,'2025-02-06','NEFT'),
(220,26,'credit',64301.15,'2025-05-23','UPI'),
(221,26,'debit',6930.83,'2025-03-09','ATM'),
(222,26,'credit',52891.2,'2025-05-30','ATM'),
(223,26,'debit',7177.86,'2025-01-28','POS'),
(224,26,'credit',50756.16,'2025-05-24','UPI'),
(225,26,'debit',13658.94,'2025-06-12','ATM'),
(226,27,'credit',8401.01,'2025-04-15','UPI'),
(227,27,'debit',1918.58,'2025-03-19','UPI'),
(228,27,'credit',39023.28,'2025-05-18','POS'),
(229,27,'debit',10953.67,'2025-04-18','NEFT'),
(230,27,'credit',41701.03,'2025-06-17','NEFT'),
(231,27,'credit',32789.75,'2025-03-13','NEFT'),
(232,27,'debit',12860.66,'2025-04-24','UPI'),
(233,27,'credit',72627.22,'2025-06-25','ATM'),
(234,28,'credit',77615.52,'2025-04-12','NEFT'),
(235,28,'debit',9697.23,'2025-01-24','POS'),
(236,28,'credit',30013.19,'2025-01-06','UPI'),
(237,29,'credit',67236.34,'2025-05-25','POS'),
(238,29,'debit',12233.18,'2025-02-23','UPI'),
(239,29,'debit',11871.93,'2025-03-26','POS'),
(240,29,'credit',78802.11,'2025-01-01','UPI'),
(241,29,'credit',18087.28,'2025-05-19','UPI'),
(242,29,'credit',64248.85,'2025-02-03','UPI'),
(243,29,'credit',18068.47,'2025-05-31','UPI'),
(244,29,'debit',7986.07,'2025-02-02','UPI'),
(245,29,'debit',5558.18,'2025-05-02','POS'),
(246,30,'credit',18935.61,'2025-01-29','UPI'),
(247,30,'debit',9431.83,'2025-02-16','UPI'),
(248,31,'debit',8812.34,'2025-01-31','UPI'),
(249,31,'debit',1933.07,'2025-02-01','UPI'),
(250,32,'credit',1780.8,'2025-02-08','NEFT'),
(251,32,'debit',7927.64,'2025-02-09','NEFT'),
(252,32,'debit',2433.98,'2025-01-30','UPI'),
(253,33,'credit',8886.36,'2025-02-11','ATM'),
(254,33,'debit',16634.67,'2025-01-27','POS'),
(255,33,'credit',6594.69,'2025-01-27','NEFT'),
(256,33,'debit',7798.87,'2025-02-12','ATM'),
(257,34,'debit',1809.1,'2025-03-01','UPI'),
(258,34,'debit',2383.01,'2025-01-06','NEFT'),
(259,34,'credit',11349.23,'2025-02-21','NEFT'),
(260,34,'credit',8510.77,'2025-02-12','POS'),
(261,35,'debit',12208.0,'2025-01-04','NEFT'),
(262,35,'credit',3517.24,'2025-01-07','POS'),
(263,35,'credit',7327.22,'2025-01-15','NEFT'),
(264,35,'debit',11694.95,'2025-01-08','POS'),
(265,36,'credit',12375.4,'2025-02-19','NEFT'),
(266,36,'credit',5828.77,'2025-01-02','NEFT'),
(267,36,'debit',7344.96,'2025-02-28','ATM'),
(268,36,'credit',11543.26,'2025-02-25','POS'),
(269,5,'debit',185000.0,'2025-06-18','NEFT'),
(270,9,'debit',240000.0,'2025-06-18','NEFT'),
(271,1,'credit',1534.31,'2025-05-02','UPI'),
(272,1,'credit',6791.17,'2025-05-03','UPI'),
(273,1,'debit',3952.54,'2025-05-04','POS'),
(274,1,'credit',3519.46,'2025-05-05','POS'),
(275,1,'credit',7985.08,'2025-05-06','UPI'),
(276,1,'credit',6863.59,'2025-05-07','UPI'),
(277,1,'credit',2667.29,'2025-05-08','POS'),
(278,1,'debit',5581.56,'2025-05-09','POS'),
(279,1,'debit',2175.45,'2025-05-10','UPI'),
(280,1,'debit',4040.25,'2025-05-11','POS'),
(281,1,'debit',4884.33,'2025-05-12','POS'),
(282,2,'credit',2218.51,'2025-05-02','UPI'),
(283,2,'credit',2078.48,'2025-05-03','UPI'),
(284,2,'credit',6948.2,'2025-05-04','POS'),
(285,2,'debit',1343.86,'2025-05-05','POS'),
(286,2,'debit',1828.54,'2025-05-06','POS'),
(287,2,'credit',4652.28,'2025-05-07','POS'),
(288,2,'credit',3754.52,'2025-05-08','UPI'),
(289,2,'debit',463.05,'2025-05-09','UPI'),
(290,2,'debit',5309.1,'2025-05-10','POS'),
(291,2,'debit',2818.78,'2025-05-11','POS'),
(292,2,'credit',8705.94,'2025-05-12','UPI'),
(293,3,'debit',7538.63,'2025-05-02','POS'),
(294,3,'credit',4099.39,'2025-05-03','UPI'),
(295,3,'credit',4090.39,'2025-05-04','POS'),
(296,3,'credit',3743.17,'2025-05-05','POS'),
(297,3,'debit',2227.68,'2025-05-06','UPI'),
(298,3,'credit',4741.2,'2025-05-07','UPI'),
(299,3,'credit',8181.53,'2025-05-08','POS'),
(300,3,'debit',6628.2,'2025-05-09','UPI'),
(301,3,'credit',1194.4,'2025-05-10','POS'),
(302,3,'credit',1809.44,'2025-05-11','UPI'),
(303,3,'credit',1841.17,'2025-05-12','POS');

INSERT INTO loans VALUES
(1,15,'Education',1200000.00,'Active'),
(2,25,'Home',3400000.00,'Active'),
(3,19,'Auto',1200000.00,'Active'),
(4,29,'Home',4300000.00,'Active'),
(5,28,'Personal',800000.00,'Overdue'),
(6,30,'Auto',1200000.00,'Active'),
(7,22,'Personal',800000.00,'Active'),
(8,26,'Personal',600000.00,'Active'),
(9,21,'Auto',900000.00,'Active'),
(10,24,'Education',800000.00,'Active'),
(11,20,'Personal',500000.00,'Active'),
(12,11,'Home',3400000.00,'Closed'),
(13,23,'Home',5600000.00,'Active'),
(14,5,'Auto',900000.00,'Active'),
(15,27,'Personal',300000.00,'Closed'),
(16,2,'Home',4700000.00,'Active');


-- =====================================================
-- ANALYSIS QUERIES
-- =====================================================

-- Q1. Total and average balance per account type
-- Concept: GROUP BY, aggregate functions
SELECT account_type,
       COUNT(*)            AS total_accounts,
       SUM(balance)        AS total_balance,
       ROUND(AVG(balance),2) AS avg_balance
FROM accounts
GROUP BY account_type
ORDER BY total_balance DESC;

-- Q2. Top 5 customers by total transaction value
-- Concept: multi-table JOIN, ORDER BY, LIMIT
SELECT c.customer_id, c.name, c.city,
       COUNT(t.txn_id) AS txn_count,
       SUM(t.amount)   AS total_txn_value
FROM customers c
JOIN accounts a     ON a.customer_id = c.customer_id
JOIN transactions t ON t.account_id  = a.account_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_txn_value DESC
LIMIT 5;

-- Q3. Accounts with more than 10 transactions in a single month (activity monitoring)
-- Concept: GROUP BY multiple columns, HAVING
SELECT account_id,
       DATE_FORMAT(txn_date, '%Y-%m') AS txn_month,
       COUNT(*) AS txn_count
FROM transactions
GROUP BY account_id, DATE_FORMAT(txn_date, '%Y-%m')
HAVING COUNT(*) > 10
ORDER BY txn_count DESC;

-- Q4. Monthly credit vs debit totals and net flow
-- Concept: CASE WHEN (conditional aggregation)
SELECT DATE_FORMAT(txn_date, '%Y-%m') AS txn_month,
       SUM(CASE WHEN txn_type = 'credit' THEN amount ELSE 0 END) AS total_credit,
       SUM(CASE WHEN txn_type = 'debit'  THEN amount ELSE 0 END) AS total_debit,
       SUM(CASE WHEN txn_type = 'credit' THEN amount ELSE -amount END) AS net_flow
FROM transactions
GROUP BY DATE_FORMAT(txn_date, '%Y-%m')
ORDER BY txn_month;

-- Q5. Dormant accounts: no transaction in the 90 days before 2025-06-30
-- Concept: LEFT JOIN with IS NULL (anti-join)
SELECT a.account_id, a.customer_id, a.account_type, a.balance
FROM accounts a
LEFT JOIN transactions t
       ON t.account_id = a.account_id
      AND t.txn_date >= DATE_SUB('2025-06-30', INTERVAL 90 DAY)
WHERE t.txn_id IS NULL
ORDER BY a.balance DESC;

-- Q6. Customers whose loan is above the average loan amount
-- Concept: subquery
SELECT c.name, l.loan_type, l.amount, l.status
FROM loans l
JOIN customers c ON c.customer_id = l.customer_id
WHERE l.amount > (SELECT AVG(amount) FROM loans)
ORDER BY l.amount DESC;

-- Q7. Rank customers by total balance within each city
-- Concept: window function RANK() OVER (PARTITION BY ...)
SELECT city, name, total_balance,
       RANK() OVER (PARTITION BY city ORDER BY total_balance DESC) AS city_rank
FROM (
    SELECT c.city, c.name, SUM(a.balance) AS total_balance
    FROM customers c
    JOIN accounts a ON a.customer_id = c.customer_id
    GROUP BY c.customer_id, c.city, c.name
) AS cust_bal
ORDER BY city, city_rank;

-- Q8. Flag suspicious debits: amount above 3x the account's average debit
-- Concept: CTE, JOIN on derived table
WITH avg_debit AS (
    SELECT account_id, AVG(amount) AS avg_amt
    FROM transactions
    WHERE txn_type = 'debit'
    GROUP BY account_id
)
SELECT t.txn_id, t.account_id, t.amount, ROUND(d.avg_amt,2) AS account_avg_debit,
       ROUND(t.amount / d.avg_amt, 1) AS times_avg, t.txn_date, t.channel
FROM transactions t
JOIN avg_debit d ON d.account_id = t.account_id
WHERE t.txn_type = 'debit'
  AND t.amount > 3 * d.avg_amt
ORDER BY times_avg DESC;

-- Q9 (bonus). Loan exposure and overdue count per branch
-- Concept: multi-join, conditional aggregation
SELECT b.branch_name, b.city,
       COUNT(l.loan_id) AS total_loans,
       SUM(l.amount)    AS total_loan_amount,
       SUM(CASE WHEN l.status = 'Overdue' THEN 1 ELSE 0 END) AS overdue_loans
FROM branches b
JOIN customers c ON c.branch_id   = b.branch_id
JOIN loans l     ON l.customer_id = c.customer_id
GROUP BY b.branch_id, b.branch_name, b.city
ORDER BY total_loan_amount DESC;
